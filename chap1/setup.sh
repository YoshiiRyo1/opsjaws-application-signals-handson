#!/usr/bin/env bash

## Maven インストール

sudo dnf -y install java-17-amazon-corretto-devel maven

echo "Java Version"
java --version
echo ""

echo "Maven Version"
mvn --version
echo ""

## Docker Compose インストール

sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

echo "Docker Compose Version"
docker compose version
echo ""

## Sudo なしで Docker コマンドを実行

sudo gpasswd -a $(whoami) docker
sudo chgrp docker /var/run/docker.sock
sudo service docker restart

exit 0