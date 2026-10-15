FROM nginx:alpine
LABEL maintainer="eryk.rybak@example.com"
LABEL autor="Imię Nazwisko" data="2026-10-14"
RUN apk add --no-cache nodejs npm && npm install -g htmlhint
COPY . /usr/share/nginx/html
RUN date > /usr/share/nginx/html/build.txt
RUN htmlhint /usr/share/nginx/html/index.html
EXPOSE 80

