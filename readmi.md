./s1.sh

after download nginx cd in dir and copy this in nginx dir
./configure --with-cc-opt='-Wno-stringop-overflow -Wno-stringop-truncation -Wno-cast-function-type' --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-pcre --pid-path=/var/run/nginx.pid --with-compat --with-openssl=openssl-1.1.1d --with-http_ssl_module 

make && make install 

./s3(2).sh 

./s2.sh

in nginx dir
./configure --with-cc-opt='-Wno-stringop-overflow -Wno-stringop-truncation -Wno-cast-function-type' \
--with-ld-opt="-Wl,-rpath,/usr/local/lib" \
--with-compat --with-openssl=openssl-1.1.1d \
--with-http_ssl_module \
--add-dynamic-module=headers-more-nginx-module \
--add-dynamic-module=echo-nginx-module \
--add-dynamic-module=naxsi/naxsi_src \
--add-dynamic-module=socks-nginx-module \
--add-dynamic-module=ngx_devel_kit \
--add-dynamic-module=lua-nginx-module 

make && make install 

mv resty/aes_functions.lua /usr/local/lib/lua/resty/aes_functions.lua 

mkdir /etc/nginx/resty/

ln -s /usr/local/lib/lua/resty/ /etc/nginx/resty/

test you nginx

./setup.sh

see /etc/nginx/naxsi.log 
