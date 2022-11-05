#/bin/bash

cd luajit2-2.1-20200102
make -j8 && make install
cd ..

cd lua-resty-string
make install
cd ..

cd lua-resty-cookie
make install
cd ..

cd lua-gd
gcc -o gd.so -DGD_XPM -DGD_JPEG -DGD_FONTCONFIG -DGD_FREETYPE -DGD_PNG -DGD_GIF -O2 -Wall -fPIC -fomit-frame-pointer -I/usr/local/include/luajit-2.1 -DVERSION=\"2.0.33r3\" -shared -lgd luagd.c
mv gd.so /usr/local/lib/lua/5.1/gd.so
cd ..

cp -a lua-resty-session/lib/resty/session* /usr/local/lib/lua/resty/

export LUAJIT_LIB=/usr/local/lib
export LUAJIT_INC=/usr/local/include/luajit-2.1
