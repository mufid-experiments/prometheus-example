# Eksperimen dengan Klien Prometheus

Baca artikelnya di: <pending>

## Pemasangan

Pastikan Anda sudah memiliki perangkat lunak berikut:

- JDK 11
- jruby (bisa juga dengan rvm lewat `rvm install jruby`)
- Docker
- Docker Compose
- forego

## Memulai

Pergi ke direktori promgraf, kemudian hidupkan Prometheus dengan
perintah berikut:

    cd promgraf
    ./setup.sh

Buka terminal baru, kemudian pergilah ke folder app. Mulai aplikasi
HitApp dengan perintah forego start:

    cd app
    forego start

Voila! Aplikasi sudah dijalankan. Berikut adalah port yang bisa
Anda inspeksi:

- hitapp-1 (A): localhost:5000 (web), localhost:8080 (Prometheus Scrape Port)
- hitapp-2 (B): localhost:5100 (web), localhost:8081 (Prometheus Scrape Port)
- Prometheus: 9090

## Simulasi Lalu Lintas Data dengan Apache Bench

Sebagai kemampuan opsional, Anda dapat menggunakan Apache Bench
untuk secara acak memberikan lalu lintas ke HitApp. Menggunakan
Apache Bench berarti juga akan menghasilkan metric Prometheus
tanpa harus Anda mengunjungi HitApp secara manual.

Anda dapat menggunakan perintah berikut:

    while true; do ab -n 150 -c $(jruby -e "puts (Random.rand * 16).ceil") http://localhost:5100/; done

