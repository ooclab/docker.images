#! /bin/bash

check_envs()
{
  if [ "X${MAILGUN_USERNAME}" == "X" ]; then
    echo "need MAILGUN_USERNAME"
    exit 1
  fi

  if [ "X${MAILGUN_PASSWORD}" == "X" ]; then
    echo "need MAILGUN_PASSWORD"
    exit 1
  fi
}

setup_sasl_password ()
{
    cat > /etc/postfix/sasl_passwd <<EOF
smtp.mailgun.org ${MAILGUN_USERNAME}:${MAILGUN_PASSWORD}
EOF
    chmod 600 /etc/postfix/sasl_passwd
    postmap /etc/postfix/sasl_passwd
}

configure_relay()
{
    postconf -e "relayhost = smtp.mailgun.org:587"
    postconf -e "smtp_sasl_auth_enable = yes"
    postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd"
    postconf -e "smtp_sasl_security_options = noanonymous"
    postconf -e "smtp_sasl_tls_security_options = noanonymous"
    postconf -e "smtp_sasl_mechanism_filter = AUTH LOGIN"
    postconf -e "smtp_generic_maps = hash:/etc/postfix/generic"
}

configure_common()
{
    postconf -e "compatibility_level = 2"
}

bug_fix()
{
    # 如果 postfix 不能写日志, 可能是权限问题
    touch /var/log/mail.log
    chown syslog.adm /var/log/mail.log
}

check_envs
setup_sasl_password
configure_relay
configure_common

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ "X${TLS_ACCOUNT}" == "X" ]; then
    source ${DIR}/setup_noauth.sh
else
    source ${DIR}/setup_tls.sh
fi

# TODO:
postmap /etc/postfix/generic

service rsyslog start
service postfix start

# 等待 log 文件生成
bug_fix
while [ ! -f /var/log/mail.log ]; do
    sleep 1
done
tail -f /var/log/mail.log
