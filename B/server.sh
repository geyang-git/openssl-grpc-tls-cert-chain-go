#!/usr/local/bin/expect -f
spawn gmssl ecparam -genkey -name sm2p256v1 -out pri.key
spawn gmssl pkcs8 -topk8 -inform PEM -in pri.key -nocrypt -out server.key
spawn gmssl req -new -sm3 -key server.key -out server.csr -config server.cnf -extensions v3_req
send "\r"
send "\r"
send "\r"
send "\r"
send "\r"
spawn gmssl x509 -req -sm3 -extfile server.cnf -extensions v3_req -days 365 -in server.csr -CA ../root/ca.crt -CAkey ../root/ca.key -set_serial 01 -out server.crt
interact