#!/bin/sh

# Compile aliases database to prevent startup warnings
newaliases

# Configure Postfix with environment variables
postconf -e "relayhost = [smtp.gmail.com]:587"
postconf -e "mynetworks = 127.0.0.0/8, ${MYNETWORKS}"
postconf -e "smtp_sasl_auth_enable = yes"

# Use lmdb instead of hash (Alpine default database format)
postconf -e "smtp_sasl_password_maps = lmdb:/etc/postfix/sasl_passwd"
postconf -e "smtp_sasl_security_options = noanonymous"
postconf -e "smtp_tls_security_level = encrypt"
postconf -e "smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt"

# Set up SASL credentials using lmdb format explicitly
echo "[smtp.gmail.com]:587 ${SMTP_USERNAME}:${SMTP_PASSWORD}" > /etc/postfix/sasl_passwd
postmap lmdb:/etc/postfix/sasl_passwd
chmod 0600 /etc/postfix/sasl_passwd*

# Configure canonical mapping to rewrite all recipients to TARGET_EMAIL
echo "/.+/ ${TARGET_EMAIL}" > /etc/postfix/recipient_canonical
postconf -e "recipient_canonical_classes = envelope_recipient, header_recipient"
postconf -e "recipient_canonical_maps = regexp:/etc/postfix/recipient_canonical"

# Redirect Postfix logs to stdout for Docker/k3s log aggregation
postconf -e "maillog_file = /dev/stdout"

# Start Postfix in the foreground
exec postfix start-fg

