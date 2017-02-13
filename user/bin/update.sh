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
echo Updating Grav
bin/gpm self-upgrade -yf

# Install packages
echo Updating plugins
bin/gpm update -yfp

echo Updating themes
bin/gpm update -yft

# Install theme
if [ ! -d "$GRAV_ROOT/user/themes/djo-amersfoort" ]; then
    echo Downloading DJO Amersfoort theme...
    git clone https://github.com/djoamersfoort/grav-theme.git "$GRAV_ROOT/user/themes/djo-amersfoort"
else
    echo Updating DJO Amersfoort theme...
    cd "$GRAV_ROOT/user/themes/djo-amersfoort"
    if [ "$?" = "0" ]; then
        git checkout .
        git reset --hard
        git clean -dfx
        git pull
    else
        echo Something went wrong, do it yourself.
    fi
fi

# Echo that we're done
echo 'Should be done now!'
exit 0

