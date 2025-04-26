package main

import (
	"errors"
	"log"
	"net/http"
	"strconv"

	store "github.com/3omer/xdev/internal"
	"github.com/go-chi/chi/v5"
)

func (app *application) getPosts(w http.ResponseWriter, r *http.Request) {
	posts, err := app.store.User.GetAll(r.Context())

	if err != nil {
		writeJSON(w, http.StatusInternalServerError, &ErrorResponse{"Something went wrong"})
		return
	}

	writeJSON(w, http.StatusOK, &posts)
}

type CreatePostRequest struct {
	Title   string   `json:"title"`
	Content string   `json:"content"`
	Tags    []string `json:"tags"`
}

func (app *application) createPostHandler(w http.ResponseWriter, r *http.Request) {

	var post store.Post
	var payload CreatePostRequest

	if err := readJSON(w, r, &payload); err != nil {
		log.Printf("create post failed, JSON parsing error: %s", err.Error())
		writeJSON(w, http.StatusInternalServerError, &ErrorResponse{"Something went wrong"})
		return
	}

	post.Title = payload.Title
	post.Content = payload.Content
	post.Tags = payload.Tags
	// post.UserId = r.Context().Value("currentUser").(int64)
	post.UserId = 151

	if err := app.store.Post.Create(r.Context(), &post); err != nil {
		log.Printf("create post failed, store error: %s", err.Error())
		writeJSON(w, http.StatusInternalServerError, &ErrorResponse{"Something went wrong"})
		return
	}

	res := &struct{ Id int64 }{post.Id}
	writeJSON(w, http.StatusCreated, res)

}

func (app *application) getPostHandler(w http.ResponseWriter, r *http.Request) {
	postIdParam := chi.URLParam(r, "id")
	postId, err := strconv.ParseInt(postIdParam, 10, 64)

	if err != nil {
		log.Printf("get post by id failed, parse url param error: %s", err.Error())
		writeJSON(w, http.StatusBadRequest, &ErrorResponse{"invalid id"})
		return
	}

	post, err := app.store.Post.GetById(r.Context(), postId)
	if err != nil {
		log.Print(err)

		if errors.Is(err, store.ErrPostNotFound) {
			writeJSON(w, http.StatusNotFound, &ErrorResponse{"Post not found"})
			return
		}
		writeJSON(w, http.StatusInternalServerError, &ErrorResponse{"Something went wrong"})
		return
	}

	writeJSON(w, http.StatusOK, &post)
}
