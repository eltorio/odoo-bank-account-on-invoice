# -*- coding: utf-8 -*-
# Copyright 2019 Openworx
# License LGPL-3.0 or later (http://www.gnu.org/licenses/lgpl.html).

import qrcode
import base64
from io import BytesIO
from odoo import models, fields, api
from odoo.http import request
from odoo import exceptions, _

class QRCodeInvoice(models.Model):
    _inherit = 'account.move'

    qr_image = fields.Binary("QR Code", compute='_generate_qr_code')
    iban = fields.Text("IBAN", compute='_get_iban')
    bic = fields.Text("BIC", compute='_get_bic')
    
#    @api.one
    def _generate_qr_code(self):
        iban_invoice = self.partner_bank_id.acc_number and self.partner_bank_id.acc_number.replace(' ','') or ''
        bic_invoice = self.partner_bank_id.bank_bic and self.partner_bank_id.bank_bic or ''
        iban =  self.company_id.iban_qr_number and self.company_id.iban_qr_number.acc_number.replace(' ','') or ''
        bic =  self.company_id.iban_qr_number and self.company_id.iban_qr_number.bank_id.bic or ''
        if len(iban_invoice) > 0:
            iban = iban_invoice
            bic = bic_invoice
        company = self.company_id.name
        service = 'BCD'
		#Check if BIC exists: version 001 = BIC, 002 = no BIC
        if len(bic) > 0:
            version = '001'
        else:
            version = '002'
        code    = '1'
        function = 'SCT'
        currency = ''.join([self.currency_id.name, str(self.amount_residual)])
        reference = self.name
        lf ='\n'
        ibanqr = lf.join([service,version,code,function,bic,company,iban,currency,'','',reference])
        if len(ibanqr) > 331:
            raise exceptions.except_orm (_('Error'), _('IBAN QR code "%s" length %s exceeds 331 bytes') % (ibanqr, len(ibanqr)))
        self.qr_image = generate_qr_code(ibanqr)

    def _get_iban(self):
        iban_invoice = self.partner_bank_id.acc_number and self.partner_bank_id.acc_number or ''
        iban =  self.company_id.iban_qr_number and self.company_id.iban_qr_number.acc_number or ''
        if len(iban_invoice) > 0:
            self.iban = iban_invoice
        else:
            self.iban = iban

    def _get_bic(self):
        iban_invoice = self.partner_bank_id.acc_number and self.partner_bank_id.acc_number or ''
        bic_invoice = self.partner_bank_id.bank_bic and self.partner_bank_id.bank_bic or ''
        bic =  self.company_id.iban_qr_number and self.company_id.iban_qr_number.bank_id.bic or ''
        if len(iban_invoice) > 0:
            self.bic = bic_invoice
        else:
            self.bic = bic

def generate_qr_code(value):
    qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=20,
            border=4,
    )
    qr.add_data(value)
    qr.make(fit=True)
    img = qr.make_image()
    temp = BytesIO()
    img.save(temp, format="PNG")
    qr_img = base64.b64encode(temp.getvalue())
    return qr_img
