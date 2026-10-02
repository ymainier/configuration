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
FILES=(.zshrc .gitconfig .gitignore_global .tmux.conf .vimrc .zimrc)
for file in ${FILES[@]}; do
  link_if_not_exists $CONFIGURATION_DIR/$file ~/$file
done
mkdir -p ~/.config
link_if_not_exists $CONFIGURATION_DIR/starship.toml ~/.config/starship.toml
touch ~/.zshrc.local

# Machine-specific git config: identity is never inherited from the repo.
# ~/.gitconfig sets user.useConfigOnly, so git refuses to commit until this is filled in.
if [ ! -f ~/.gitconfig.local ]; then
  cat > ~/.gitconfig.local <<'EOF'
# Machine-specific git config. Not tracked: each machine has its own.
# Set the email for THIS machine. Override user.signingKey too if this
# machine's signing key is not ~/.ssh/id_rsa.pub.
[user]
	email =
EOF
  echo >&2 "  created ~/.gitconfig.local - set user.email before committing"
fi

# Referenced by gpg.ssh.allowedSignersFile in ~/.gitconfig; git errors on
# every signature check if it is missing. Contents are per-machine.
mkdir -p ~/.ssh && touch ~/.ssh/allowed_signers

echo "Installing stuff..."

if type brew &>/dev/null; then
  echo "  brew already installed"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi


BREW_PACKAGES="git gh zsh fnm tmux starship bat fd fzf uv"
for package in $BREW_PACKAGES; do
  brew_install $package
done

BREW_CASK_PACKAGES="rectangle"
for package in $BREW_CASK_PACKAGES; do
  brew_cask_install $package
done

echo "done"
