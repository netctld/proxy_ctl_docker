FROM fedora
MAINTAINER LKS <lks@gidcs.net>

# update system
RUN dnf -y update

# install nginx
RUN dnf -y install nginx
RUN echo "" > /usr/share/nginx/html/index.html
COPY nginx.conf /etc/nginx/
COPY conf.d /etc/nginx/

# install acme.sh and its dependency
RUN dnf -y install tar crontabs nc
RUN curl https://get.acme.sh | sh

# install proxy_ctl
ADD https://raw.githubusercontent.com/netctld/proxy_ctl/master/proxy_ctl /usr/bin
RUN chmod 755 /usr/bin/proxy_ctl

# install supervisor
RUN dnf -y install python-setuptools
RUN easy_install supervisor
RUN easy_install supervisor
RUN /usr/bin/echo_supervisord_conf > /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor
# make it run in foreground
RUN sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisord.conf
# include ini files
RUN mkdir /etc/supervisord.d
RUN echo [include] >> /etc/supervisord.conf
RUN echo 'files = /etc/supervisord.d/*.ini' >> /etc/supervisord.conf

# setup all programs
RUN echo [program:nginx] >> /etc/supervisord.d/nginx.ini
RUN echo 'command=/usr/sbin/nginx' >> /etc/supervisord.d/nginx.ini
RUN echo '' >> /etc/supervisord.d/nginx.ini
RUN echo [program:crond] >> /etc/supervisord.d/crond.ini
RUN echo 'command=/usr/sbin/crond -n' >> /etc/supervisord.d/crond.ini
RUN echo '' >> /etc/supervisord.d/crond.ini

#RUN dnf clean all

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
