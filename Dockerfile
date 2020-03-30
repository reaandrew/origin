FROM ubuntu

ADD scripts /root/scripts
ADD files /root/files

RUN ln -sf /root/scripts /scripts
RUN ln -sf /root/files/.zshrc /root/.zshrc

RUN mkdir -p /root/.ssh

WORKDIR /root

# Install Vim
RUN apt-get remove -y vim vim-runtime gvim vim-tiny vim-common vim-gui-common || :
RUN apt-get update -y && apt-get install -y \
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
RUN git clone https://github.com/vim/vim

WORKDIR /root/vim

RUN ./configure --with-features=huge \
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
RUN cd /root/vim && make VIMRUNTIMEDIR=/usr/share/vim/vim74
RUN cd /root/vim && make install

WORKDIR /root/

# Install ZSH
RUN apt install -y zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN mv /root/.zshrc.pre-oh-my-zsh /root/.zshrc
RUN chsh -s $(which zsh)


# Install Python Tools
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade -r /root/files/requirements.txt

CMD ["/bin/zsh"]
