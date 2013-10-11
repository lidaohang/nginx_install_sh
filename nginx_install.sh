#!/bin/bash

#path
mkdir -p /download
DOWNLOAD_PATH=download

#nginx Depend on class libraries
LIBUNWIND_PATH=/usr/local/libunwind
PERFTOOLS_PATH=/usr/local/perftools
PCRE_PATH=/$DOWNLOAD_PATH/pcre-8.31
ZLIB_PATH=/$DOWNLOAD_PATH/zlib
LUAJIT_PATH=/usr/local/bin/luajit

#nginx module
NGX_CACHE_PURGE=/$DOWNLOAD_PATH/ngx_cache_purge
NGX_HTTP_CONSISTENT_HASH=/$DOWNLOAD_PATH/ngx_http_consistent_hash
NGINX_HTTP_SYSGUARD=/$DOWNLOAD_PATH/nginx-http-sysguard
NGX_DEVEL_KIT=/$DOWNLOAD_PATH/ngx_devel_kit
LUA_NGINX_MODULE=/$DOWNLOAD_PATH/lua-nginx-module
NGX_MONGO=/$DOWNLOAD_PATH/ngx_mongo

#nginx
NGINX_PATH=/$DOWNLOAD_PATH/nginx-1.3.4


#install libunwind
if [ -d "$LIBUNWIND_PATH" ]; then
	echo "libunwind is OK!"
else 
	cd  /$DOWNLOAD_PATH
	wget http://download.savannah.gnu.org/releases/libunwind/libunwind-0.99.tar.gz
	tar zxvf libunwind-0.99.tar.gz
	cd libunwind-0.99/
	CFLAGS=-fPIC ./configure --prefix=/usr/local/libunwind
	make CFLAGS=-fPIC
	make CFLAGS=-fPIC install
	echo '/usr/local/libunwind/lib/' >> /etc/ld.so.conf
	ldconfig
fi


#install google-perftools
if [ -d "$PERFTOOLS_PATH" ]; then
	echo "perftools is OK!"
else
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
fi

#install pcre
if [ -d "$PCRE_PATH" ]; then
	echo "pcre is OK!"
else
	cd  /$DOWNLOAD_PATH
	wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.31.tar.gz
	tar -zxvf pcre-8.31.tar.gz
	cd pcre-8.31
	./configure --prefix=/usr/local/pcre
	make && make install
fi	

#install zlib
if [ -d "$ZLIB_PATH" ]; then
	echo "zlib is OK!"
else
	cd  /$DOWNLOAD_PATH
	git clone git://github.com/madler/zlib.git
	cd zlib
	./configure --prefix=/usr/local/zlib
	make && make install
fi

#install luajit
if [ -f "$LUAJIT_PATH" ]; then
	echo "luajit is OK!"
else
	wget http://luajit.org/download/LuaJIT-2.0.0.tar.gz
	tar -zxvf LuaJIT-2.0.0.tar.gz
	cd LuaJIT-2.0.0
	make && make install
	echo '/usr/local/lib' >> /etc/ld.so.conf
	ldconfig
fi	
	
#install ngx_cache_purge module
if [ -d "$NGX_CACHE_PURGE" ]; then
	echo "ngx_cache_purge is OK!"
else
	cd  /$DOWNLOAD_PATH
	git clone git://github.com/FRiCKLE/ngx_cache_purge.git
fi

#install ngx_http_consistent_hash module
if [ -d "$NGX_HTTP_CONSISTENT_HASH" ]; then
	echo "ngx_http_consistent_hash is OK!"
else
	cd  /$DOWNLOAD_PATH
	git clone git://github.com/replay/ngx_http_consistent_hash.git
fi
	
#install nginx-http-sysguard module
if [ -d "$NGINX_HTTP_SYSGUARD" ]; then
	echo "nginx-http-sysguard is OK!"
else
	cd  /$DOWNLOAD_PATH
	git clone git://github.com/alibaba/nginx-http-sysguard.git
fi	

#install ngx_devel_kit
if [ -d "$NGX_DEVEL_KIT" ]; then
	echo "ngx_devel_kit is OK!"
else
	cd  /$DOWNLOAD_PATH
	git clone git://github.com/simpl/ngx_devel_kit.git
fi
	
#install lua-nginx-module
if [ -d "$LUA_NGINX_MODULE" ]; then
	echo "lua-nginx-module is OK!"
else
	cd  /$DOWNLOAD_PATH
	git clone git://github.com/chaoslawful/lua-nginx-module.git
fi
	
#install ngx_mongo
if [ -d "$NGX_MONGO" ]; then
	echo "ngx_mongo download is OK!"
else
	cd  /$DOWNLOAD_PATH
	git clone git://github.com/simpl/ngx_mongo.git
fi
	
#install nginx
cd  /$DOWNLOAD_PATH
if [ -d "$NGINX_PATH" ]; then
	echo "nginx-1.3.4 download is OK!"
else
	wget http://nginx.org/download/nginx-1.3.4.tar.gz
	tar -zxvf nginx-1.3.4.tar.gz
fi	
cd nginx-1.3.4
chmod 777 configure
patch -p1 < ../nginx-http-sysguard/nginx_sysguard_1.2.5.patch
./configure --prefix=/usr/local/nginx \
--with-pcre=/$DOWNLOAD_PATH/pcre-8.31 \
--with-zlib=/$DOWNLOAD_PATH/zlib \
--with-http_realip_module \
--with-http_stub_status_module \
--with-google_perftools_module \
--add-module=/$DOWNLOAD_PATH/ngx_http_consistent_hash \
--add-module=/$DOWNLOAD_PATH/ngx_cache_purge \
--add-module=/$DOWNLOAD_PATH/nginx-http-sysguard \
--add-module=/$DOWNLOAD_PATH/ngx_devel_kit \
--add-module=/$DOWNLOAD_PATH/lua-nginx-module \
--with-debug
make && make install


if [ -f "/usr/local/nginx/sbin/nginx" ]; then
	echo "/usr/local/nginx/sbin/nginx is ok"
else
	echo "nginx install is error"
fi
