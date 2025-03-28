#!/bin/sh

CONFIGURATION_DIR=~/src/configuration

function link_if_not_exists () {
	if [ -f $2 ];then
		echo >&2 "  $2 already exists"
	else
		ln -shf $1 $2
	fi
}

function brew_install () {
  if brew list $1 &>/dev/null; then
    echo "  $1 already installed"
  else
    brew install $1
  fi
}

function brew_cask_install () {
  if brew list --cask $1 &>/dev/null; then
    echo "  $1 already installed"
  else
    brew install --cask $1
  fi
}

echo "Copying config files..."
FILES=(.zshrc .gitconfig .tmux.conf .vimrc .zimrc)
for file in ${FILES[@]}; do
  link_if_not_exists $CONFIGURATION_DIR/$file ~/$file
done
mkdir -p ~/.config
link_if_not_exists $CONFIGURATION_DIR/starship.toml ~/.config/starship.toml
touch ~/.zsh.local

echo "Installing stuff..."

if type brew &>/dev/null; then
  echo "  brew already installed"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi


BREW_PACKAGES="git zsh nvm tmux starship bat fd fzf"
for package in $BREW_PACKAGES; do
  brew_install $package
done

BREW_CASK_PACKAGES="rectangle google-chrome visual-studio-code firefox"
for package in $BREW_CASK_PACKAGES; do
  brew_cask_install $package
done

echo "done"
