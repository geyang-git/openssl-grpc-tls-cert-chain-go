#!/usr/local/bin/expect -f
spawn openssl genrsa -des3 -out server.key 1024
expect "Enter*"
send "null\r"
expect "Verifying*"
send "null\r"
spawn openssl rsa -in server.key -out server.key
expect "Enter*"
send "null\r"
spawn openssl req -new -key server.key -out server.csr -config server.cnf -extensions v3_req
send "\r"
send "\r"
send "\r"
send "\r"
send "\r"
spawn openssl x509 -req -extfile server.cnf -extensions v3_req -days 365 -in server.csr -CA ../root/ca.crt -CAkey ../root/ca.key -set_serial 01 -out server.crt
interact