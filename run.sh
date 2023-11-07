#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Odoo environment
. /opt/bitnami/scripts/odoo-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libodoo.sh

# declare cmd="${ODOO_BASE_DIR}/bin/odoo"
# declare cmd="${ODOO_BASE_DIR}/venv/bin/python"
# declare -a args=("--config" "$ODOO_CONF_FILE" "$@")

info "** Starting Odoo **"
while true; do
    if am_i_root; then
        exec_as_user "$ODOO_DAEMON_USER" /opt/bitnami/odoo/venv/bin/python3 -m debugpy --listen 0.0.0.0:5678 /opt/bitnami/odoo/bin/odoo server --config /opt/bitnami/odoo/conf/odoo.conf --dev=all
    else
        exec /opt/bitnami/odoo/venv/bin/python3 -m debugpy --listen 0.0.0.0:5678 /opt/bitnami/odoo/bin/odoo server --config /opt/bitnami/odoo/conf/odoo.conf --dev=all
    fi
    echo "*************************************"
    sleep 4
    echo RESTARTING
done
