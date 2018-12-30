#!/bin/bash

currdir=$(pwd)
tempdir=$(mktemp -d)

cd $tempdir

latest=$(curl -sSG "https://api.github.com/repos/hashicorp/vagrant/tags" | grep "name" | cut -d\" -f4 | sort -n | tail -n 1 | sed 's/[^0-9\.]//g')

if [[ $? -ne 0 ]]; then
    echo "Unable to determine latest Vagrant release."
    exit 1
fi

wget https://releases.hashicorp.com/vagrant/${latest}/vagrant_${latest}_x86_64.deb -O vagrant.deb

if [[ $? -eq 0 ]]; then
    dpkg -x vagrant.deb .

    directories=("usr" "opt")
    for dir in ${directories[@]}; do
        test -d $currdir/vagrant/$dir && rm -rf $currdir/vagrant/$dir
        mv $dir/ $currdir/vagrant/
    done
fi

rm -r $tempdir
