╭─ddr43@fedora …/breach-checker on  main !?
╰─$ curl -X GET http://localhost:5000/health -H "Content-Type: application/json" -d '{"hash":}'                                                                                               ✔
{"status":"ok"}
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker logs backend                                                                                                                                                                       ✔
Wczytano 89 hashy z /app/data/leaked-sha1.txt
 * Serving Flask app 'app'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://172.18.0.2:5000
Press CTRL+C to quit
172.18.0.1 - - [22/Oct/2026 13:56:37] "GET /health HTTP/1.1" 200 -

╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker run --rm --network breach-net healthcheck-probe                                                                                                                                    ✔
  % Total    % Received % Xferd  Average Speed  Time    Time    Time   Current
                                 Dload  Upload  Total   Spent   Left   Speed
100     16 100     16   0      0   3535      0  {"status":"ok"}             0
100     16 100     16   0      0   3312      0                              0
backend: OK
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker run --rm healthcheck-probe                                                                                                                                                         ✔
curl: (6) Could not resolve host: backend (Domain name not found)
backend: UNREACHABLE
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker stop backend                                                                                                                                                                       ✔
backend
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker run --rm --network breach-net healthcheck-probe                                                                                                                                    ✔
curl: (6) Could not resolve host: backend (Domain name not found)
backend: UNREACHABLE

Bez --network test zwraca UNREACHABLE, ponieważ kontenery są wtedy w różnych sieciach i health-probe nie ma dostępu do serwera DNS w sieci breach-net.

╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker exec backend cat /tmp/notatka.txt                                                                                                                                                  ✔
notatka
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker exec backend cat /tmp/notatka.txt                                                                                                                                                  ✔
cat: /tmp/notatka.txt: No such file or directory
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker run --rm -v breach-dane:/dane alpine sh -c "date >> /dane/historia.txt"                                                                                                            ✖
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker run --rm -v breach-dane:/dane alpine sh -c "date >> /dane/historia.txt; cat /dane/historia.txt"                                                                                    ✔
Thu Oct 22 14:11:07 UTC 2026
Thu Oct 22 14:11:14 UTC 2026

Plik w /tmp przetrwał restart ale nie usunięcie kontenera ponieważ został zapisany do warsty zapisywalnej kontenera, bezpośrednio powiązanej z samym kontenerem. historia.txt przetrwała usunięcia kontenerów ponieważ jest przechowywana w zewnętrznym nazwanym wolumenie. Lista wycieków również by przetrwała, ponieważ jest zapisana na systemie hosta a do kontenera jest jedynie zamontowana.
