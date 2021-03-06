#!/bin/bash

sudo apt-get -y install language-pack-es-base 
sudo apt-get -y install postgresql-9.1 libpq-dev postgresql-9.1-postgis gdal-bin
sudo apt-get -y install git python-pip python-dev
sudo apt-get -y install libxml2-dev libxslt1-dev
sudo -u postgres psql -c "CREATE ROLE dev LOGIN PASSWORD 'dev' SUPERUSER VALID UNTIL 'infinity';"
sudo -u postgres createdb template_postgis
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis_comments.sql
sudo -u postgres psql -c "CREATE DATABASE preciosa WITH ENCODING='UTF8' OWNER=dev TEMPLATE=template_postgis LC_COLLATE='en_US.UTF-8' LC_CTYPE='en_US.UTF-8' CONNECTION LIMIT=-1;"

ln -s /vagrant/ /home/vagrant/preciosa
cd preciosa
sudo pip install -r requirements.txt 
cp preciosa/local_settings.py.template preciosa/local_settings.py
python manage.py syncdb --noinput
python manage.py createsuperuser --username=preciosa --email=preciosa@god.com --noinput
python manage.py migrate
sudo python manage.py cities_light
python manage.py loaddata fixtures/flatpages.json fixtures/blog.json fixtures/newsletter.json fixtures/ciudades.json fixtures/sucursales.json fixtures/categorias.json fixtures/marcas.json fixtures/productos.json fixtures/precios.json
