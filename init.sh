#!/bin/zsh

# install oh-my-zsh if it's not there already
if [[ ! -e $HOME/.oh-my-zsh/ ]] then
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

# link zshrc
if [[ ! -e $HOME/.zshrc ]] then
  ln -s $HOME/zdotfiles/.zshrc $HOME/.zshrc
fi 

if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]] then
  sudo xcode-select -switch /usr/bin
fi

# Install Homebrew.
if test ! $(which brew)
then
  echo "Installing Homebrew"
  true | /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

if test $(which brew)
then
  echo "Updating Homebrew"
  brew update

  # Install Homebrew recipes.
  recipes="git tree sl lesspipe id3tool nmap git-extras htop-osx man2html macvim svn tmux reattach-to-user-namespace"

  list="$(to_install "$recipes" "$(brew list | awk '{printf "%s ",$0} END {print ""}')")"
  echo $list
  if [[ -n "$list" ]] then
    echo "Installing Homebrew recipes: $list"
    brew install $list
  fi

  if test ! $(which gcc-4.2)
  then
    echo "Installing Homebrew dupe recipe: apple-gcc42"
    brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  fi
fi
