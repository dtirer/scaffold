package main

import (
	"fmt"
	"net/http"
	"os"
	"os/signal"

	stack "github.com/dtirer/stack/pkg"
	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		panic(err)
	}

	killSig := make(chan os.Signal, 1)
	signal.Notify(killSig, os.Interrupt)

	srv := stack.NewServer()
	httpServer := &http.Server{
		Addr:    fmt.Sprintf("%s:%s", os.Getenv("APP_HOST"), os.Getenv("APP_PORT")),
		Handler: srv,
	}

	// Run the server
	go func() {
		fmt.Printf("Starting server on %s:%s", os.Getenv("APP_HOST"), os.Getenv("APP_PORT"))
		if err := httpServer.ListenAndServe(); err != nil {
			panic(err)
		}
	}()

	<-killSig
}
