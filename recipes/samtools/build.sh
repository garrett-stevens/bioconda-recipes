#!/bin/bash

# varfilter.py in install fails because we don't install Python
sed -i.bak 's#misc/varfilter.py##g' Makefile

# Remove rdynamic which can cause build issues on OSX
# https://sourceforge.net/p/samtools/mailman/message/34699333/
sed -i.bak 's/ -rdynamic//g' Makefile
sed -i.bak 's/ -rdynamic//g' htslib-$PKG_VERSION/configure

export CPPFLAGS="-DHAVE_LIBDEFLATE -I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
export LIBS="-lcrypto -lcurl"

# https://github.com/samtools/samtools/issues/577
if [[ "$(uname)" == "Linux" ]] ; then
    export LDFLAGS="$LDFLAGS -Wl,--add-needed"
fi

./configure --prefix=$PREFIX --enable-libcurl
make
make install
