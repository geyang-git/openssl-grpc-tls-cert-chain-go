
rm root/ca.key
rm root/ca.crt
rm root/pri.key

rm A/server.key
rm A/server.crt
rm A/server.csr
rm A/pri.key

rm B/server.key
rm B/server.crt
rm B/server.csr
rm B/pri.key

rm n1/node.key
rm n1/node.crt
rm n1/node.csr
rm n1/pri.key

rm n2/node.key
rm n2/node.crt
rm n2/node.csr
rm n2/pri.key

rm n3/node.key
rm n3/node.crt
rm n3/node.csr
rm n3/pri.key

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

cd ../n2 || exit
./node.sh
cat ../A/server.crt >> node.crt

cd ../n3 || exit
./node.sh
cat ../B/server.crt >> node.crt
