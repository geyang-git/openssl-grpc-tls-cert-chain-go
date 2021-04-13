#!/usr/local/bin/expect -f
spawn openssl ecparam -genkey -name SM2 -out pri.key
spawn openssl pkcs8 -topk8 -inform PEM -in pri.key -nocrypt -out server.key
spawn openssl req -new -sm3 -key server.key -out server.csr -config server.cnf -extensions v3_req
send "\r"
send "\r"
send "\r"
send "\r"
send "\r"
spawn openssl x509 -req -extfile server.cnf -extensions v3_req -days 365 -in server.csr -CA ../root/ca.crt -CAkey ../root/ca.key -set_serial 01 -out server.crt
interact