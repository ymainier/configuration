#!/bin/sh

CONFIGURATION_DIR=~/src/configuration

function link_if_not_exists () {
	if [ -f $2 ];then
		echo >&2 "$2 already exists"
	else
		ln -shf $1 $2
	fi
}

function brew_install () {
  if brew list $1 &>/dev/null; then
    echo "$1 already installed"
  else
    brew install $1
  fi
}

function brew_cask_install () {
  if brew list --cask $1 &>/dev/null; then
    echo "$1 already installed"
  else
    brew cask install $1
  fi
}

echo "Copying config files..."
FILES=(.zshrc .p10k.zsh .gitconfig .tmux.conf .vimrc)
for file in ${FILES[@]}; do
  link_if_not_exists $CONFIGURATION_DIR/$file ~/$file
done

echo "Installing stuff..."

if type brew &>/dev/null; then
  echo "brew already installed"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi


brew_install git
brew_install zsh
brew_install nvm
brew install tmux

if brew list powerlevel10k &>/dev/null; then
  echo "powerlevel10k already installed"
else
  brew install romkatv/powerlevel10k/powerlevel10k
fi

brew_cask_install spectacle
brew_cask_install google-chrome
brew_cask_install visual-studio-code
echo "... 4. done"
