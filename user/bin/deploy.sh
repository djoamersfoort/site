#!/usr/bin/env bash

if [ $(whoami) = 'root' ]; then
    echo "Don't run this as root, run it as www-data or something"
    echo "Try 'sudo -Hu www-data bin/deploy.sh'"
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GRAV_ROOT=$(dirname `dirname $DIR`)

set -xe

cd "${GRAV_ROOT}"

# Install dependancies
echo Installing / updating Grav
bin/gpm self-upgrade --all-yes

# Install packages
echo Installing admin package
bin/gpm install --all-yes email form login admin
bin/gpm install --all-yes sitemap

# Install theme
if [ ! -d "$GRAV_ROOT/user/themes/djo-amersfoort" ]; then
    echo Downloading DJO Amersfoort theme...
    git clone https://github.com/djoamersfoort/grav-theme.git "$GRAV_ROOT/user/themes/djo-amersfoort"
else
    echo Theme already created
fi

# Create root user
bin/plugin login add-user \
    --email=root-user@example.com \
    --permissions=b \
    --fullname="Root user" \
    --title="Default admin user" \
    --state=enabled

# Echo that we're done
echo 'Should be done now!'
exit 0

