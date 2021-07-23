FROM ubuntu:20.04
MAINTAINER ASCDC <asdc.sinica@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

ADD run.sh /script/run.sh

RUN chmod +x /script/*.sh && \
	sed -i -E 's/http:\/\/(.*\.)?(archive\.ubuntu\.com)/http:\/\/tw\.\2/g' /etc/apt/sources.list && \
	apt-get update && \
	echo "tzdata tzdata/Areas select Asia" | debconf-set-selections && \
	echo "tzdata tzdata/Zones/Asia select Taipei" | debconf-set-selections && \
	echo "locales locales/default_environment_locale select zh_TW.UTF-8" | debconf-set-selections && \
	echo "locales locales/locales_to_be_generated multiselect zh_TW.UTF-8 UTF-8" | debconf-set-selections && \
	apt-get -y install jq git wget curl vim apt-utils software-properties-common sudo tzdata locales language-pack-zh-hant language-pack-zh-hant-base apt-transport-https ca-certificates gnupg-agent build-essential pkg-config libmagickwand-dev gcc-multilib dkms make gcc g++ && \
	ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
	dpkg-reconfigure --frontend noninteractive tzdata && \
	rm -f "/etc/locale.gen" && \
	dpkg-reconfigure --frontend noninteractive locales && \
	locale-gen en_US.UTF-8 && \
	export LANG=zh_TW.UTF-8 && \
	export LC_ALL=zh_TW.UTF-8 && \
	echo "export LANG=zh_TW.UTF-8" >> ~/.bashrc && \
	echo "export LC_ALL=zh_TW.UTF-8" >> ~/.bashrc && \
	echo "export TZ=Asia/Taipei" >> ~/.bashrc && \
	add-apt-repository -y ppa:ondrej/php && \
	add-apt-repository -y ppa:ondrej/apache2 && \
	apt-get update && \
	apt-get -y upgrade && \
	apt-get -y autoremove
RUN apt-get update && \
	apt-get -y upgrade && \
	apt-get install -y apache2 php7.4 php7.4-common php7.4-json php7.4-opcache php-uploadprogress php-memcache php7.4-zip php7.4-mysql php7.4-phpdbg php7.4-gd php7.4-imap php7.4-ldap php7.4-pgsql php7.4-pspell php7.4-tidy php7.4-dev php7.4-intl php7.4-curl php7.4-xmlrpc php7.4-xsl php7.4-bz2 php7.4-mbstring php7.4-maxminddb php7.4-lz4 php7.4-mcrypt php7.4-geoip php7.4-igbinary php7.4-redis php7.4-swoole php7.4-solr php7.4-imagick ttf-dejavu-core imagemagick && \
	ln -sf /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

EXPOSE 80
WORKDIR /var/www/html
ENTRYPOINT ["/script/run.sh"]
