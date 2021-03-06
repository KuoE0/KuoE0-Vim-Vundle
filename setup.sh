# /usr/bin/env bash
# Author: 	KuoE0 <kuoe0.tw@gmail.com>
# Description: 	Auto install vimrc

remove_by_path() {
	TARGET="$1"
	if [ -f "$TARGET" ] || [ -h "$TARGET" ] || [ -d "$TARGET" ]; then
		rm -rf "$TARGET"
	fi
}

# OS test
OS=$(uname)
echo $OS

# setting readlink command
if [ "$OS" = 'Linux' ]; then
	REALPATH='readlink -f'
elif [ "$OS" = 'Darwin' ]; then
	REALPATH='realpath'
elif [ "$OS" = 'FreeBSD' ]; then
	REALPATH='realpath'
fi

# absolute path of this script, e.g. /home/usr/bin/foo.sh
SCRIPT=$($REALPATH "$0")
# absolute path of current directory
SCRIPTPATH=$(dirname "$SCRIPT")

echo "$SCRIPTPATH"

# setup for vim
VIM_FOLDER="$HOME/.vim"
VIM_CONFIG="$HOME/.vimrc"
remove_by_path "$VIM_FOLDER"
remove_by_path "$VIM_CONFIG"
ln -s "$SCRIPTPATH" "$VIM_FOLDER"
ln -s "$SCRIPTPATH/vimrc" "$VIM_CONFIG"

# setup for neovim
NEOVIM_FOLDER="$HOME/.config/nvim"
NEOVIM_CONFIG="$NEOVIM_FOLDER/init.vim"
if [ ! -f "$(dirname $NEOVIM_FOLDER)" ]; then
	mkdir "$(dirname $NEOVIM_FOLDER  )"
fi
remove_by_path "$NEOVIM_CONFIG"
remove_by_path "$NEOVIM_FOLDER"
ln -s "$SCRIPTPATH" "$NEOVIM_FOLDER"
ln -s "$SCRIPTPATH/vimrc" "$NEOVIM_CONFIG"

# create undo directory
if [ ! -d "$HOME/.vim/undo" ]; then
	mkdir "$HOME/.vim/undo"
fi

# requirement
brew install node cscope cmake ctags fzf python@2 python
pip3 install pynvim jedi autopep8 pyls
npm -g install eslint babel-eslint neovim

# racer support for YCM
if [ -d "$VIM_FOLDER/rust" ]; then
	rm -rf "$VIM_FOLDER/rust"
fi
git clone https://github.com/rust-lang/rust ~/.vim/rust

# download plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# development environment
if [ -e "$SCRIPTPATH/.git/hooks/pre-commit" ]; then
	rm "$SCRIPTPATH/.git/hooks/pre-commit"
fi
ln -s ../../dev/pre-commit "$SCRIPTPATH/.git/hooks/pre-commit"
