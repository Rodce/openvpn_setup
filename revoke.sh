#!/bin/sh

source env

user="$1"
cd $OPENVPN_PATH
openssl ca -keyfile private/CA_key.pem -cert CA_cert.pem -revoke certs/c$user.pem
openssl ca -keyfile private/CA_key.pem -cert CA_cert.pem -gencrl -out crl/crl.pem

