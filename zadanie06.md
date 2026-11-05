╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker compose exec backend pytest -v                                                                                                                                                     ✔
===================================================================================== test session starts ======================================================================================
platform linux -- Python 3.12.16, pytest-8.4.2, pluggy-1.7.0 -- /usr/local/bin/python3.12
cachedir: .pytest_cache
rootdir: /app
collected 7 items                                                                                                                                                                              

tests/test_check.py::test_leaked_hash_is_found PASSED                                                                                                                                    [ 14%]
tests/test_check.py::test_unknown_hash_is_not_found PASSED                                                                                                                               [ 28%]
tests/test_check.py::test_missing_hash_field PASSED                                                                                                                                      [ 42%]
tests/test_check.py::test_plaintext_password_is_rejected PASSED                                                                                                                          [ 57%]
tests/test_check.py::test_is_uppercase_passable PASSED                                                                                                                                   [ 71%]
tests/test_check.py::test_is_json PASSED                                                                                                                                                 [ 85%]
tests/test_check.py::test_is_out_of_range PASSED                                                                                                                                         [100%]

====================================================================================== 7 passed in 0.10s =======================================================================================
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker compose exec backend pytest -v                                                                                                                                                     ✔
===================================================================================== test session starts ======================================================================================
platform linux -- Python 3.12.16, pytest-8.4.2, pluggy-1.7.0 -- /usr/local/bin/python3.12
cachedir: .pytest_cache
rootdir: /app
collected 7 items                                                                                                                                                                              

tests/test_check.py::test_leaked_hash_is_found PASSED                                                                                                                                    [ 14%]
tests/test_check.py::test_unknown_hash_is_not_found PASSED                                                                                                                               [ 28%]
tests/test_check.py::test_missing_hash_field PASSED                                                                                                                                      [ 42%]
tests/test_check.py::test_plaintext_password_is_rejected PASSED                                                                                                                          [ 57%]
tests/test_check.py::test_is_uppercase_passable FAILED                                                                                                                                   [ 71%]
tests/test_check.py::test_is_json PASSED                                                                                                                                                 [ 85%]
tests/test_check.py::test_is_out_of_range PASSED                                                                                                                                         [100%]

=========================================================================================== FAILURES ===========================================================================================
__________________________________________________________________________________ test_is_uppercase_passable __________________________________________________________________________________

client = <FlaskClient <Flask 'app'>>

    def test_is_uppercase_passable(client):
        response = client.post("/check", json={"hash": LEAKED.upper()})
>       assert response.status_code == 200
E       assert 400 == 200
E        +  where 400 = <WrapperTestResponse streamed [400 BAD REQUEST]>.status_code

tests/test_check.py:32: AssertionError
=================================================================================== short test summary info ====================================================================================
FAILED tests/test_check.py::test_is_uppercase_passable - assert 400 == 200
================================================================================= 1 failed, 6 passed in 0.18s ==================================================================================
╭─ddr43@fedora …/breach-checker on  main !?
╰─$                                                                                                                                                                                           ✖
Testy z zajęć nie wykryły usunięcia .lower() bo żaden z nich nie sprawdzał takiego scenariusza.

╭─ddr43@fedora …/breach-checker on  main !?
╰─$ curl -s -o blad.html -w "HTTP %{http_code}\n" -X POST http://localhost:8080/api/check -H "Content-Type: application/json" -d '{"hash":"7c4a8d09ca3762af61e59520943dc26494f8941b"}'        ✔
HTTP 500

╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker compose ps -a                                                                                                                                                                      ✔
NAME                        IMAGE                     COMMAND                  SERVICE    CREATED          STATUS                      PORTS
breach-checker-backend-1    breach-checker-backend    "flask --app app run…"   backend    35 minutes ago   Exited (1) 11 seconds ago
breach-checker-db-1         postgres:16-alpine        "docker-entrypoint.s…"   db         7 days ago       Exited (0) 5 minutes ago
breach-checker-frontend-1   breach-checker-frontend   "/docker-entrypoint.…"   frontend   35 minutes ago   Up 35 minutes               0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
╭─ddr43@fedora …/breach-checker on  main !?
╰─$ docker inspect --format '{{.State.Status}} {{.State.ExitCode}}' breach-checker-backend-1                                                                                                  ✔
exited 1

╭─ddr43@fedora ~
╰─$ curl http://localhost:8080/nginx.conf                                     ✔
server {
    listen 80;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }

    location /api/ {
        proxy_pass http://backend:5000/;
    }
}
╭─ddr43@fedora ~
╰─$ curl http://localhost:8080/nginx.conf                                     ✔
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.31.6</center>
</body>
</html>
╭─ddr43@fedora ~
╰─$           

Obraz produkcyjny nie ma tego problemu bo nie montuje całego katalogu tylko kopiuje konkretne zdefiniowane pliki. Montowanie katalogiu projektu do serwowanego katalogu jest ryzykowne bo może prowadzić do wycieku kodu źródłowego i innych wrażliwych danych.
