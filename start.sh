
rm root/ca.key
rm root/ca.crt

rm A/server.key
rm A/server.crt
rm A/server.csr

rm B/server.key
rm B/server.crt
rm B/server.csr

rm n1/node.key
rm n1/node.crt
rm n1/node.csr

rm n3/node.key
rm n3/node.crt
rm n3/node.csr

cd ./root || exit
./ca.sh
cd ../A || exit
./server.sh
cat ../root/ca.crt  >> server.crt
cd ../B || exit
./server.sh
cat ../root/ca.crt  >> server.crt
cd ../n1 || exit
./node.sh
cat ../A/server.crt >> node.crt
cd ../n3 || exit
./node.sh
cat ../B/server.crt >> node.crt
