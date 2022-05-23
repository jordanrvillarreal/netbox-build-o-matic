#!/usr/bin/env bash

netboxVERSION=`curl -s https://api.github.com/repos/netbox-community/netbox/releases/latest | grep "tag_name" | cut -d : -f 2,3 | tr -d \" | tr -d \,`

tarballURL="https://github.com/netbox-community/netbox/archive/refs/tags/$(echo $netboxVERSION | sed "s/ //g").tar.gz"

wget $tarballURL

CURDIR=`pwd`

apt install postgresql libpq-dev redis-server nginx -y

sudo -u postgres psql < ${CURDIR}/postgres.conf

apt install python3 python3-pip python3-venv python3-dev build-essential libxml2-dev libxslt1-dev libffi-dev libpq-dev libssl-dev zlib1g-dev -y

apt install redis-server -y

pip3 install --upgrade pip

tar -xzf $netboxVERSION.tar.gz -C /opt

netboxNoVERSION=$(echo $netboxVERSION | sed "s/v//g")

ln -s /opt/netbox-$netboxNoVERSION/ /opt/netbox

adduser --system --group netbox
chown --recursive netbox /opt/netbox/netbox/media/

cp /opt/netbox/netbox/netbox/configuration_example.py /opt/netbox/netbox/netbox/configuration.py

PRIVATE_KEY=`python3 /opt/netbox/netbox/generate_secret_key.py`

sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \['*'\]/" /opt/netbox/netbox/netbox/configuration.py
sed -i "s/'USER': '',/'USER': 'netbox',/" /opt/netbox/netbox/netbox/configuration.py
sed -i "s/'PASSWORD': '',           # PostgreSQL password/'PASSWORD': 'verygoodpassword',/" /opt/netbox/netbox/netbox/configuration.py
sed -i "s/SECRET_KEY = ''/SECRET_KEY = '${PRIVATE_KEY}'/" /opt/netbox/netbox/netbox/configuration.py

/opt/netbox/upgrade.sh

source /opt/netbox/venv/bin/activate

python3 /opt/netbox/netbox/manage.py createsuperuser --username admin --email admin@localhost

deactivate

cp /opt/netbox/contrib/gunicorn.py /opt/netbox/gunicorn.py
cp /opt/netbox/contrib/*.service /etc/systemd/system/

systemctl daemon-reload
systemctl start netbox netbox-rq
systemctl enable netbox netbox-rq

openssl req -config ${CURDIR}/netbox-cert.conf \
-new -sha256 -newkey rsa:2048 -nodes -keyout /etc/ssl/private/netbox.key \
-x509 -days 825 -out /etc/ssl/certs/netbox.crt

cp /opt/netbox/contrib/nginx.conf /etc/nginx/sites-available/netbox

cd /etc/nginx/sites-enabled/
rm default
ln -s /etc/nginx/sites-available/netbox

service nginx restart

