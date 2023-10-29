FROM highcanfly/odoo-bitnami-custom:latest
ARG MODULE_NAME=iban_on_invoice_module
COPY --chmod=0755 remove-preinstalled.sh /remove-preinstalled.sh
RUN chmod +x /remove-preinstalled.sh \
    && /remove-preinstalled.sh $MODULE_NAME
RUN mkdir -p /dev-addons
COPY iban_on_invoice_module /dev-addons/iban_on_invoice_module
RUN chmod -R ugo+rw /dev-addons
COPY odoo.conf.tpl /opt/bitnami/scripts/odoo/bitnami-templates/odoo.conf.tpl

