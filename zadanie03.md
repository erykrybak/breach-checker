╭─ddr43@fedora …/breach-checker on  zadanie03 !?
╰─$ docker inspect --format '{{json .Config.Labels}}' eryk-frontend:v1                                                                                                                        ✔
{"autor":"Imię Nazwisko","data":"2026-10-14","maintainer":"eryk.rybak@example.com"}
╭─ddr43@fedora …/breach-checker on  zadanie03 !?
╰─$ docker inspect --format '{{json .Config.Labels}}' eryk-frontend:latest                                                                                                                    ✔
{"autor":"Imię Nazwisko","data":"2026-10-14","maintainer":"eryk.rybak@example.com"}

╭─ddr43@fedora …/breach-checker on  zadanie03 !?
╰─$ docker history eryk-frontend:v1                                                                                                                                                           ✔
IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
f4f631200fa0   17 minutes ago   EXPOSE [80/tcp]                                 0B        buildkit.dockerfile.v0
<missing>      17 minutes ago   RUN /bin/sh -c htmlhint /usr/share/nginx/htm…   0B        buildkit.dockerfile.v0
<missing>      17 minutes ago   COPY . /usr/share/nginx/html # buildkit         12.3kB    buildkit.dockerfile.v0
<missing>      22 minutes ago   RUN /bin/sh -c apk add --no-cache nodejs npm…   99.3MB    buildkit.dockerfile.v0
<missing>      22 minutes ago   LABEL autor=Imię Nazwisko data=2026-10-14       0B        buildkit.dockerfile.v0
<missing>      22 minutes ago   LABEL maintainer=eryk.rybak@example.com         0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      RUN /bin/sh -c set -x     && apkArch="$(cat …   52.8MB    buildkit.dockerfile.v0
<missing>      3 weeks ago      ENV ACME_VERSION=0.4.1                          0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      ENV NJS_RELEASE=1                               0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      ENV NJS_VERSION=1.0.1                           0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      CMD ["nginx" "-g" "daemon off;"]                0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      STOPSIGNAL SIGQUIT                              0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      EXPOSE map[80/tcp:{}]                           0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      ENTRYPOINT ["/docker-entrypoint.sh"]            0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      COPY 30-tune-worker-processes.sh /docker-ent…   8.19kB    buildkit.dockerfile.v0
<missing>      3 weeks ago      COPY 20-envsubst-on-templates.sh /docker-ent…   4.1kB     buildkit.dockerfile.v0
<missing>      3 weeks ago      COPY 15-local-resolvers.envsh /docker-entryp…   4.1kB     buildkit.dockerfile.v0
<missing>      3 weeks ago      COPY 10-listen-on-ipv6-by-default.sh /docker…   4.1kB     buildkit.dockerfile.v0
<missing>      3 weeks ago      COPY docker-entrypoint.sh / # buildkit          4.1kB     buildkit.dockerfile.v0
<missing>      3 weeks ago      RUN /bin/sh -c set -x     && addgroup -g 101…   5.53MB    buildkit.dockerfile.v0
<missing>      3 weeks ago      ENV DYNPKG_RELEASE=1                            0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      ENV PKG_RELEASE=1                               0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      ENV NGINX_VERSION=1.31.6                        0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      LABEL maintainer=NGINX Docker Maintainers <d…   0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      CMD ["/bin/sh"]                                 0B        buildkit.dockerfile.v0
<missing>      3 weeks ago      ADD alpine-minirootfs-3.24.2-x86_64.tar.gz /…   10.1MB    buildkit.dockerfile.v0

Warstwy do RUN /bin/sh -c set -x... pochodzą z bazowego obrazu nginx, pozostałe z Dockerfile. Niektóre warstwy mają 0B ponieważ tylko dopisują metadane, nie instalują bibliotek ani nie kopiują plików. Widać tylko nową wartość maintainer ponieważ nadpisuje ona oryginalną.

Wartości build.txt:
Kontener 1: Thu Oct 15 14:17:20 UTC 2026
Kontener 2: Thu Oct 15 14:17:20 UTC 2026

╭─ddr43@fedora …/breach-checker on  zadanie03 !?
╰─$ docker ps                                                                                                                                                                                 ✔
CONTAINER ID   IMAGE           COMMAND                  CREATED              STATUS              PORTS                                     NAMES
b73475ceb6c5   eryk-frontend   "/docker-entrypoint.…"   3 seconds ago        Up 2 seconds        0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   frontend2
6fae8f708e0a   eryk-frontend   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   frontend

Czas build jest ten sam ponieważ zostaje zapisany raz podczas procesu budowania obrazu, nie uruchamiania kontenera.

root   /usr/share/nginx/html;
Wszystkie pliki zapisujemy do /usr/share/nginx/html ponieważ jest to domyślna ścieżka z której nginx serwuje stronę.

╭─ddr43@fedora …/breach-checker on  zadanie03 !?
╰─$ docker exec frontend ls /usr/share/nginx/html                                                                                                                                             ✔
50x.html
build.txt
index.html
╭─ddr43@fedora …/breach-checker on  zadanie03 !?
╰─$ docker exec frontend ls /usr/share/nginx                                                                                                                                                  ✔
html
index.html
script.js
style.css

htmlhint sprawdził domyślny plik index.html nginx, który ma poprawną składnię więc build przeszedł.

╭─ddr43@fedora …/breach-checker on  zadanie03 !?
╰─$ docker rmi breach-checker-frontend:latest                                                                                                                                                 ✔
Untagged: breach-checker-frontend:latest
╭─ddr43@fedora …/breach-checker on  zadanie03 !?
╰─$ docker images                                                                                                                                                                             ✔
                                                                                                                                                                            i Info →   U  In Use
IMAGE                        ID             DISK USAGE   CONTENT SIZE   EXTRA
breach-checker-frontend:v1   2738303181f4       94.8MB         26.3MB        
breach-checker-frontend:v2   4716e5f01136       94.8MB         26.3MB        
breach-checker-frontend:v3   5cf5748c9f79        227MB         59.5MB        
eryk-frontend:latest         a99137a494c9        227MB         59.5MB    U   
eryk-frontend:v1             f4f631200fa0        227MB         59.5MB        
nginx:alpine                 df221db836e1       95.6MB         27.2MB        
redis:alpine                 3811787313eb        162MB         39.6MB        
╭─ddr43@fedora …/breach-checker on  zadanie03 !?
╰─$ docker rmi breach-checker-frontend:v2                                                                                                                                                     ✔
Untagged: breach-checker-frontend:v2
Deleted: sha256:4716e5f0113636e0ab48897ed3253ce77d74ac10936d4b3664aeef9c774afe89

Docker usuwa obraz tylko wtedy kiedy usunięty zostaje ostatni przypisany mu tag.
