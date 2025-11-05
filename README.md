# Jarkom-Modul-3-2025-K44
No  | Nama                  | NRP 
--- | ----                  | ---
1   | Ahmad Yazid Arifuddin | 5027241040
2   | Tiara Fatimah Azzahra | 5027241090

## Soal 1 — Topologi & Routing Dasar (Durin + IP Statis)
- Konfigurasi router Durin: `eth0` DHCP (internet), `eth1–eth5` static untuk subnet 192.233.1.0/24 s.d. 192.233.5.0/24.
- NAT Masquerade untuk akses internet: 192.233.0.0/16 via `eth0`.
- Set IP statis node: Elendil, Isildur, Anarion, Miriel, elros (Numenor); Galadriel, Celeborn, Oropher, Celebrimbor, Pharazon (Peri); Erendis, Amdir (DNS); Aldarion, Palantir, Narvi (Server); Minastir.

### Validasi
- Cek IP dan gateway tiap node: `ip a`, `ip r`.
- Uji internet dari klien: `ping -c 3 8.8.8.8`, `ping -c 3 google.com`.
- Dari Durin: `iptables -t nat -S` memastikan aturan MASQUERADE aktif.
- Dokumentasi: lihat `assets/soal1/image.png`.

## Soal 2 — DHCP Server & Relay (Aldarion, Durin)
- Aldarion: install `isc-dhcp-server`, set subnet 192.233.1.0/24, 2.0/24 (range), 3.0/24 (router+broadcast), deklarasi 4.0/24 (kosong), fixed-address Khamul by MAC.
- Durin: `isc-dhcp-relay` mengarahkan request ke 192.233.4.2; IP forwarding diaktifkan.
- Klien dinamis (Khamul, Amandil, Gilgalad): interface DHCP.

### Validasi
- Di klien DHCP: `dhclient -r eth0 && dhclient eth0`, lalu `ip a` untuk memastikan dapat IP sesuai range.
- Ping gateway dan internet: `ping -c 3 192.233.x.1`, `ping -c 3 google.com`.
- Di Aldarion: `journalctl -u isc-dhcp-server | tail` untuk melihat offer/ack.

## Soal 3 — DNS Resolver (Minastir) & Distribusi DNS via DHCP
- Aldarion: `option domain-name-servers 192.233.5.2` untuk klien dinamis.
- Minastir: install BIND9 sebagai recursive resolver, forwarder ke `192.168.122.1`, allow-recursion untuk 192.233.0.0/16.
- Klien statis diarahkan DNS ke Minastir.

### Validasi
- Dari klien: `dig @192.233.5.2 google.com +short` dan `ping -c 3 google.com`.
- Pastikan `/etc/resolv.conf` menunjuk `192.233.5.2`.

## Soal 4 — DNS Authoritative Master/Slave (Erendis/Amdir) + Zona k44.com
- Erendis (Master): konfigurasi zona `k44.com`, allow-transfer ke Amdir; isi NS dan A records untuk host-2.
- Amdir (Slave): zona `k44.com` sebagai slave dari Erendis.
- Aldarion: DHCP untuk klien dinamis gunakan DNS Erendis & Amdir.

### Validasi
- `dig @192.233.3.2 elendil.k44.com A +short` dan periksa hasil IP.
- `dig @192.233.3.3 elendil.k44.com A +short` memastikan slave melayani.
- Coba `host elendil.k44.com 192.233.3.2` dan `... 192.233.3.3`.

## Soal 5 — Reverse DNS, CNAME, dan TXT
- Tambah reverse zone `3.91.10.in-addr.arpa` (untuk 192.233.3.0/24) pada Master dan Slave.
- Tambah `CNAME www → k44.com` dan TXT records:
  - "Cincin Sauron=elros.k44.com"
  - "Aliansi Terakhir=pharazon.k44.com"

### Validasi
- `dig @192.233.3.2 -x 192.233.3.2 +short` → `ns1.k44.com.`; `... -x 192.233.3.3` → `ns2.k44.com.`
- `dig @192.233.3.2 www.k44.com CNAME +short` → `k44.com.`
- `dig @192.233.3.2 k44.com TXT +short` → dua nilai TXT.

