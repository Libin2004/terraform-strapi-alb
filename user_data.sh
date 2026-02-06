#!/bin/bash
exec 2> /home/ubuntu/errors.txt

TARGET_USER="ubuntu"
APP_DIR="/home/$TARGET_USER/strapi-app"

# 1. Install dependencies
apt update
apt install -y curl build-essential

# 2. Install NVM
sudo -u $TARGET_USER bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.6/install.sh | bash'

# 3. Load NVM and install Node 20
sudo -u $TARGET_USER bash -c '
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 20
nvm alias default 20
npm install -g pm2@latest
'

# 4. Create Strapi Project
sudo -u $TARGET_USER bash -c '
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
mkdir -p "$HOME/strapi-app"
cd "$HOME"
echo "n" | STRAPI_TELEMETRY_DISABLED=true npx --yes create-strapi-app@latest "strapi-app" --quickstart --no-run --skip-cloud
'

# 5. Build and start
sudo -u $TARGET_USER bash -c '
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
cd "$HOME/strapi-app"
npm install
NODE_ENV=production npm run build
pm2 start npm --name "strapi-api" -- run start
pm2 save
pm2 startup systemd -u ubuntu --hp /home/ubuntu | bash
'

chown $TARGET_USER:$TARGET_USER /home/$TARGET_USER/errors.txt