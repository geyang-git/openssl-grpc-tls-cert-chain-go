openssl genrsa -des3 -out node.key 1024
openssl rsa -in node.key -out node.key
openssl req -new -key node.key -out node.csr -config node.cnf -extensions v3_req
openssl x509 -req -extfile node.cnf -extensions v3_req -days 365 -in node.csr -CA ../A/server.crt -CAkey ../A/server.key -set_serial 01 -out node.crt
