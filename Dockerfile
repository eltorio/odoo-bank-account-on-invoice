ARG MODULE_NAME
FROM highcanfly/odoo-bitnami-custom:16.0.0.8
RUN mkdir -p /dev-addons
COPY iban_on_invoice_module /dev-addons/iban_on_invoice_module
RUN chmod -R ugo+rw /dev-addons
COPY odoo.conf.tpl /opt/bitnami/scripts/odoo/bitnami-templates/odoo.conf.tpl

