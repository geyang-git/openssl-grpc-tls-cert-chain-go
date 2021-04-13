package main

import (
	"crypto/tls"
	"crypto/x509"
	"flag"
	"fmt"
	"golang.org/x/net/context"
	"io/ioutil"
	"log"
	"net"
	"os"
	"path/filepath"

	pb "github.com/enricofoltran/hello-auth-grpc/hello"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
)

func withConfigDir(path string) string {
	return filepath.Join("/Users/gy/Desktop/openssl-grpc-tls-cert-chain-go/n1", path)
}
func main() {
	listenAddr := flag.String("listen-addr", "127.0.0.1:10000", "hello server listen address")
	tlsCrt := flag.String("tls-crt", withConfigDir("node.crt"), "hello server certificate file")
	tlsKey := flag.String("tls-key", withConfigDir("node.key"), "hello server private key file")
	caRootCrt := flag.String("ca-root", withConfigDir("../root/ca.crt"), "CA certificate file")
	flag.Parse()

	logger := log.New(os.Stderr, "hello: ", log.LstdFlags)
	logger.Printf("server is starting...")

	crt, err := tls.LoadX509KeyPair(*tlsCrt, *tlsKey)
	if err != nil {
		logger.Fatalf("could not load client key pair from file: %v", err)
	}

	rawCaRootCrt, err := ioutil.ReadFile(*caRootCrt)
	if err != nil {
		logger.Fatalf("could not load CA certificate from file: %v", err)
	}

	caCrtPool := x509.NewCertPool()

	if ok := caCrtPool.AppendCertsFromPEM(rawCaRootCrt); !ok {
		logger.Fatalf("could not append CA certificate to cert pool: %v", err)
	}

	tlsCreds := credentials.NewTLS(&tls.Config{
		Certificates: []tls.Certificate{crt},
		ClientAuth:   tls.RequireAndVerifyClientCert,
		ClientCAs:    caCrtPool,
	})

	ln, err := net.Listen("tcp", *listenAddr)
	if err != nil {
		logger.Fatalf("could not listen: %v", err)
	}

	grpcServer := grpc.NewServer(grpc.Creds(tlsCreds))

	helloServer, err := NewHelloServer()
	if err != nil {
		logger.Fatalf("%v", err)
	}

	pb.RegisterGreeterServer(grpcServer, helloServer)

	logger.Printf("server is listening on port %s...", *listenAddr)
	grpcServer.Serve(ln)
}

type server struct {
}

// NewHelloServer return an new hello server instance
func NewHelloServer() (*server, error) {
	return &server{}, nil
}

func (s *server) SayHello(ctx context.Context, r *pb.Request) (*pb.Response, error) {
	fmt.Printf("Hello?????")
	return &pb.Response{Message: "Hello!"}, nil
}
