#!/bin/sh

set -eux

ncurses_version=6.1
readline_version=7.0
lua_version=5.3.5
vim_version=8.1
working_dir=$HOME/tmp
target_dir=$HOME/.local
PY3_VERSION=3.6.5


export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-}:${target_dir}/lib

mkdir -p $working_dir


build_dependencies() {
  if [ -e ~/.pyenv ]; then
    read -p "install python $PY3_VERSION with '--enable-shared' flag? (y/N) > " yn
    case $yn in
      [Yy]* )
        CONFIGURE_OPTS="--enable-shared" pyenv install $PY3_VERSION
        break
        ;;
      *)
        echo "skipping python install ..."
        ;;
    esac
    cd $working_dir
    pyenv local $PY3_VERSION
  fi

  # ncurses
  cd $working_dir
  if ! [ -e ${target_dir}/lib/libncurses.a ]; then
    wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-${ncurses_version}.tar.gz
    tar xzf ncurses-${ncurses_version}.tar.gz
    cd ncurses-${ncurses_version}
    ./configure --prefix=${target_dir}
    make && make install
  fi

  # readline
  cd $working_dir
  if ! [ -e ${target_dir}/lib/libreadline.a ]; then
    wget https://ftp.gnu.org/gnu/readline/readline-${readline_version}.tar.gz
    tar xzf readline-${readline_version}.tar.gz
    cd readline-${readline_version}
    ./configure --prefix=${target_dir}
    make && make install
  fi

  # lua
  cd $working_dir
  if ! [ -e ${target_dir}/lib/liblua.a ]; then
    curl -O http://www.lua.org/ftp/lua-${lua_version}.tar.gz
    tar xzf lua-${lua_version}.tar.gz
    cd lua-${lua_version}
    make linux MYCFLAGS="-I${target_dir}/include" MYLDFLAGS="-L${target_dir}/lib"  MYLIBS="-lncurses"
    make install INSTALL_TOP=${target_dir}
  fi
}

install_dependencies_with_sudo() {
  if [ -f /etc/lsb-release ]; then
    # Debian/Ubuntu
    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
      libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
      xz-utils tk-dev libffi-dev liblzma-dev
  elif [ -f /etc/redhat-release ]; then
    # CentOS
    sudo yum install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel \
      openssl-devel xz xz-devel libffi-devel
    sudo ln -sf $(which python3.6) /usr/bin/python3
    curl https://bootstrap.pypa.io/get-pip.py | sudo python3.6
  else
    echo "unsupported OS ."
    exit 1
  fi
}

read -p "use sudo? (Y/n) > " yn
case $yn in
  [Nn]*)
    is_using_sudo=false
    build_dependencies
    break
    ;;
  *)
    echo "usnig sudo"
    is_using_sudo=true
    install_dependencies_with_sudo
    ;;
esac

if [ -x "$(command -v pip3)" ]; then
  pip3 install neovim --user
fi

# vim
cd $working_dir
if [ : ]; then
  curl -O http://ftp.vim.org/pub/vim/unix/vim-${vim_version}.tar.bz2
  bunzip2 -c vim-${vim_version}.tar.bz2 | tar -xf -
  cd vim$(echo $vim_version | tr -d .)
  make distclean
  ldflags=''
  if [ "$is_using_sudo" != true ]; then
    ldflags="-L${target_dir}/lib -Wl,-rpath,${HOME}/.pyenv/versions/${PY3_VERSION}/lib"
  fi
  ./configure \
    --prefix=${target_dir} \
    --with-tlib="ncurses" \
    --with-features=huge \
    --enable-multibyte \
    --enable-cscope \
    --without-x \
    --disable-gui \
    --enable-luainterp \
    --with-lua-prefix=${target_dir} \
    --enable-python3interp=dynamic \
    --enable-rubyinterp \
    LDFLAGS="$ldflags"
  make
  make install
fi
