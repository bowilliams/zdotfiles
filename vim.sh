#!/bin/zsh

# vim.sh - install everything vim

# install janus
if [[ ! -d $HOME/.janus ]] then
  curl -Lo- https://bit.ly/janus-bootstrap | bash
  mkdir $HOME/.janus
fi

# install janis plugins
cd $HOME/.janus
if [[ ! -d vim-powerline ]] then
  git clone https://github.com/Lokaltog/vim-powerline
fi
if [[ ! -d webapi-vim ]] then
 git clone git@github.com:mattn/webapi-vim.git
fi
if [[ ! -d gist-vim ]] then 
  git clone git@github.com:mattn/gist-vim.git
fi
if [[ ! -d vim-colors-serialized ]] then
    git clone git@github.com:altercation/vim-colors-solarized.git
fi
# setup gist
git config --global github.user bowilliams@gmail.com

# link config
ln -s $HOME/zdotfiles/.vimrc.before $HOME/.janus/.virmrc.before
ln -s $HOME/zdotfiles/.vimrc.after $HOME/.janus/.vimrc.after
