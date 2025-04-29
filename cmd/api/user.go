package main

import (
	"log"
	"net/http"

	store "github.com/3omer/xdev/internal"
)

type CreateUserRequest struct {
	Name     string `json:"name"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

func (app *application) createUserHandler(w http.ResponseWriter, r *http.Request) {

	var user store.User
	var payload CreateUserRequest

	if err := readJSON(w, r, &payload); err != nil {
		log.Printf("Parsing create user request failed with %s", err.Error())
		app.badRequestResponse(w, r, "Invalid payload")
		return
	}

	// do validation
	user.Name = payload.Name
	user.Email = payload.Email
	user.Password = payload.Password

	if err := app.store.User.Create(r.Context(), &user); err != nil {
		// constraint violation error, validation error, conn error? how do i tell
		log.Printf("create user request failed: %s", err.Error())
		app.internalServerErrorResponse(w, r, "Something went wrong")
		return
	}

	res := struct{ Id int64 }{user.Id}
	writeJSON(w, http.StatusCreated, res)
}

func (app *application) getAllUsers(w http.ResponseWriter, r *http.Request) {
	users, err := app.store.User.GetAll(r.Context())

	if err != nil {
		w.Write([]byte(err.Error()))
		app.internalServerErrorResponse(w, r, "Something went wrong")
		return
	}

	writeJSON(w, http.StatusOK, &users)
}
