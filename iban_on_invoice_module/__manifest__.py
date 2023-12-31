# -*- coding: utf-8 -*-
# Copyright 2019, 2021 Openworx
# License LGPL-3.0 or later (http://www.gnu.org/licenses/lgpl.html).

{
    'name': 'IBAN QR Code on Invoice',
    'summary': 'Add IBAN QR Code on Invoice for scanning in mobile banking apps',
    'version': '0.12',
    'author': 'SCTG',
    'website': "https:/sctg.eu.org",
    'category': 'Accounting',
    'depends': ['account','base_iban','accounting_pdf_reports'],
    'data': [
        'views/invoice_iban_qr.xml',
        'views/res_company_view.xml',
        'security/ir.model.access.csv',
    ],
    'license': 'LGPL-3',
    'images': ['images/ibanqr.png'],
}
