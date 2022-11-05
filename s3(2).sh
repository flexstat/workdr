
#/bin/bash

git clone https://github.com/yorkane/socks-nginx-module.git
git clone https://github.com/nbs-system/naxsi.git
git clone https://github.com/openresty/headers-more-nginx-module.git
git clone https://github.com/openresty/echo-nginx-module.git

#some required stuff for lua/luajit. obviously versions should be ckecked with every install/update
git clone https://github.com/openresty/lua-nginx-module
cd lua-nginx-module
git checkout v0.10.16
cd ..
git clone https://github.com/openresty/luajit2
cd luajit2
git checkout v2.1-20200102
cd ..

git clone https://github.com/vision5/ngx_devel_kit

git clone https://github.com/openresty/lua-resty-string

git clone https://github.com/cloudflare/lua-resty-cookie

git clone https://github.com/ittner/lua-gd/

git clone https://github.com/bungle/lua-resty-session
