import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.Utils import formatdate
from email.utils import  make_msgid

msg = MIMEMultipart()

TO_ADDR = "lijian.gnu@gmail.com"
login_username = "notice3@cn1.mail.ooclab.com"
login_password = "abc333"


msg['From'] = login_username
msg['To'] = TO_ADDR
msg['Subject'] = 'simple email in python'
msg["Date"] = formatdate(localtime=True)
msg['Message-ID'] = make_msgid()

message = 'here is the email'
msg.attach(MIMEText(message))

mailserver = smtplib.SMTP('127.0.0.1', 587)
# identify ourselves to smtp gmail client
mailserver.ehlo()
# secure our email with tls encryption
mailserver.starttls()
# re-identify ourselves as an encrypted connection
mailserver.ehlo()
mailserver.login(login_username, login_password)

mailserver.sendmail(login_username, TO_ADDR, msg.as_string())

mailserver.quit()
