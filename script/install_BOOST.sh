#!/bin/bash 

source script/discover_os
discover_os

# check if the directory $1/BOOST exist

if [ -d "$1/BOOST" ]; then
  echo "BOOST already installed"
  exit 0
fi

rm boost_1_75_0.tar.bz2
wget http://ppmcore.mpi-cbg.de/upload/boost_1_75_0.tar.bz2
tar -xvf boost_1_75_0.tar.bz2
cd boost_1_75_0
if [ x"$4" != x"" ]; then
	if [ -f $HOME/user-config.jam ]; then
		mv $HOME/user-config.jam $HOME/user-config.jam_bck
	fi
	if [ x"$5" != x"" ]; then
		echo "using gcc : $5.$6 : $4 ; " > $HOME/user-config.jam
	else
		echo "using gcc : : $4 ; " > $HOME/user-config.jam
	fi
fi
./bootstrap.sh --with-toolset=$3
mkdir $1/BOOST

# Several flavours
arch=$(uname -m)
if [ x"$platform" == x"osx" ]; then
    if [ x"$arch" == x"arm64" ]; then
        ./b2 -j $2 install --prefix=$1/BOOST address-model=64 architecture=arm abi=aapcs binary-format=mach-o
    else
        ./b2 -j $2 install --prefix=$1/BOOST
    fi
else
    ./b2 -j $2 install --prefix=$1/BOOST
fi
rm -rf boost_1_75_0

if [ -f $HOME/user-config.jam_bck ]; then
	mv $HOME/user-config.jam_bck $HOME/user-config.jam
fi
rm -rf boost_1_75_0.tar.bz2

