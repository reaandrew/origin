FROM ubuntu

ADD scripts /root/scripts
ADD files /root/files

RUN ln -sf /root/scripts /scripts
RUN ln -sf /root/files/.zshrc /root/.zshrc

RUN mkdir -p /root/.ssh

RUN /scripts/install_vim.sh
RUN /scripts/install_zsh.sh
RUN /scripts/install_python_tools.sh



CMD ["/bin/zsh"]
