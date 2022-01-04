#!/usr/bin/env zsh

set -e

install_prefix=${INSTALL_PREFIX}
if [ "${install_prefix}" = "" ]; then
  install_prefix=/usr/local
fi

export PATH=$install_prefix/bin:$PATH

clone() {
  git clone --depth=1 $1 $2
}

clone https://github.com/cntrump/autotools.git autotools

pushd autotools
./build_and_install.sh
popd

clone https://git.dpkg.org/git/dpkg/dpkg.git dpkg

export LIBTOOLIZE=glibtoolize

pushd dpkg
./autogen
./configure --prefix=${install_prefix} \
            --disable-dselect \
            --disable-start-stop-daemon \
            PERL_LIBDIR=${LIBRARYPERL} \
            CC=clang CXX=clang++
make -j
sudo make install
popd

