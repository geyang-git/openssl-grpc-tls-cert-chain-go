#!/usr/local/bin/expect -f
spawn openssl genrsa -des3 -out ca.key 1024
expect "Enter*"
send "null\r"
expect "Verifying*"
send "null\r"
spawn openssl rsa -in ca.key -out ca.key
expect "Enter*"
send "null\r"
spawn openssl req -new -x509 -days 365 -key ca.key -out ca.crt -config ca.cnf -extensions v3_req
send "\r"
send "\r"
send "\r"
send "\r"
send "\r"
interact