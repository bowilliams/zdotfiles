#!/bin/zsh

# I'm sort of a weirdo and try to not use the system python at all, or 
# install anything to it. I put everything in a default virtualenv.
#
if [[ ! -d $HOME/zdotfiles/python ]] then
  mkdir $HOME/zdotfiles/python
fi
cd $HOME/zdotfiles/python

# I don't use a system-wide virtualenv - keep it here, and then link vecreate
# to it
if ! [[ -e $HOME/zdotfiles/python/virtualenv.py ]] then
  # http://opensourcehacker.com/2012/09/16/recommended-way-for-sudo-free-installation-of-python-software-with-virtualenv/
  curl -L -o virtualenv.py https://raw.github.com/pypa/virtualenv/master/virtualenv.py
fi

if ! [[ -d $HOME/ve/ ]] then
  mkdir $HOME/ve
  python virtualenv.py $HOME/ve
  . $HOME/ve/bin/activate
  curl -O https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
  python ./ez_setup.py
  curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
  python ./get-pip.py
fi
