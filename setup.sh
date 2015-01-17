#!/bin/sh

CONFIGURATION_DIR=~/configuration

function link_if_not_exists () {
	if [ -f $2 ];then
		echo >&2 "$2 already exists"
	else
		ln -s $1 $2
	fi
}

echo "Bash config ..."
link_if_not_exists $CONFIGURATION_DIR/bashrc ~/.bashrc
echo "... done"

echo "Git config..."
git config --global alias.l "log --graph --pretty=format:'%C(yellow)%h%C(cyan)%d%Creset %s %C(white)- %an, %ar%Creset'"
git config --global color.ui true
git config --global push.default simple
echo "... done"

echo "Vim config ..."
link_if_not_exists $CONFIGURATION_DIR/vimrc ~/.vimrc

mkdir -p ~/.vim/{autoload,bundle,_backup,_temp}

## Pathogen
curl -LSso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

## plugins
while read bundle; do
	cd ~/.vim/bundle
	echo "  installing ${bundle} plugin"
	git clone -q $bundle 2>&1
done < ~/configuration/vim/bundles.txt

## snippets
link_if_not_exists $CONFIGURATION_DIR/vim/snippets/ ~/.vim/snippets
echo "... done"
