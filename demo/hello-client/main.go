package main

import (
	"crypto/tls"
	"crypto/x509"
	"flag"
	pb "github.com/enricofoltran/hello-auth-grpc/hello"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
)

func withConfigDir(path string) string {
	return filepath.Join("/Users/gy/Desktop/gmCa/A", path)
}

func main() {
	serverAddr := flag.String("server-addr", "test.example.com:10000", "remote hello server address")
	tlsCrt := flag.String("tls-crt", withConfigDir("server.crt"), "client certificate file")
	tlsKey := flag.String("tls-key", withConfigDir("server.key"), "client private key file")
	//caCrt := flag.String("ca-crt", withConfigDir("../A/server.crt"), "CA certificate file")
	caRootCrt := flag.String("ca-root", withConfigDir("../root/ca.crt"), "CA certificate file")
	flag.Parse()

	logger := log.New(os.Stderr, "hello: ", log.LstdFlags)

	crt, err := tls.LoadX509KeyPair(*tlsCrt, *tlsKey)
	if err != nil {
		logger.Fatalf("could not load client key pair from file: %v", err)
	}

	//rawCaCrt, err := ioutil.ReadFile(*caCrt)
	//if err != nil {
	//	logger.Fatalf("could not load CA certificate from file: %v", err)
	//}

	rawCaRootCrt, err := ioutil.ReadFile(*caRootCrt)
	if err != nil {
		logger.Fatalf("could not load CA certificate from file: %v", err)
	}

	caCrtPool := x509.NewCertPool()

	if ok := caCrtPool.AppendCertsFromPEM(rawCaRootCrt); !ok {
		logger.Fatalf("could not append CA certificate to cert pool: %v", err)
	}
	//if ok := caCrtPool.AppendCertsFromPEM(rawCaCrt); !ok {
	//	logger.Fatalf("could not append CA certificate to cert pool: %v", err)
	//}

	tlsCreds := credentials.NewTLS(&tls.Config{
		Certificates: []tls.Certificate{crt},
		RootCAs:      caCrtPool,
	})

	conn, err := grpc.Dial(
		*serverAddr,
		grpc.WithTransportCredentials(tlsCreds),
	)
	if err != nil {
		logger.Fatalf("could not connect to remote server: %v", err)
	}
	defer conn.Close()

	clt := pb.NewGreeterClient(conn)

	req := &pb.Request{}
	res, err := clt.SayHello(context.Background(), req)
	if err != nil {
		logger.Fatalf("could not say hello: %v", err)
	}

	logger.Printf("remote server say: %s", res.Message)
}
