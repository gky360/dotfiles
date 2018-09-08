#!/bin/bash

set -e

ncurses_version=6.1
readline_version=7.0
lua_version=5.3.5
vim_version=8.1
working_dir=$HOME/tmp
target_dir=$HOME/.local

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${target_dir}/lib

mkdir -p $working_dir
mkdir -p ${target_dir}/include

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
  # -L${HOME}/local/ncurses/lib" MYLIBS="-lncursesw"
  make install INSTALL_TOP=${target_dir}
fi

# vim
cd $working_dir
if [ : ]; then
  curl -O http://ftp.vim.org/pub/vim/unix/vim-${vim_version}.tar.bz2
  tar jxf vim-${vim_version}.tar.bz2
  cd vim${vim_version//.}
  ./configure \
    --prefix=${target_dir} \
    --with-tlib="ncurses" \
    --with-features=huge \
    --enable-multibyte \
    --enable-luainterp \
    --with-lua-prefix=${target_dir} \
    --enable-pythoninterp \
    --enable-rubyinterp \
    LDFLAGS="-L${target_dir}/lib"
  make
  make install
fi
