#!/usr/bin/env bash

# install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1

git clone --bare git@github.com:kirill-komarovich/dotfiles.git $HOME/.dotfiles

# define config alias locally since the dotfiles
# aren't installed on the system yet
function config {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# create a directory to backup existing dotfiles to
mkdir -p .dotfiles-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles";
  else
    echo "Moving existing dotfiles to ~/.dotfiles-backup";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi

# checkout dotfiles from repo
config checkout
config config status.showUntrackedFiles no
