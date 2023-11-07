FROM highcanfly/odoo-bitnami-custom:latest
ARG MODULE_NAME=iban_on_invoice_module
COPY --chmod=0755 prepare-dev.sh /prepare-dev.sh
COPY --chmod=0755 run.sh /opt/bitnami/scripts/odoo/run.sh
RUN chmod +x /prepare-dev.sh \
    && chmod +x /opt/bitnami/scripts/odoo/run.sh \
    && /prepare-dev.sh $MODULE_NAME
RUN mkdir -p /dev-addons
COPY iban_on_invoice_module /dev-addons/iban_on_invoice_module
RUN chmod -R ugo+rw /dev-addons
COPY odoo.conf.tpl /opt/bitnami/scripts/odoo/bitnami-templates/odoo.conf.tpl
RUN /opt/bitnami/odoo/venv/bin/pip3 install install debugpy
RUN apt update && apt install -y unzip 
COPY --chmod=0755 restore_database.sh /restore_database.sh
COPY test_base.zip /test_base.zip
COPY restore_database.sh /restore_database.sh
RUN chmod +x /restore_database.sh
