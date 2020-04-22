FROM ubuntu as builder

ARG USER_NAME="docker"
ARG USER_PASSWORD="docker"
ARG GO_VERSION="1.14.2"

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
RUN cd /root/vim && make VIMRUNTIMEDIR=/usr/share/vim/vim82
RUN cd /root/vim && make install

WORKDIR /root/

ENV TERM xterm
ENV ZSH_THEME agnoster

ENV USER_NAME $USER_NAME
ENV USER_PASSWORD $USER_PASSWORD
ENV CONTAINER_IMAGE_VER=v1.0.0

RUN echo $USER_NAME
RUN echo $USER_PASSWORD
RUN echo $CONTAINER_IMAGE_VER

# install the tooks i wish to use
RUN apt-get update && \
  apt-get install -y sudo \
  cmake \
  curl \
  git-core \
  gnupg \
  linuxbrew-wrapper \
  locales \
  nodejs \
  zsh \
  wget \
  npm \
  fonts-powerline \
  build-essential \
  python3-dev \
  # set up locale
  && locale-gen en_US.UTF-8 \
  # add a user (--disabled-password: the user won't be able to use the account until the password is set)
  && adduser --quiet --disabled-password --shell /bin/zsh --home /home/$USER_NAME --gecos "User" $USER_NAME \
  # update the password
  && echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd && usermod -aG sudo $USER_NAME


# Install GOLANG
RUN rm -rf /usr/local/go && \
  curl -LO "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" && \
  tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz" && \
  rm "go${GO_VERSION}.linux-amd64.tar.gz" && \
  ln -s /usr/local/go/bin/go /usr/bin/go
  

  
ADD ./files/.vimrc /home/$USER_NAME/
ADD ./files/.zshrc /home/$USER_NAME/

RUN chown -R $USER_NAME:$USER_NAME /home/$USER_NAME

FROM builder

# the user we're applying this too (otherwise it most likely install for root)
USER $USER_NAME

# terminal colors with xterm
ENV TERM xterm
# set the zsh theme
ENV ZSH_THEME agnoster

# run the installation script  
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Install VIM Plug
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install the plugins so vim is ready to roll!
RUN vim +PlugInstall +qall > /dev/null

RUN cd ~/.vim/plugged/YouCompleteMe && \
    git submodule update --init --recursive && \
    ./install.py --all

# start zsh
CMD [ "zsh" ]

