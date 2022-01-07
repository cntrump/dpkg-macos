#!/usr/bin/env zsh

set -e

install_prefix=${INSTALL_PREFIX}
if [ "${install_prefix}" = "" ]; then
  install_prefix=/usr/local
fi

export PATH=$install_prefix/bin:$PATH

clone() {
  git clone --depth=1 $@
}

clone https://github.com/cntrump/autotools.git autotools

pushd autotools
./build_and_install.sh
popd

clone -b 1.21.1 https://git.dpkg.org/git/dpkg/dpkg.git dpkg

export SDKROOT=`xcrun --show-sdk-path --sdk macosx`
export LIBTOOLIZE=glibtoolize

CC=clang
CXX=clang++
CFLAGS="-target apple-macosx10.9 -arch x86_64 -arch arm64"
LIBRARYPERL=`perl -MConfig -E 'print "$Config::Config{'sitelib'}";'`

pushd dpkg
./autogen
./configure --prefix=${install_prefix} \
            --disable-dselect \
            --disable-start-stop-daemon \
            PERL_LIBDIR=${LIBRARYPERL} \
            CC=${CC} CXX=${CXX} CFLAGS=${CFLAGS}
make -j
sudo make install
popd
