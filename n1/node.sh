#!/usr/local/bin/expect -f
spawn gmssl ecparam -genkey -name sm2p256v1 -out pri.key
spawn gmssl pkcs8 -topk8 -inform PEM -in pri.key -nocrypt -out node.key
spawn gmssl req -new -sm3 -key node.key -out node.csr -config node.cnf -extensions v3_req
send "\r"
send "\r"
send "\r"
send "\r"
send "\r"
spawn gmssl x509 -req -sm3 -extfile node.cnf -extensions v3_req -days 365 -in node.csr -CA ../A/server.crt -CAkey ../A/server.key -set_serial 01 -out node.crt
interact