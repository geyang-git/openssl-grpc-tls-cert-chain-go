#!/usr/local/bin/expect -f
#spawn openssl genrsa -des3 -out ca.key 1024
spawn openssl ecparam -genkey -name SM2 -out pri.key
spawn openssl pkcs8 -topk8 -inform PEM -in pri.key -nocrypt -out ca.key
spawn openssl req -new -x509 -days 365 -key ca.key -out ca.crt -config ca.cnf -extensions v3_req
send "\r"
send "\r"
send "\r"
send "\r"
send "\r"
interact