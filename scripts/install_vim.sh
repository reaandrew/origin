#! /bin/bash

apt-get remove -y \
		vim \
		vim-runtime \
		gvim \
		vim-tiny \
		vim-common \
		vim-gui-common

apt-get update -y && apt-get install -y \
		libncurses5-dev \
		libgnome2-dev \
		libgnomeui-dev \
		libgtk2.0-dev \
		libatk1.0-dev \
		libbonoboui2-dev \
		libcairo2-dev \
		libx11-dev \
		libxpm-dev \
		libxt-dev \
		python-dev ruby-dev \
		python3-dev \
		git

cd ~
git clone https://github.com/vim/vim

cd vim
./configure --with-features=huge \
  --enable-multibyte \
  --enable-rubyinterp \
  --enable-pythoninterp \
  --with-python-config-dir=/usr/lib/python2.7/config \
  --enable-python3interp \
  --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
  --enable-perlinterp \
  --enable-luainterp \
  --enable-gui=gtk2 \
  --enable-cscope \
  --prefix=/usr

make VIMRUNTIMEDIR=/usr/share/vim/vim74
make install
