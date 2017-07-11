# proxy_ctl_docker

[proxy_ctl] is a tool designed for simplifying the job of setting reverse proxy when using nginx. This repo is aims to build an docker which can be used directly. 

proxy_ctl_docker contains:

- [nginx]: serve as reverse proxy server
- [acme.sh]: issues and renews ssl certificate
- [proxy_ctl]: a tool which manage reverse proxy server
- [supervisord]: a process control system

## Build proxy_ctl_docker

```
git clone https://github.com/netctld/proxy_ctl_docker.git
cd proxy_ctl_docker
docker build -t proxy_ctl_docker .
```

## Run proxy_ctl_docker

```
mkdir -p /var/lib/nginx/{vhost,ssl,tmp,log}
docker run --name proxy_ctl_docker -d -p 80:80 -p 443:443 -v /var/lib/nginx:/var/lib/nginx proxy_ctl_docker
```

## Setup reverse proxy for your website

You can learn more command at [proxy_ctl]'s git repo.

```
DOMAIN="example.com"
TARGET="10.0.0.1:8080"
docker exec proxy_ctl_docker proxy_ctl add ${DOMAIN} ${TARGET}
```

## License

Copyright year [netctld]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[proxy_ctl]: https://github.com/netctld/proxy_ctl
[nginx]: https://nginx.org/en/
[acme.sh]: https://github.com/Neilpang/acme.sh
[supervisord]: http://supervisord.org/
[netctld]: https://github.com/netctld
