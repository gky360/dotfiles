#!/bin/bash

set -e

lua_version=5.3.4
vim_version=8.0
working_dir=$HOME/tmp
target_dir=$HOME/.local

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${target_dir}/lib

mkdir -p $working_dir

# lua
cd $working_dir
if ! [ -e ${target_dir}/lib/liblua.a ]; then
  curl -O http://www.lua.org/ftp/lua-${lua_version}.tar.gz
  tar xvzf lua-${lua_version}.tar.gz
  cd lua-${lua_version}
  make linux
  make install INSTALL_TOP=${target_dir}
fi

# vim
cd $working_dir
if [ : ]; then
  curl -O http://ftp.vim.org/pub/vim/unix/vim-${vim_version}.tar.bz2
  tar jxvf vim-${vim_version}.tar.bz2
  cd vim${vim_version//.}
  ./configure \
    --prefix=${target_dir} \
    --with-features=huge \
    --enable-multibyte \
    --enable-luainterp \
    --with-lua-prefix=${target_dir} \
    --enable-pythoninterp \
    --enable-rubyinterp
  make
  make install
fi
