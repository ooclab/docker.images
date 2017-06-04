check_envs()
{
  if [ "X${FROM}" == "X" ]; then
    echo "need FROM"
    exit 1
  fi
}

get_networks()
{
    # ugly
    mynetworks=$(ip a |grep inet | awk '{print $2}' | tr '\n' ' ')
    echo $mynetworks | sed -e 's@\.[^\.]*/24@\.0/24@g' -e 's@\.[^\.]*\.[^\.]*/16@\.0\.0/16@g' -e 's@\.[^\.]*\.[^\.]*\.[^\.]*/8@\.0\.0\.0/8@g'

}

check_envs

# 允许本地局域网发送邮件（docker私有网)
postconf -e "mynetworks = $(get_networks)"

cat > /etc/postfix/generic <<EOF
${FROM} ${MAILGUN_USERNAME}
EOF
