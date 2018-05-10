#!/bin/bash

currdir=$(pwd)
tempdir=$(mktemp -d)

cd $tempdir

latest=$(curl -sSG "https://api.github.com/repos/hashicorp/vagrant/tags" | grep "name" | cut -d\" -f4 | sort -n | tail -n 1 | sed 's/[^0-9\.]//g')

if [[ $? -ne 0 ]]; then
    echo "Unable to determine latest Vagrant release."
    exit 1
fi

wget https://releases.hashicorp.com/vagrant/${latest}/vagrant_${latest}_linux_amd64.zip -O vagrant.zip

if [[ $? -eq 0 ]]; then
    unzip vagrant.zip

    mv vagrant $currdir/vagrant/usr/bin/
fi

rm -r $tempdir
