check_envs()
{
  if [ "X${TLS_DOMAIN}" == "X" ]; then
    echo "need TLS_DOMAIN"
    exit 1
  fi

  if [ "X${TLS_ACCOUNT}" == "X" ]; then
    echo "need TLS_ACCOUNT"
    exit 1
  fi
}

configure_postfix_tls()
{
  domain=${TLS_DOMAIN}

  if [[ -z "$(find /etc/postfix/certs -iname *.key)" ]]; then
      return
  fi

  # tls
  postconf -e "smtpd_use_tls = yes"
  postconf -e "smtpd_tls_auth_only = yes"
  postconf -e "smtpd_tls_key_file = /etc/postfix/certs/${domain}.key"
  postconf -e "smtpd_tls_cert_file = /etc/postfix/certs/${domain}.crt"
  postconf -e "smtpd_tls_CAfile = /etc/postfix/certs/cacert.pem"
  postconf -e "tls_random_source = dev:/dev/urandom"

  cat > /etc/postfix/sasl/smtpd.conf <<EOF
sasl_pwcheck_method: auxprop
auxprop_plugin: sasldb
mech_list: PLAIN LOGIN CRAM-MD5 DIGEST-MD5 NTLM
log_level: 7
EOF

  cat >> /etc/postfix/master.cf <<EOF
submission inet n       -       n       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=may
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_reject_unlisted_recipient=no
  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING
EOF
}

create_accounts()
{
    domain=${TLS_DOMAIN}

    ACCOUNTS_NO_WHITESPACE="$(echo -e "${TLS_ACCOUNT}" | tr -d '[[:space:]]')"
    backend=$(echo $ACCOUNTS_NO_WHITESPACE | tr ";" "\n")
    for x in $backend; do
        username=$(echo $x | cut -d ':' -f 1)
        password=$(echo $x | cut -d ':' -f 2)
        addr="${username}@${domain}"

        echo "创建用户 (如果用户己存在,等同于重置其密码) : ${addr}"
        echo $password | saslpasswd2 -p -c -u $domain $username

        # TODO:
        echo "${addr} ${MAILGUN_USERNAME}" >> /etc/postfix/generic
    done


    chown postfix.sasl /etc/sasldb2

    echo "检查用户是否创建"
    sasldblistusers2

    echo "设置文件(/etc/sasldb2)权限"
    chmod 400 /etc/sasldb2
    chown postfix /etc/sasldb2
}

check_envs
configure_postfix_tls
create_accounts
