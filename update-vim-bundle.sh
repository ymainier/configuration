#!/bin/sh

VIM_BUNDLE_DIR=~/.vim/bundle
cd $VIM_BUNDLE_DIR
for bundle in *; do
	cd $VIM_BUNDLE_DIR/$bundle
	git pull
done
