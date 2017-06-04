#!/usr/bin/env python3

# Import smtplib for the actual sending function
import smtplib

# Import the email modules we'll need
from email.mime.text import MIMEText

msg = MIMEText('A mail from mailgun')
msg['Subject'] = 'mailgun relay'
msg['From'] = "admin@ooclab.com"
msg['To'] = "lijian.gnu@gmail.com"

# Send the message via our own SMTP server.
s = smtplib.SMTP('localhost')
s.send_message(msg)
s.quit()
