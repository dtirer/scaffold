package main

import (
	"log"
	"net/http"

	"github.com/dtirer/stack/internal/views"
)

func main() {

	// Route example
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Rendering a view
		views.Index().Render(r.Context(), w)
	})

	// Serve static files like CSS and JS
	fs := http.FileServer(http.Dir("./public"))
	http.Handle("/public/", http.StripPrefix("/public/", fs))

	// Run the server
	log.Println("Starting server on localhost:8080")
	if err := http.ListenAndServe("localhost:8080", nil); err != nil {
		panic(err)
	}
}
