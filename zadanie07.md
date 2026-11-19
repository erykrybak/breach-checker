Pull pobrał nowe wersje z wprowadzonymi łatkami, stąd mniejsza ilość błędów. Niektóre obrazy rzadziej wprowadzają aktualizacje, więc podatności zostają w nich na dłużej, ilość wporwadzonych łatek zależy też od ilości bibliotek i zależności w obrazie: więcej dla backendu niż lekkiego frontendu

backend-1 | FileNotFoundError: [Errno 2] No usable temporary directory found in ['/tmp', '/var/tmp', '/usr/tmp', '/app']
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker compose exec backend touch /etc/test ✔
touch: cannot touch '/etc/test': Read-only file system
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker compose exec backend touch /tmp/test ✖
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker compose exec backend grep CapEff /proc/1/status ✔
CapEff: 0000000000000000

╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker compose exec backend pytest ✔
OCI runtime exec failed: exec failed: unable to start container process: exec: "pytest": executable file not found in $PATH

read_only: true uniemożliwia modyfikację systemu plików kontenera (np. wstrzyknięcie złośliwych skryptów, podmianę plików aplikacji itp)
cap_drop: [ALL] odbiera procesowi wszystkie uprawnienia jądra Linuksa (capabilities), blokując m.in. manipulacje siecią, montowanie systemów plików czy przejmowanie praw innych procesów
security_opt: [no-new-privileges:true] blokuje możliwość eskalacji uprawnień przez proces i jego procesy potomne (np. poprzez pliki z bitem setuid/setgid)

appuser mógł zapisywać pliki jeżeli miał do tego uprawnienia, readonly odbiera możliwość zapisu wszystkim użytkownikom na niższym poziomie, wymaga stworzenia wolumenu w którym jest możliwośc zapisu

╭─ddr43@fedora …/Projects/nw-kurs/lab07-sekret
╰─$ docker history sekret-demo:plik ✔
IMAGE CREATED CREATED BY SIZE COMMENT
97a1051f8730 23 seconds ago RUN /bin/sh -c rm /tmp/klucz.txt # buildkit 0B buildkit.dockerfile.v0
<missing> 23 seconds ago RUN /bin/sh -c test -s /tmp/klucz.txt && ech… 0B buildkit.dockerfile.v0
<missing> 23 seconds ago COPY klucz.txt /tmp/klucz.txt # buildkit 4.1kB buildkit.dockerfile.v0
<missing> 13 days ago CMD ["/bin/sh"] 0B buildkit.dockerfile.v0
<missing> 13 days ago ADD alpine-minirootfs-3.22.8-x86_64.tar.gz /… 9.94MB buildkit.dockerfile.v0

╭─ddr43@fedora …/Projects/nw-kurs/lab07-sekret
╰─$ for f in obraz/blobs/sha256/*; do tar -tf "$f" 2>/dev/null | grep -qx 'tmp/klucz.txt' && tar -xOf "$f" tmp/klucz.txt; done ✔
tajny-klucz-eryk

Klucz nie został w pełni usunięty, ponieważ rm nie usuwa go z poprzedniej warsty budowy obrazu, tylko ukrywa go w wyższej wartwie. Sekrety potrzebne wyłącznie na etapie budowania obrazu należy przekazywać za pomocą bezpiecznego montowania BuildKit (RUN --mount=type=secret,id=klucz,target=/tmp/klucz.txt, oraz flagi --secret id=klucz,src=klucz.txt przy docker build), dzięki czemu plik jest udostępniany tylko na czas wykonania pojedynczej instrukcji RUN i nie zostaje zapisany w żadnej warstwie obrazu.
