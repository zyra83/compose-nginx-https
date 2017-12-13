#!/bin/bash
# 
# Sources :
# https://serverfault.com/questions/845806/how-to-issue-ssl-certificate-with-san-extension
# https://gist.github.com/bradmontgomery/6487319
# https://www.digicert.com/csr-ssl-installation/nginx-openssl.htm
# 

# génération des DH au besoin
openssl dhparam -out dhparam.pem 2048
# clé privée du CA
openssl genrsa -out "ca.key" 2048
chmod 400 "ca.key"
# autosignature du CA
openssl req -new -x509 -days 3650 -key "ca.key" -out "ca.crt" -subj "/C=FR/ST=Landes/L=Geloux/O=Flash Corp./OU=IT Department/CN=Flash Corp. Certification Autority"
# clé privée du serveur
openssl genrsa -out "dev.mika.key" 2048
chmod 400 "dev.mika.key"
# Demande de signature (csr) version non-interactive
openssl req -new -key "dev.mika.key" -out "dev.mika.csr" -config ma_config_openssl.cnf
# signature du CSR par le CA (et rappel de config, bug openssl ? )
openssl x509 -req -in "dev.mika.csr" -out "dev.mika.crt" -CA "ca.crt" -CAkey "ca.key" -CAcreateserial -days 365 -extensions v3_req -extfile ma_config_openssl.cnf 
