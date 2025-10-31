# Node Amandil - Cek Lease Time DHCP


# Lepas lease lama 
dhclient -r eth0
# minta lease baru
dhclient -v eth0

# Tampilkan informasi lease yang diterima
cat /var/lib/dhcp/dhclient.leases | grep lease-time
cat /var/lib/dhcp/dhclient.leases | grep "renew\|rebind\|expire"

# Konfigurasi server (manusia)
# default-lease-time: 1800 detik → 30 menit
# max-lease-time: 3600 detik → 1 jam
# renew: 900 detik (½ dari 1800 → 15 menit)
# rebind: 1575 detik (7/8 dari 1800 → ±26 menit)
# expire: 3600 detik → 1 jam

# Node Gilgalad  – Cek Lease Time DHCP
# Lepas lease lama 
dhclient -r eth0
# minta lease baru
dhclient -v eth0

# Tampilkan informasi lease yang diterima
cat /var/lib/dhcp/dhclient.leases | grep lease-time
cat /var/lib/dhcp/dhclient.leases | grep "renew\|rebind\|expire"

# Konfigurasi server (peri)
# default-lease-time: 600 detik → 10 menit
# max-lease-time: 3600 detik → 1 jam
# renew: 300 detik (½ dari 600 → 5 menit)
# rebind: 525 detik (7/8 dari 600 → ±8,75 menit)
# expire: 3600 detik → 1 jam

