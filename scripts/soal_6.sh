# ==== ALDARION: Pengaturan durasi sewa DHCP (lease time) ====

cat <<EOF > /etc/dhcp/dhcpd.conf
# Jadikan server ini authoritative DHCP
authoritative;

# Opsi global: DNS klien diarahkan ke Erendis dan Amdir
option domain-name-servers 192.233.3.2, 192.233.3.3;

# Subnet untuk segmen Manusia
subnet 192.233.1.0 netmask 255.255.255.0 {
  range 192.233.1.6 192.233.1.34;
  range 192.233.1.68 192.233.1.94;
  option routers 192.233.1.1;
  option broadcast-address 192.233.1.255;
  default-lease-time 1800; # <-- 30 menit
  max-lease-time 3600;     # <-- 60 menit
}

# Subnet untuk segmen Peri
subnet 192.233.2.0 netmask 255.255.255.0 {
  range 192.233.2.35 192.233.2.67;
  range 192.233.2.96 192.233.2.121;
  option routers 192.233.2.1;
  option broadcast-address 192.233.2.255;
  default-lease-time 600;  # <-- 10 menit
  max-lease-time 3600;     # <-- 60 menit
}

# Subnet untuk Khamul
subnet 192.233.3.0 netmask 255.255.255.0 {
  option routers 192.233.3.1;
  option broadcast-address 192.233.3.255;
}

# Subnet lokal Aldarion
subnet 192.233.4.0 netmask 255.255.255.0 {
}

# Alamat tetap (fixed) untuk Khamul
host Khamul {
  hardware ethernet 02:42:e8:63:34:00;
  fixed-address 192.233.3.95;
}
EOF

# Muat ulang layanan DHCP untuk menerapkan perubahan
service isc-dhcp-server restart