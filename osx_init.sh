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

# make sure command line tools are installed first!
if ! [[ -e /usr/bin/clang ]] ; then
  echo "INSTALL COMMAND LINE TOOLS"
  echo "https://developer.apple.com/downloads/"
  exit
fi

# warn that full xcode needs to be installed for macvim
if ! [[ -d /Applications/XCode.app/ ]] ; then
  echo "XCode is not installed - macvim installation will fail. Proceed anyway?"
  read -s -n 1 any_key
  echo "Proceeding..."
fi

# Install Homebrew.
if ! [[ -e /usr/local/bin/brew ]] ; then
  echo "Installing Homebrew"
  true | /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

echo "time to call brew doctor, press any key when ready to continue..."
read -s -n 1 any_key
echo "Proceeding..."

if [[ -e /usr/local/bin/brew ]] ; then
  echo "Updating Homebrew"
  brew update

  # Install Homebrew recipes.
  recipes="git irssi markdown mercurial mysql ncftp redis tree lesspipe git-extras htop-osx man2html macvim svn tmux reattach-to-user-namespace"

  list="$(to_install "$recipes" "$(brew list | awk '{printf "%s ",$0} END {print ""}')")"
  if [[ -n "$list" ]] then
    for cmd in $=list
    do
      echo "Installing Homebrew recipe: $cmd"
      brew install $cmd
    done
  fi
fi

# change path so we got our nice new git install
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# now that we have git, we can clone dotfiles, but we need to
# get credentials set up first
# set up an ssh key
if ! [[ -e $HOME/.ssh/id_rsa.pub ]] ; then
  ssh-keygen
fi
pbcopy < $HOME/.ssh/id_rsa.pub
echo "Please set up an SSH key at https://github.com/settings/ssh"
echo "Your SSH key has been copied into the clipboard"
echo "Press any key to proceed once you are done..."
read -s -n 1 any_key
echo "Proceeding..."  

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

echo "manually install iterm2, solarized theme, and fonts in ~/zdotfiles/fonts"

