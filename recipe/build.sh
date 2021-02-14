#!/usr/bin/env bash

if [[ ! $BOOTSTRAPPING == yes ]]; then
  # Get an updated config.sub and config.guess
  cp $BUILD_PREFIX/share/libtool/build-aux/config.* support/

  export CFLAGS="${CFLAGS} -I${PREFIX}/include"
  export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"
else
  export CFLAGS="${CFLAGS} -I${PREFIX}/include -I/usr/include"
  export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -L/usr/lib64"
fi

./configure --prefix=${PREFIX}  \
            --build=${BUILD}    \
            --host=${HOST}      \
            --disable-static    \
            || { cat config.log; exit 1; }
make SHLIB_LIBS="$(pkg-config --libs ncurses)" -j${CPU_COUNT} ${VERBOSE_AT}
make install
