package main

import (
	"encoding/json"
	"net/http"
)

const version = "1.0"

func (app *application) healthCheckHandler(w http.ResponseWriter, r *http.Request) {
	payload := map[string]string{
		"status":  "ok",
		"env":     app.config.env,
		"version": version,
	}
	json.NewEncoder(w).Encode(payload)
}
