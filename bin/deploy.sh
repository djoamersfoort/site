#!/usr/bin/env bash

if [ $(whoami) = 'root' ]; then
    echo "Don't run this as root, run it as www-data or something"
    echo "Try 'sudo -Hu www-data bin/deploy.sh'"
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GRAV_ROOT=$(dirname ${DIR})

cd GRAV_ROOT

# Install dependancies
bin/gpm self-upgrade

# Install packages
bin/gpm install --all-yes admin

# Install theme
git clone https://github.com/djoamersfoort/grav-theme.git $GRAV_ROOT/user/themes/djo-amersfoort

# Create root user
bin/plugin login adduser --user=root --email=admin@localhost --permissions=b --title="Root admin" --state=enabled

# Echo that we're done
echo 'Should be done now!'
exit 0

