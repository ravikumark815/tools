#!/bin/bash

set -euo pipefail

# Variables
DOTFILES_REPO="https://github.com/ravikumark815/dot-files.git"
DOTFILES_DIR="$HOME/.dot-files"
SSH_EMAIL="${1:-user@example.com}"

echo ">>>> Updating and upgrading system"
sudo apt-get update -y && sudo apt-get upgrade -y

echo ">>>> Removing unused packages and cleaning up"
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get clean -y

echo ">>>> Installing essentials: net-tools, openssh-server, gcc, g++, python3-pip, git, curl"
sudo apt-get install -y net-tools openssh-server gcc g++ python3-pip git curl

echo ">>>> Upgrading pip and installing useful Python packages"
python3 -m pip install --user --upgrade pip
python3 -m pip install --user regex packaging

echo ">>>> Generating SSH key if not present"
SSH_KEY="$HOME/.ssh/id_rsa"
if [ ! -f "$SSH_KEY" ]; then
    ssh-keygen -t rsa -b 4096 -C "$SSH_EMAIL" -f "$SSH_KEY" -N ""
    echo "SSH public key (add this to GitHub or remote servers):"
    cat "$SSH_KEY.pub"
else
    echo "SSH key already exists at $SSH_KEY"
    cat "$SSH_KEY.pub"
fi

echo ">>>> Cloning/updating dot-files from $DOTFILES_REPO"
if [ -d "$DOTFILES_DIR" ]; then
    cd "$DOTFILES_DIR"
    git pull
else
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

echo ">>>> Symlinking dotfiles (with backup)"
cd "$DOTFILES_DIR"
for file in .bashrc .vimrc .gitconfig .tmux.conf; do
    SRC="$DOTFILES_DIR/$file"
    DEST="$HOME/$file"
    if [ -f "$SRC" ]; then
        if [ -e "$DEST" ] && [ ! -L "$DEST" ]; then
            BACKUP="${DEST}.bak.$(date +%Y%m%d%H%M%S)"
            echo "Backing up existing $DEST to $BACKUP"
            mv "$DEST" "$BACKUP"
        fi
        ln -sf "$SRC" "$DEST"
        echo "Linked $file"
    fi
done

echo ""
echo ">>>> Setup complete!"
echo "Next steps:"
echo "  - Ensure openssh-server is enabled: sudo systemctl enable --now ssh"
echo "  - Add your SSH public key to GitHub or other services."
echo "  - You may want to restart your terminal or source your new dotfiles."