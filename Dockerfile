ARG MODULE_NAME
FROM highcanfly/odoo-bitnami-custom:latest
RUN mkdir -p /dev-addons
COPY odoo.conf.tpl /opt/bitnami/scripts/odoo/bitnami-templates/odoo.conf.tpl

