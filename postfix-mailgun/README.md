# 搭建 Postfix 通过 Mailgun

直接 mailgun smtp 比较慢的情况下，我们可以本地搭建 postfix ， 通过 mailgun 转发邮件。


## 参考

- [How to Set Up a Mail Relay with Postfix and Mailgun on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-mail-relay-with-postfix-and-mailgun-on-ubuntu-16-04)


## 使用方式


### 无验证

无需验证，本地网络通过 mailgun 转发邮件

```yaml
version: '3'
services:
    postfix:
        image: ooclab/postfix-mailgun
        ports:
            - "25:25"
        environment:
            FROM: admin@ooclab.com
            MAILGUN_USERNAME: Your Mailgun SMTP Username
            MAILGUN_PASSWORD: Your Mailgun SMTP Password
```


### 使用 TLS 验证

```yaml
version: '3'
services:
    postfix:
        image: ooclab/postfix-mailgun
        ports:
            - "587:587"
        environment:
            TLS_DOMAIN: cn1.mail.ooclab.com
            TLS_ACCOUNT: notice1:abc111;    notice2:abc222;  notice3:abc333
            MAILGUN_USERNAME: Your Mailgun SMTP Username
            MAILGUN_PASSWORD: Your Mailgun SMTP Password
        volumes:
            - "./certs:/etc/postfix/certs"
```

#### 注意

1. 第一次运行需要创建 certs :

    ```
    docker-compose run postfix /opt/bin/build_tls_keys.sh
    ```

2. TLS_ACCOUNT 支持批量创建账户（格式： `用户1:密码1;用户2:密码2;用户3:密码3`
