#!/bin/bash

#download path
DOWNLOAD_PATH=`down`

#install libunwind
cd  /$DOWNLOAD_PATH
wget http://download.savannah.gnu.org/releases/libunwind/libunwind-0.99.tar.gz
tar zxvf libunwind-0.99.tar.gz
cd libunwind-0.99/
CFLAGS=-fPIC ./configure --prefix=/usr/local/libunwind
make CFLAGS=-fPIC
make CFLAGS=-fPIC install
echo '/usr/local/libunwind/lib/' >> /etc/ld.so.conf
ldconfig

#install google-perftools
cd  /$DOWNLOAD_PATH
wget http://google-perftools.googlecode.com/files/google-perftools-1.7.tar.gz
tar -xzvf google-perftools-1.7.tar.gz
cd google-perftools-1.7
./configure --prefix=/usr/local/perftools --enable-frame-pointers
make && make install
echo '/usr/local/perftools/lib/' >> /etc/ld.so.conf
ldconfig
cp -r /usr/local/perftools/lib/* /usr/local/lib
mkdir /tmp/tcmalloc
chmod 0777 /tmp/tcmalloc

#install pcre
cd  /$DOWNLOAD_PATH
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.31.tar.gz
tar -zxvf pcre-8.31.tar.gz
cd pcre-8.31
./configure --prefix=/usr/local/pcre
make && make install

#install zlib
cd  /$DOWNLOAD_PATH
git clone git://github.com/madler/zlib.git
cd zlib
./configure --prefix=/usr/local/zlib
make && make install

#install ngx_cache_purge module
cd  /$DOWNLOAD_PATH
git clone git://github.com/FRiCKLE/ngx_cache_purge.git

#install ngx_http_consistent_hash module
cd  /$DOWNLOAD_PATH
git clone git://github.com/replay/ngx_http_consistent_hash.git

#install nginx-http-sysguard module
cd  /$DOWNLOAD_PATH
git clone git://github.com/alibaba/nginx-http-sysguard.git

#install ngx_devel_kit
cd  /$DOWNLOAD_PATH
git clone git://github.com/simpl/ngx_devel_kit.git

#install lua-nginx-module
cd  /$DOWNLOAD_PATH
git clone git://github.com/chaoslawful/lua-nginx-module.git

#install ngx_mongo
git clone git://github.com/simpl/ngx_mongo.git

#install nginx
cd  /$DOWNLOAD_PATH
tar -zxvf nginx-1.3.4.tar.gz
cd nginx-1.3.4
chmod 777 configure
patch -p1 < ../nginx-http-sysguard/nginx_sysguard_1.2.5.patch
./configure --prefix=/usr/local/nginx \
--with-pcre=/down/pcre-8.31 \
--with-zlib=/down/zlib \
--with-http_realip_module \
--with-http_stub_status_module \
--with-google_perftools_module \
--add-module=../ngx_http_consistent_hash \
--add-module=../ngx_cache_purge \
--add-module=../nginx-http-sysguard \
--add-module=../ngx_devel_kit \
--add-module=../lua-nginx-module \
--add-module=../ngx_mongo \
--with-debug
make && make install

