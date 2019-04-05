#!/bin/bash

OPENVPN_PATH="/etc/openvpn"
OPENSSL_CFG_PATH=$OPENVPN_PATH
apt update && apt -y install openvpn

cp client.sh $OPENVPN_PATH && cp revoke.sh $OPENVPN_PATH && cp env $OPENVPN_PATH
cp openssl.cnf $OPENVPN_PATH/

cd $OPENVPN_PATH
mkdir ccd
mkdir certs
mkdir crl
mkdir keys
mkdir private
mkdir req
chmod 700 keys private
echo "01" > serial
touch index.txt
ln -s $OPENVPN_PATH/index.txt $OPENVPN_PATH/index.txt.attr

openssl req -config $OPENSSL_CFG_PATH/openssl.cnf -new -nodes -x509 -keyout private/CA_key.pem -out CA_cert.pem -days 3650
openssl req -config $OPENSSL_CFG_PATH/openssl.cnf -new -nodes -keyout keys/server.pem -out req/server.pem
openssl ca -batch -config $OPENSSL_CFG_PATH/openssl.cnf -extensions server -out certs/server.pem -infiles req/server.pem
openssl dhparam -out dh2048.pem 2048
openssl ca -config $OPENSSL_CFG_PATH/openssl.cnf -gencrl -out crl/crl.pem
openvpn --genkey --secret ta.key

