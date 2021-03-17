openssl genrsa -des3 -out ca.key 1024
openssl rsa -in ca.key -out ca.key
openssl req -new -x509 -days 365 -key ca. key -out ca.crt -config ca.cnf -extensions v3_req