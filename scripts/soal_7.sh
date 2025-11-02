# Node Elendil, Isildur, Anarion
# masing masing Laravel Workers
git config --global --add safe.directory /var/www/laravel-simple-rest-api
apt update && apt install -y php8.2 php8.2-cli php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip php8.2-mysql
update-alternatives --set php /usr/bin/php8.2
cd /var/www/laravel-simple-rest-api
composer install
cp .env.example .env  # jika perlu
php artisan key:generate
php artisan --version

#Jalankan ini untuk donwload kebutuhan ketiga node tersebut
apt-get update && apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
curl -sSL https://packages.sury.org/php/README.txt | bash -x

#dan download melalui script ini 
apt-get install -y php8.4 php8.4-fpm php8.4-mysql php8.4-mbstring php8.4-xml php8.4-curl php8.4-zip unzip nginx git
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#jalankan script ini dimana kita nge clone github laravelnya
cd /var/www
git clone https://github.com/elshiraphine/laravel-simple-rest-api.git
cd laravel-simple-rest-api

composer install
composer update

cp .env.example .env

php artisan key:generate


# validasi di ketiga node tersebut
ls -la /var/www/laravel-simple-rest-api/
cat /var/www/laravel-simple-rest-api/.env

ls /var/www/laravel-simple-rest-api/vendor/

# validasi artisan
cd /var/www/laravel-simple-rest-api
php artisan --version



git config --global --add safe.directory /var/www/laravel-simple-rest-api
apt update && apt install -y php8.2 php8.2-cli php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip php8.2-mysql
update-alternatives --set php /usr/bin/php8.2
cd /var/www/laravel-simple-rest-api
composer install
cp .env.example .env  # jika perlu
php artisan key:generate
php artisan --version





