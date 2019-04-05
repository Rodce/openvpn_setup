#!/bin/sh

source env
OPENVPN_PATH=/etc/openvpn
OPENSSL_CFG_PATH=/etc/openvpn

Client="$1"
if [ ! -n "$Client"  ]
then
    echo "Can't create for empty name."
    exit 1
fi
cd $OPENVPN_PATH
openssl req -new -nodes -keyout keys/k$Client.pem -out req/r$Client.pem
openssl ca -batch -config $OPENSSL_CFG_PATH/openssl.cnf -out certs/c$Client.pem -infiles req/r$Client.pem
cd $OPENVPN_PATH/users
mkdir $Client
mkdir $Client/Config
mkdir $Client/Config/$Client
cd $OPENVPN_PATH
cp certs/c$Client.pem users/$Client/Config/$Client
cp keys/k$Client.pem users/$Client/Config/$Client
cp CA_cert.pem users/$Client/Config/$Client
cp ta.key users/$Client/Config/$Client

echo "Done generate files for "$Client"."
exit 0

