package main

import (
	"log"
	"net/http"
	"time"

	"github.com/3omer/xdev/internal"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

type application struct {
	config config
	store  internal.Store
}

type config struct {
	addr           string
	dbURL          string
	dbMaxOpenConns int
	dbMaxIdleConns int
	dbMaxIdleTime  string
	env            string
}

// creates and setup handlers and middlewares
// returns http.Handler
func (app *application) mount() http.Handler {
	r := chi.NewRouter()

	// A good base middleware stack
	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	// until we have auth
	r.Use(internal.UserId)

	// Set a timeout value on the request context (ctx), that will signal
	// through ctx.Done() that the request has timed out and further
	// processing should be stopped.
	r.Use(middleware.Timeout(60 * time.Second))
	r.Use(middleware.SetHeader("Content-Type", "application/json"))

	r.Get("/api/health", app.healthCheckHandler)

	r.Route("/api/user", func(r chi.Router) {

		r.Get("/", app.getAllUsers)

		r.Post("/", app.createUserHandler)
	})

	r.Route("/api/post", func(r chi.Router) {
		r.Get("/", app.getPosts)
		r.Post("/", app.createPostHandler)
		r.Get("/{id}", app.getPostHandler)
		r.Get("/{id}/comments", app.getPostComments)
		r.Post("/{id}/comments", app.createComment)
		r.Patch("/{id}", app.updatePost)
	})
	return r
}

func (app *application) badRequestResponse(w http.ResponseWriter, r *http.Request, msg string) {
	log.Printf("Bad request [%s][%s], error: %s", r.Method, r.URL.Path, msg)
	writeJSON(w, http.StatusBadRequest, &ErrorResponse{msg})
}

func (app *application) internalServerErrorResponse(w http.ResponseWriter, r *http.Request, msg string) {
	log.Printf("Server error [%s][%s], error: %s", r.Method, r.URL.Path, msg)
	writeJSON(w, http.StatusInternalServerError, &ErrorResponse{msg})
}

func (app *application) UnauthorizedRequest(w http.ResponseWriter, r *http.Request) {
	log.Printf("Unauthorized request [%s][%s]", r.Method, r.URL.Path)
	writeJSON(w, http.StatusForbidden, &ErrorResponse{"Forbidden"})
}

// creates and starts http server using a handler
func (app *application) run(mux http.Handler) error {

	svr := &http.Server{
		Addr:         app.config.addr,
		Handler:      mux,
		WriteTimeout: 30 * time.Second,
		ReadTimeout:  10 * time.Second,
		IdleTimeout:  time.Minute,
	}

	log.Printf("Starting HTTP server at %s", svr.Addr)
	return svr.ListenAndServe()
}
