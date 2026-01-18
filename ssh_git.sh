#!/bin/bash

echo "=============================="
echo " GitHub SSH Setup Script"
echo "=============================="

# Ask for key name
read -p "Enter unique SSH key name (example: github_work): " KEY_NAME

SSH_DIR="$HOME/.ssh"
PRIVATE_KEY="$SSH_DIR/$KEY_NAME"
PUBLIC_KEY="$SSH_DIR/$KEY_NAME.pub"

# Create .ssh directory if not exists
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Generate SSH key
if [ -f "$PRIVATE_KEY" ]; then
    echo "❌ SSH key already exists: $PRIVATE_KEY"
    exit 1
fi

echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "$KEY_NAME" -f "$PRIVATE_KEY"

# Start ssh-agent
echo "Starting ssh-agent..."
eval "$(ssh-agent -s)"

# Add key to agent
echo "Adding key to ssh-agent..."
ssh-add "$PRIVATE_KEY"

# Show public key
echo
echo "=============================="
echo " COPY THIS SSH KEY"
echo "=============================="
cat "$PUBLIC_KEY"
echo
echo "=============================="
echo " Add this key to GitHub:"
echo " GitHub → Settings → SSH and GPG keys → New SSH key"
echo "=============================="

# Test GitHub connection
echo
read -p "Test GitHub SSH connection now? (y/n): " TEST
if [[ "$TEST" == "y" ]]; then
    ssh -T git@github.com
fi
