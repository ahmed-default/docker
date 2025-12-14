#!/bin/bash

set -e 

echo "🔄 Updating system packages..."
sudo apt update -y

#=============================================================================================#

echo "📦 Installing required packages (ca-certificates, curl)..."
sudo apt install -y ca-certificates curl

#=============================================================================================#

echo "📁 Creating keyrings directory..."
sudo install -m 0755 -d /etc/apt/keyrings

#=============================================================================================#

echo "🔑 Downloading Docker GPG key..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

#=============================================================================================#

echo "🔐 Setting permissions for Docker GPG key..."
sudo chmod a+r /etc/apt/keyrings/docker.asc

#=============================================================================================#

echo "📝 Adding Docker repository..."

UBUNTU_CODENAME=$( . /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}" )

sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $UBUNTU_CODENAME
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

#=============================================================================================#

echo "🔄 Updating package lists again..."
sudo apt update -y
echo "✅ Docker repository added successfully!"

#=============================================================================================#

echo "🐳 Installing Docker Engine + CLI + containerd + Buildx + Compose..."

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

#=============================================================================================#

echo "🔍 Verifying Docker installation..."

if sudo docker --version; then
    echo "✅ Docker installed successfully!"
else
    echo "❌ Docker failed!"
    exit 1
fi

#=============================================================================================#