#!/usr/local/bin/expect -f
#spawn openssl genrsa -des3 -out ca.key 1024
spawn gmssl ecparam -genkey -name sm2p256v1 -out pri.key
spawn gmssl pkcs8 -topk8 -inform PEM -in pri.key -nocrypt -out ca.key
spawn gmssl req -x509 -sm3 -days 365 -key pri.key -out ca.crt -config ca.cnf -extensions v3_req
send "\r"
send "\r"
send "\r"
send "\r"
send "\r"
interact