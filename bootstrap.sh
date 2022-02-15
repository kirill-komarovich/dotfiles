#!/usr/bin/env bash

current_dir=$(pwd)

add_ppa() {
  grep -h "^deb.*$1" /etc/apt/sources.list.d/* > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    echo "Adding ppa:$1"
    sudo add-apt-repository -y ppa:$1
    return 0
  fi

  echo "ppa:$1 already exists"
  return 1
}

sudo apt -y install git

# Configure git
ln -sf $current_dir/.gitignore_global ~/.gitignore_global
ln -sf $current_dir/.gitconfig ~/.gitconfig

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0

. $HOME/.asdf/asdf.sh

asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git

# Erlang requirements
sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev \
                        libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils \
                        libncurses-dev openjdk-11-jdk

asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git

# Install neovim
add_ppa neovim-ppa/stable
sudo apt-get -y install neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim_config_dir=~/.config/nvim
mkdir -p $nvim_config_dir
ln -sf $current_dir/init.vim $nvim_config_dir/init.vim
nvim +PluginInstall +qall
