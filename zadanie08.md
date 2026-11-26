https://github.com/erykrybak/breach-checker/actions/runs/44552814461
0.168 ^ Tag must be paired, no start tag: [ </h1> ] (tag-pair)
ERROR: failed to build: failed to solve: process "/bin/sh -c htmlhint index.html" did not complete successfully: exit code: 1
https://github.com/erykrybak/breach-checker/actions/runs/44553907035

Teraz verify pobiera z rejestru GHCR oba gotowe obrazy zbudowane z tego commita, czyli dokładnie te same, które po przejściu testów dostaną tag latest i trafią na produkcję. Wcześniej z rejestru pobierany był tylko backend, a frontend budował się lokalnie podczas samego testu.

https://github.com/erykrybak/breach-checker/actions/runs/45820228160
https://github.com/erykrybak/breach-checker/actions/runs/45820637866

Po nieudanym uruchomieniu tag latest nadal wskazywał na poprzedni, działający obraz backendu, ponieważ job promote został pominięty. Dzięki temu ktoś pobierający obraz bez podawania konkretnego tagu (domyślnie :latest) dostanie starszą, ale sprawną wersję aplikacji zamiast zepsutej.

```
╭─ddr43@fedora …/breach-checker on  main !
╰─$ docker pull ghcr.io/erykrybak/breach-checker-backend:latest ✔
latest: Pulling from erykrybak/breach-checker-backend
Digest: sha256:2679e5b62e5742d8421b891cdc44c99a7c35f60c1927c5a00f001ea619603874
Status: Image is up to date for ghcr.io/erykrybak/breach-checker-backend:latest
ghcr.io/erykrybak/breach-checker-backend:latest
╭─ddr43@fedora …/breach-checker on  main !
╰─$ docker pull ghcr.io/erykrybak/breach-checker-backend:$(git rev-parse HEAD) ✔
aefa59c6a027e49f1c3e89b76c51649bdd81cef4: Pulling from erykrybak/breach-checker-backend
Digest: sha256:2679e5b62e5742d8421b891cdc44c99a7c35f60c1927c5a00f001ea619603874
Status: Image is up to date for ghcr.io/erykrybak/breach-checker-backend:aefa59c6a027e49f1c3e89b76c51649bdd81cef4
ghcr.io/erykrybak/breach-checker-backend:aefa59c6a027e49f1c3e89b76c51649bdd81cef4
╭─ddr43@fedora …/breach-checker on  main !
╰─$ docker images --digests ghcr.io/erykrybak/breach-checker-backend ✖
REPOSITORY TAG DIGEST IMAGE ID CREATED SIZE
ghcr.io/erykrybak/breach-checker-backend aefa59c6a027e49f1c3e89b76c51649bdd81cef4 sha256:2679e5b62e5742d8421b891cdc44c99a7c35f60c1927c5a00f001ea619603874 2679e5b62e57 5 minutes ago 210MB
ghcr.io/erykrybak/breach-checker-backend latest sha256:2679e5b62e5742d8421b891cdc44c99a7c35f60c1927c5a00f001ea619603874 2679e5b62e57 5 minutes ago 210MB
╭─ddr43@fedora …/breach-checker on  main !
╰─$ docker push ghcr.io/erykrybak/breach-checker-backend:latest ✔
The push refers to repository [ghcr.io/erykrybak/breach-checker-backend]
286d8c291daa: Layer already exists
83a14706aa6d: Layer already exists
30cf67d7101c: Layer already exists
e3e428093f5e: Layer already exists
b44963d1a675: Layer already exists
358128fab086: Layer already exists
54f1c3dee2ce: Layer already exists
1f7b3a0050ae: Layer already exists
59bfb3ca6a9e: Layer already exists
latest: digest: sha256:2679e5b62e5742d8421b891cdc44c99a7c35f60c1927c5a00f001ea619603874 size: 2199
```

Oba tagi (latest i skrót commita) mają identyczny digest sha256, co oznacza, że wskazują na dokładnie ten sam obraz. docker pull zadziałał bez logowania, ponieważ pakiet jest publiczny; docker push również przeszedł (fedora zapisała dane logowania),powinien zostać odrzucony, żeby nikt obcy nie nadpisał obrazu w rejestrze. Token z zakresem write:packages służył w GitHub Actions do uwierzytelnienia w GHCR i wypchnięcia zbudowanych obrazów oraz tagu latest.
