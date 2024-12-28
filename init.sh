#!/bin/bash

# Atualiza os pacotes e instala dependências
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Cria o diretório para as chaves GPG
sudo install -m 0755 -d /etc/apt/keyrings

# Adiciona a chave GPG oficial do Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Adiciona o repositório do Docker ao Apt
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Instala os pacotes do Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verifica se o grupo "docker" já existe, caso contrário, cria
if getent group docker > /dev/null 2>&1; then
  echo "O grupo 'docker' já existe. Pulando a criação..."
else
  echo "Criando o grupo 'docker'..."
  sudo groupadd docker
fi

# Adiciona o usuário ao grupo "docker"
sudo usermod -aG docker $USER

# Exibe um aviso sobre o grupo para evitar interrupções
echo "Para ativar as mudanças de grupo, execute manualmente o comando: newgrp docker"

# Verifica se o Docker Engine está instalado corretamente
docker run hello-world || echo "Execute o comando acima novamente após ativar o grupo 'docker'."

# Ativa os serviços do Docker no boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Instalação do Java
sudo apt update
sudo apt install -y default-jre default-jdk

# Atualiza repositórios e pacotes
sudo apt-get update && sudo apt-get upgrade -y

# Instala o Git
sudo apt-get install -y git

# Configuração do Git
git config --global user.name "Emerson Patryck"
git config --global user.email "emeps@outlook.com"

# Instalação do Node.js usando nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Carrega o nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Instala a versão LTS do Node.js
nvm install --lts

# Atualiza novamente os pacotes
sudo apt-get update && sudo apt-get upgrade -y

# Instala Apache2 e PHP
sudo apt-get install -y apache2 php libapache2-mod-php php-xml php-curl php-opcache php-gd php-sqlite3 php-mbstring php-pgsql php-mysql

# Instala o Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

echo "Instalações realizadas com sucesso"