## Soal 6 — DHCP Lease Time Berbeda per Subnet
- Subnet 192.233.1.0/24: default 1800s, max 3600s.
- Subnet 192.233.2.0/24: default 600s, max 3600s.
- Subnet lain sesuai sebelumnya; Khamul tetap fixed.

### Validasi
- Di klien 192.233.1.0/24 dan 192.233.2.0/24: periksa `/var/lib/dhcp/dhclient.leases` (renewal time).
- `dhclient -v` untuk melihat waktu sewa (lease) saat akuisisi.

## Soal 7 — Worker Laravel (Elendil, Isildur, Anarion)
- Install PHP 8.4 + extensions, Nginx, Git, Composer.
- Clone `laravel-simple-rest-api`, `composer install`, `cp .env.example .env`, `php artisan key:generate`.
- Nginx per node: listen 8001/8002/8003, fastcgi ke php8.4-fpm; enable site; restart.

### Validasi
- `curl http://<host>:8001` (Elendil), `:8002` (Isildur), `:8003` (Anarion) harus menampilkan halaman Laravel.
- `systemctl status php8.4-fpm nginx` atau `service ... status` semua aktif.

## Soal 8 — MariaDB (Palantir) + Koneksi dari Worker + Migrasi/Seed
- Palantir: install MariaDB, buat DB `db_k44` dan user `k44_user`@`%`, izinkan koneksi eksternal (bind-address global), restart.
- Worker: update `.env` (DB_HOST 192.233.4.3, DB_DATABASE/USERNAME/PASSWORD).
- Jalankan `php artisan migrate:fresh` dan `php artisan db:seed --class=AiringsTableSeeder`.

### Validasi
- Dari worker: `mysql -h 192.233.4.3 -uk44_user -ppasswordk44 -e "SHOW DATABASES;"`.
- `curl http://elendil.k44.com:8001/api/airing` (juga Isildur/Anarion) harus mengembalikan data.

## Soal 9 — Validasi Aplikasi & API dari Klien
- Miriel: install `lynx` dan `curl`; set DNS ke Erendis & Amdir.
- Uji halaman utama tiga worker via `lynx`, dan endpoint API `/api/airing` via `curl`.

### Validasi
- `lynx -dump http://elendil.k44.com:8001` (dan dua lainnya) menampilkan halaman.
- `curl http://isildur.k44.com:8002/api/airing` mengembalikan JSON/daftar airing.

## Soal 10 — Reverse Proxy Elros (Round Robin)
- Elros: Nginx reverse proxy ke tiga worker (upstream `kesatria_numenor`), default round-robin.
- Perbaikan Elendil jika 500: `composer update`, `php artisan key:generate`, perbaikan izin, restart.

### Validasi
- `curl -I http://elros.k44.com/` beberapa kali: backend berbeda (cek log di worker `access.log`).
- `ab -n 100 -c 10 http://elros.k44.com/api/airing/` sukses tanpa error.

## Soal 11 — Benchmark & Weighted Load Balancing di Elros
- Miriel: install `apache2-utils` (ab) dan `htop` (worker juga pasang `htop`).
- Tes 1: `ab -n 100 -c 10` ke Elros.
- Ubah upstream weight (Elendil=3, Isildur=2, Anarion=1), restart.
- Tes 2/3: `ab -n 2000 -c 100` sebelum/sesudah weight dan bandingkan failed requests.

### Validasi
- Amati distribusi load via `htop` pada masing-masing worker.
- Bandingkan hasil `Failed requests` antara Tes 2 dan 3.

## Soal 12 — Web Sederhana Lorien (Galadriel, Celeborn, Oropher)
- Install Nginx + PHP 8.4-FPM, deploy `index.php` menampilkan hostname, start services.

### Validasi
- `curl http://galadriel.k44.com:8004` menampilkan `Hostname: ...` (lakukan juga untuk 8005/8006).

