package stack

import (
	"net/http"

	"github.com/dtirer/stack/pkg/views"
	"github.com/go-chi/chi/v5"
)

func NewServer() http.Handler {
	mux := chi.NewRouter()

	// Serve static files like CSS and JS
	mux.Handle("/public/*", http.StripPrefix("/public/", http.FileServer(http.Dir("./public"))))

	// Route example
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Rendering a view
		views.Index().Render(r.Context(), w)
	})

	// routes here

	return mux
}
