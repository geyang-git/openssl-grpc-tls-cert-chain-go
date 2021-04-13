#!/usr/local/bin/expect -f
spawn openssl ecparam -genkey -name SM2 -out pri.key
spawn openssl pkcs8 -topk8 -inform PEM -in pri.key -nocrypt -out node.key
spawn openssl req -new -sm3 -key node.key -out node.csr -config node.cnf -extensions v3_req
send "\r"
send "\r"
send "\r"
send "\r"
send "\r"
spawn openssl x509 -req -extfile node.cnf -extensions v3_req -days 365 -in node.csr -CA ../B/server.crt -CAkey ../B/server.key -set_serial 01 -out node.crt
interact