#!/bin/bash
VERSION=$(find /opt/bitnami/odoo/lib/ -name "*addons" | sed -ne 's/.*\/lib\/\(.*\)\.egg.*addons$/\1/p' | head -n1)
rm -rf "/opt/bitnami/odoo/lib/$VERSION.egg/odoo/addons/$1"
