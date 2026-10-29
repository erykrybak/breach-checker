[+] up 6/6
 ✔ Image breach-checker-backend        Built                                                                                                                                                1.8s
 ✔ Image breach-checker-frontend       Built                                                                                                                                                1.8s
 ✔ Network breach-checker_default      Created                                                                                                                                              0.2s
 ✔ Container breach-checker-db-1       Healthy                                                                                                                                              6.1s
 ✔ Container breach-checker-backend-1  Healthy                                                                                                                                             11.7s
 ✔ Container breach-checker-frontend-1 Started  

 ╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker ps                                                                                                                                                                                 ✔
CONTAINER ID   IMAGE                     COMMAND                  CREATED          STATUS                    PORTS                                     NAMES
faaa448e6f36   breach-checker-frontend   "/docker-entrypoint.…"   39 seconds ago   Up 27 seconds             0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   breach-checker-frontend-1
7973a47e89db   breach-checker-backend    "python app.py"          39 seconds ago   Up 33 seconds (healthy)   5000/tcp                                  breach-checker-backend-1
14055e8b927c   postgres:16-alpine        "docker-entrypoint.s…"   39 seconds ago   Up 38 seconds (healthy)   5432/tcp                                  breach-checker-db-1

╭─ddr43@fedora …/breach-checker on  main !?
╰─$ curl -X POST http://localhost:8080/api/check -H "Content-Type: application/json" -d '{"hash":"bc45408273d7e1914b741c3407b0b559764f7876"}'                                                 ✔
{"found":true}
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ curl -X POST http://localhost:8080/api/check -H "Content-Type: application/json" -d '{"hash":"bc45408273d7e1914b741c3407b0b559764f7876"}'                                                 ✔
{"found":true}
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ curl -X POST http://localhost:8080/api/check -H "Content-Type: application/json" -d '{"hash":"bc45408273d7e1914b741c3407b0b559764f7876"}'                                                 ✔
{"found":false}

Skrót przetrwał down bo baza danych zapisana jest w wolumenie, down -v usuwa wolumen razem z ręcznie dodanym hasłem, a 89 hashy jest ponownie dodane skryptem inicjalizacyjnym.

╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker compose ps                                                                                                                                                                         ✔
NAME                        IMAGE                     COMMAND                  SERVICE    CREATED         STATUS                   PORTS
breach-checker-backend-1    breach-checker-backend    "python app.py"          backend    2 minutes ago   Up 2 minutes (healthy)   5000/tcp
breach-checker-backend-2    breach-checker-backend    "python app.py"          backend    8 seconds ago   Up 7 seconds (healthy)   5000/tcp
breach-checker-backend-3    breach-checker-backend    "python app.py"          backend    8 seconds ago   Up 7 seconds (healthy)   5000/tcp
breach-checker-db-1         postgres:16-alpine        "docker-entrypoint.s…"   db         2 minutes ago   Up 2 minutes (healthy)   5432/tcp
breach-checker-frontend-1   breach-checker-frontend   "/docker-entrypoint.…"   frontend   2 minutes ago   Up 2 minutes             0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker compose exec frontend nslookup backend                                                                                                                                             ✔
Server:		127.0.0.11
Address:	127.0.0.11:53

Non-authoritative answer:

Non-authoritative answer:
Name:	backend
Address: 172.19.0.6
Name:	backend
Address: 172.19.0.3
Name:	backend
Address: 172.19.0.5

backend-1  | check: hash=bc454...
backend-1  | 172.19.0.4 - - [29/Oct/2026 15:07:12] "POST /check HTTP/1.1" 200 -
backend-1  | check: hash=bc454...
backend-1  | 172.19.0.4 - - [29/Oct/2026 15:07:12] "POST /check HTTP/1.1" 200 -
backend-1  | check: hash=bc454...
backend-1  | 172.19.0.4 - - [29/Oct/2026 15:07:12] "POST /check HTTP/1.1" 200 -
backend-1  | check: hash=bc454...
backend-1  | 172.19.0.4 - - [29/Oct/2026 15:07:12] "POST /check HTTP/1.1" 200 -
backend-1  | check: hash=bc454...

backend-3  | check: hash=bc454...
backend-3  | 172.19.0.4 - - [29/Oct/2026 15:07:51] "POST /check HTTP/1.1" 200 -
backend-3  | check: hash=bc454...
backend-3  | 172.19.0.4 - - [29/Oct/2026 15:07:51] "POST /check HTTP/1.1" 200 -
backend-2  | 172.19.0.4 - - [29/Oct/2026 15:07:51] "POST /check HTTP/1.1" 200 -
backend-2  | check: hash=bc454...
backend-2  | 172.19.0.4 - - [29/Oct/2026 15:07:51] "POST /check HTTP/1.1" 200 -
backend-2  | check: hash=bc454...

Przed restartem frontednu wszystkie zapytania szły na jeden adres ponieważ NGINX rozwiązuje nazwy DNS przy starcie. Skalowanie nie byłoby możliwe z ports: 5000:5000 ponieważ nie możemy publikować wielu kopii usługi na ten sam port hosta.