## Soal 13 — Basic Auth pada Server Lorien
- Siapkan `.htpasswd` (user `noldor`, pass `silvan`).
- Tambahkan `auth_basic` dan `auth_basic_user_file` pada server block 8004/8005/8006.

### Validasi
- Tanpa kredensial: `curl -I http://galadriel.k44.com:8004` → 401 Unauthorized.
- Dengan kredensial: `curl -u noldor:silvan http://galadriel.k44.com:8004` → 200 OK.

## Soal 14 — (Redundan) Basic Auth — Konsistensi
- Replikasi konfigurasi Basic Auth untuk semua node Lorien (jika belum).

### Validasi
- Ulangi uji pada Soal 13 untuk ketiga node.

## Soal 15 — Forwarding IP Klien ke PHP (X-Real-IP)
- Tambah `map $http_x_real_ip $real_ip_or_remote` dan set `fastcgi_param HTTP_X_REAL_IP $remote_addr`.
- `index.php` menampilkan `Hostname` dan `IP Address` dari `$_SERVER['HTTP_X_REAL_IP']`.

### Validasi
- `curl http://galadriel.k44.com:8004` menampilkan `IP Address:` sesuai IP klien.
- Uji dengan header kustom: `curl -H "X-Real-IP: 1.2.3.4" http://galadriel.k44.com:8004` dan cek output.

## Soal 16 — Reverse Proxy Pharazon (Lorien)
- Pharazon: Nginx upstream `Kesatria_Lorien` ke galadriel:8004, celeborn:8005, oropher:8006; forward headers dan Authorization.

### Validasi
- `curl -I http://pharazon.k44.com/` dan beberapa kali untuk memastikan load balancing.
- Uji endpoint PHP: `curl http://pharazon.k44.com/` dan cek response dari salah satu node Lorien.

## Soal 17 — Benchmark Pharazon + Simulasi Node Down
- Miriel: `ab -n 1000 -c 100 -A noldor:silvan http://pharazon.k44.com`.
- Stop Nginx di Galadriel: `service nginx stop` untuk simulasi failover.

### Validasi
- Jalankan `ab` saat salah satu backend down; request tetap berhasil (LB melanjutkan ke node sehat).
- Periksa log error Pharazon untuk upstream yang gagal.

## Soal 18 — Replikasi MariaDB (Palantir → Narvi)
- Palantir: siapkan binlog (komentar petunjuk), buat user repl `palantir`, `FLUSH TABLES WITH READ LOCK; SHOW MASTER STATUS;`.
- Narvi: `CHANGE MASTER TO` menunjuk Palantir, `START SLAVE;` lalu `SHOW SLAVE STATUS\G`.
- Uji: buat DB/tabel/data di Palantir, cek muncul di Narvi.

### Validasi
- Di Narvi: `SHOW SLAVE STATUS\G` → `Seconds_Behind_Master` tidak null, `Slave_IO_Running: Yes`, `Slave_SQL_Running: Yes`.
- Data uji ada di Narvi setelah dibuat di Palantir.

## Soal 19 — Rate Limiting (Nginx)
- Tambah `limit_req_zone $binary_remote_addr zone=limit_zone:10m rate=10r/s;` pada level http.
- Pada `location /`: `limit_req zone=limit_zone burst=20 nodelay;`.

### Validasi
- `ab -n 100 -c 50 http://pharazon.k44.com/` dan `http://elros.k44.com/api/airing/`.
- Amati `429 Too Many Requests` jika melebihi rate, serta log access menunjukkan `limiting requests`.

## Soal 20 — Caching + Rate Limiting (Pharazon)
- Pharazon: definisi `proxy_cache_path`, `proxy_cache_key`, `limit_req_zone`, upstream via DNS ke Lorien.
- Pada server: aktifkan cache, `proxy_cache_valid`, tambahkan header `X-Cache-Status`, rate limit pada `location /`.

### Validasi
- Lakukan dua kali request yang sama: pertama `X-Cache-Status: MISS`, berikutnya `HIT`.
  - `curl -I http://pharazon.k44.com/ | grep -i X-Cache-Status`
- Tekan dengan beban: pastikan rate limiting bekerja (lihat respons 429 saat dilampaui).

