#!/bin/zsh

# inits brew and git, and installs everything zsh

function to_install() {
  local desired installed
  local -A remain
  desired=$1
  installed=$2
  remain=$(comm -13 <(printf "%s\n" $=installed | sort) <(printf "%s\n" $=desired | sort))
  echo "${=remain}"
}

# Some tools look for XCode, even though they don't need it.
# https://github.com/joyent/node/issues/3681
# https://github.com/mxcl/homebrew/issues/10245

# I thnk brew has fixed this, so commenting out for now.

# if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]] then
#   sudo xcode-select -switch /usr/bin
# fi

# Install Homebrew.
if ! (( $+commands[brew] )) ; then
  echo "Installing Homebrew"
  true | /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

if (( $+commands[brew] )) ; then
  echo "Updating Homebrew"
  brew update

  # Install Homebrew recipes.
  recipes="git irssi markdown mercurial mysql ncftp redis tree lesspipe git-extras htop-osx man2html macvim svn tmux reattach-to-user-namespace"

  list="$(to_install "$recipes" "$(brew list | awk '{printf "%s ",$0} END {print ""}')")"
  if [[ -n "$list" ]] then
    echo "Installing Homebrew recipes: $list"
    brew install $list
  fi

fi

# now that we have git, we can clone dotfiles
if [[ ! -d $HOME/zdotfiles ]] then
  git clone git@github.com:bowilliams/zdotfiles.git
fi

# install oh-my-zsh if it's not there already
if [[ ! -e $HOME/.oh-my-zsh/ ]] then
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

# link zshrc
if [[ ! -e $HOME/.zshrc ]] then
  ln -s $HOME/zdotfiles/.zshrc $HOME/.zshrc
fi
