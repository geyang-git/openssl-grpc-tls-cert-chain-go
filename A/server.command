openssl genrsa -des3 -out server.key 1024
openssl rsa -in server.key -out server.key
openssl req -new -sm3 -key server.key -out server.csr -config server.cnf -extensions v3_req
openssl x509 -req -extfile server.cnf -extensions v3_req -days 365 -in server.csr -CA ../root/ca.crt -CAkey ../root/ca.key -set_serial 01 -out server.crt