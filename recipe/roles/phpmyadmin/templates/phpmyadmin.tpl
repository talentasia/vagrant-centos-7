Listen 9000
NameVirtualHost *:9000

<VirtualHost *:9000>
    DocumentRoot /var/www/phpmyadmin
    <Directory /var/www/phpmyadmin>
        # enable the .htaccess rewrites
        AllowOverride All
        Options All
        Require all granted
    </Directory>
</VirtualHost>
