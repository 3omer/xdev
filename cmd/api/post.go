package main

import (
	"errors"
	"log"
	"net/http"
	"strconv"

	store "github.com/3omer/xdev/internal"
	"github.com/go-chi/chi/v5"
	"github.com/go-playground/validator/v10"
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
	Title   string   `json:"title" validate:"max=100"`
	Content string   `json:"content" validate:"required,max=1000,min=1"`
	Tags    []string `json:"tags"`
}

func (app *application) createPostHandler(w http.ResponseWriter, r *http.Request) {

	var post store.Post
	var payload CreatePostRequest

	if err := readJSON(w, r, &payload); err != nil {
		log.Printf("create post failed, JSON parsing error: %s", err.Error())
		app.badRequestResponse(w, r, "Invalid payload")
		return
	}

	err := Validate.Struct(&payload)

	if err != nil {
		var validateErrs validator.ValidationErrors
		fieldsErrs := map[string]string{}
		if errors.As(err, &validateErrs) {
			for _, err := range validateErrs {
				fieldsErrs[err.Field()] = "validation failed" // why this is so much work
			}
			writeJSON(w, http.StatusBadRequest, fieldsErrs)
			return
		}
		app.internalServerErrorResponse(w, r, "ugh")
		return
	}

	post.Title = payload.Title
	post.Content = payload.Content
	post.Tags = payload.Tags
	// post.UserId = r.Context().Value("currentUser").(int64)
	post.UserId = 151

	if err := app.store.Post.Create(r.Context(), &post); err != nil {
		log.Printf("create post failed, store error: %s", err.Error())
		app.internalServerErrorResponse(w, r, "Something went wrong")
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
		app.badRequestResponse(w, r, "Invalid id")
		return
	}

	post, err := app.store.Post.GetById(r.Context(), postId)
	if err != nil {
		log.Print(err)

		if errors.Is(err, store.ErrPostNotFound) {
			app.badRequestResponse(w, r, "Post not found")
			return
		}
		app.internalServerErrorResponse(w, r, "something went wrong")
		return
	}

	writeJSON(w, http.StatusOK, &post)
}

func (app *application) getPostComments(w http.ResponseWriter, r *http.Request) {
	postIdParam := chi.URLParam(r, "id")
	postId, err := strconv.ParseInt(postIdParam, 10, 64)

	if err != nil {
		log.Printf("Failed to parse post-id {%s}, error %s", postIdParam, err.Error())
		app.badRequestResponse(w, r, "Invalid post-id param")
		return
	}

	comments, err := app.store.Comment.GetByPostId(r.Context(), postId)

	if err != nil {
		log.Printf("Failed to fetch comments for post {%v}, error: %s", postId, err.Error())
		app.internalServerErrorResponse(w, r, "Something went wrong")
		return
	}
	data := []CommentsResponse{}

	for _, c := range *comments {
		data = append(data, CommentsResponse{
			Id:      c.Id,
			UserId:  c.UserId,
			PostId:  c.PostId,
			Content: c.Content,
		})
	}
	writeJSON(w, http.StatusOK, data)
}

func (app *application) createComment(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	userId := ctx.Value("userId").(int64)

	if userId == 0 {
		app.UnauthorizedRequest(w, r)
		return
	}

	paramPostId := chi.URLParam(r, "id")
	postId, err := strconv.ParseInt(paramPostId, 10, 64)
	if err != nil {
		log.Printf("Parsing post-id param failed: %s", err.Error())
		app.badRequestResponse(w, r, "invalid post-id param")
		return
	}

	log.Printf("Creating new comment: user{%v}, post{%v}", userId, postId)

	var payload CreateCommentRequest
	err = readJSON(w, r, &payload)

	if err != nil {
		log.Print("Parsing failed ", err.Error())
		app.badRequestResponse(w, r, "bad request")
		return
	}

	if err := Validate.Struct(payload); err != nil {
		log.Printf("Validation error %s", err.Error())
		app.badRequestResponse(w, r, "Invalid payload")
		return
	}

	comment := &store.Comment{}
	comment.UserId = userId
	comment.PostId = postId
	comment.Content = payload.Content

	err = app.store.Comment.Create(ctx, comment)

	if err != nil {
		log.Printf("failed to create comment %s", err.Error())
		app.internalServerErrorResponse(w, r, "Something went wrong")
		return
	}

	writeJSON(w, http.StatusOK, struct{}{})

}

type CreateCommentRequest struct {
	Content string `json:"content" validate:"required,max=1000,min=1"`
}

type CommentsResponse struct {
	Id      int64  `json:"id"`
	UserId  int64  `json:"userId"`
	PostId  int64  `json:"postId"`
	Content string `json:"content"`
}
