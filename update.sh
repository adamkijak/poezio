#!/bin/bash
# Use this script to Download or Update all dependances to their last
# developpement version.
# The dependances will be placed in the sources directory, so you do not
# need to install them on your system at all.

# Use launch.sh to start poezio directly from here

echo 'Updating poezio'
git pull origin master

make
if [ $? -ne 0 ]
then
    echo -e "It seems that you do not have the python development"\
        "files.\nSearch for a package named python3-dev or python3-devel"\
        "in your repos."
    exit -1
fi

if [ -e "SleekXMPP" ]
then
    echo "Updating SleekXMPP"
    cd SleekXMPP
    git pull
    cd ..
else
    echo "Downloading SleekXMPP"
    git clone git://github.com/louiz/SleekXMPP.git
fi
if [ -e ".dnspython.tgz" ]
then
    if [ -e "dnspython" ]
    then
        echo "dnspython up to date"
    else
        echo "Restoring dnspython"
        tar xf .dnspython.tgz
        mv dnspython3-1.10.0 dnspython
    fi
else
    echo "Downloading dnspython"
    wget -c -q -O .dnspython.tgz http://www.dnspython.org/kits3/1.10.0/dnspython3-1.10.0.tar.gz
    rm -fr dnspython
    tar xf .dnspython.tgz
    mv dnspython3-1.10.0 dnspython
fi

cd src
if [ -h "dns" ]
then
    echo 'Link src/dns already exists'
else
    echo "Creating link src/dns"
    ln -s ../dnspython/dns dns
fi
if [ -h "sleekxmpp" ]
then
    echo 'Link src/sleekxmpp already exists'
else
    echo "Creating link src/sleekxmpp"
    ln -s ../SleekXMPP/sleekxmpp sleekxmpp
fi
