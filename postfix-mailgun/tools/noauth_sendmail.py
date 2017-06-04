#!/usr/bin/env python

import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.Utils import formatdate
from email.utils import make_msgid

msg = MIMEMultipart()

FROM_ADDR = "admin@ooclab.com"
TO_ADDR = "lijian@ooclab.com"


msg['From'] = FROM_ADDR
msg['To'] = TO_ADDR
msg['Subject'] = 'simple email in python with mailgun'
msg["Date"] = formatdate(localtime=True)
msg['Message-ID'] = make_msgid()

message = 'here is the email'
msg.attach(MIMEText(message))

mailserver = smtplib.SMTP('127.0.0.1', 25)
mailserver.ehlo()
mailserver.sendmail(FROM_ADDR, TO_ADDR, msg.as_string())
mailserver.quit()
