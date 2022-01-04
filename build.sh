#!/usr/bin/env zsh

set -e

PREFIX=${INSTALL_PREFIX}
if [ "${PREFIX}" = "" ]; then
  PREFIX=/usr/local
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

pushd dpkg
./configure --prefix=${PREFIX} \
            --disable-dselect \
            --disable-start-stop-daemon \
            PERL_LIBDIR=${LIBRARYPERL} \
            CC=clang CXX=clang++
make -j
sudo make install
popd

