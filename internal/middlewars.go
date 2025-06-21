package internal

import (
	"context"
	"log"
	"net/http"
	"strconv"
)

// caution: for development use only
// Pulls a userId from header "X-User-Id"
// and adds it to request context as a value
func UserId(next http.Handler) http.Handler {
	fn := func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		userIdStr := r.Header.Get("X-User-Id")
		userId, _ := strconv.ParseInt(userIdStr, 10, 64)
		ctx = context.WithValue(ctx, "userId", userId)
		log.Printf("Middleware: User is {%v}", userId)
		next.ServeHTTP(w, r.WithContext(ctx))
	}
	return http.HandlerFunc(fn)
}
