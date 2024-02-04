# Use an Opensource Red Hat-based image
FROM centos:latest

# Install required packages for MediaWiki
RUN yum install -y epel-release && \
    yum install -y httpd httpd-tools wget tar \
    rh-php73 rh-php73-php rh-php73-php-mbstring rh-php73-php-mysqlnd rh-php73-php-gd rh-php73-php-xml \
    mod_ssl php-intl php-apcu && \
    yum clean all && \
    rm -rf /var/cache/yum

# Enable required modules for Apache
RUN systemctl enable httpd 


# Download and install MediaWiki
RUN mkdir -p /var/www && \
    cd /var/www && \
    wget https://releases.wikimedia.org/mediawiki/1.41/mediawiki-1.41.0.tar.gz && \
    wget https://releases.wikimedia.org/mediawiki/1.41/mediawiki-1.41.0.tar.gz.sig && \
    gpg --verify mediawiki-1.41.0.tar.gz.sig mediawiki-1.41.0.tar.gz && \
    tar -zxf mediawiki-1.41.0.tar.gz && \
    ln -s mediawiki-1.41.0/ mediawiki


# Open necessary ports in firewall
RUN firewall-cmd --permanent --zone=public --add-service=http && \
    firewall-cmd --permanent --zone=public --add-service=https && \
    systemctl restart firewalld

EXPOSE 8080
#Security user
USER 1001 
# Start Apache service
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]