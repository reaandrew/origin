apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mv /root/.zshrc.pre-oh-my-zsh /root/.zshrc
chsh -s $(which zsh)
