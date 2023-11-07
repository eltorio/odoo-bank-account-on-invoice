#!/bin/bash
BACKUP_FILE=/test_base.zip
mkdir -p /opt/bitnami/odoo/data/filestore
mkdir -p /tmp/restore
cat << EOF | PGPASSWORD=$ODOO_DATABASE_PASSWORD psql -h $ODOO_DATABASE_HOST -U $ODOO_DATABASE_USER -d postgres -f -
drop database bitnami_odoo;
create database bitnami_odoo;
EOF
cd /tmp/restore
unzip $BACKUP_FILE
PGPASSWORD=$ODOO_DATABASE_PASSWORD psql -h $ODOO_DATABASE_HOST -U $ODOO_DATABASE_USER -d $ODOO_DATABASE_NAME -f /tmp/restore/dump.sql
rm -rf /opt/bitnami/odoo/data/filestore/$ODOO_DATABASE_NAME
mv filestore /opt/bitnami/odoo/data/filestore/$ODOO_DATABASE_NAME
cd /
rm -rf /tmp/restore