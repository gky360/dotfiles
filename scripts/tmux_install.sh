#!/bin/bash

set -e

libevent_version=2.1.8
tmux_version=2.5
working_dir=$HOME/tmp
target_dir=$HOME/.local

mkdir -p $working_dir

# libevent
cd $working_dir
if ! [ -e ${target_dir}/lib/libevent.so ]; then
  wget -c https://github.com/libevent/libevent/releases/download/release-${libevent_version}-stable/libevent-${libevent_version}-stable.tar.gz\
    -O libevent-${libevent_version}-stable.tar.gz
  tar xvf libevent-${libevent_version}-stable.tar.gz
  cd libevent-${libevent_version}-stable
  ./configure --prefix=$target_dir
  make # use make -j 8 to speed it up if your machine is capable
  make install
fi

# tmux
cd $working_dir
wget -c https://github.com/tmux/tmux/releases/download/${tmux_version}/tmux-${tmux_version}.tar.gz\
  -O tmux-${tmux_version}.tar.gz
tar xvf tmux-${tmux_version}.tar.gz
cd tmux-${tmux_version}
./configure --prefix=$target_dir CFLAGS="-I${target_dir}/include" LDFLAGS="-L${target_dir}/lib"
make
make install

# tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
