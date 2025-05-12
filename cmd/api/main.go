package main

import (
	"context"
	"database/sql"
	"log"
	"os"
	"time"

	store "github.com/3omer/xdev/internal"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

func main() {

	err := godotenv.Load()

	if err != nil {
		log.Fatal("Error loading .env file")
	}

	config := config{
		addr:           os.Getenv("ADDR"),
		dbURL:          os.Getenv("DB_URL"),
		dbMaxOpenConns: 30,
		dbMaxIdleConns: 30,
		dbMaxIdleTime:  "15m",
		env:            os.Getenv("ENV"),
	}

	db, err := sql.Open("postgres", config.dbURL)
	db.SetMaxOpenConns(config.dbMaxOpenConns)
	db.SetMaxIdleConns(config.dbMaxIdleConns)

	if err != nil {
		log.Fatal(err)
	}

	dbCtx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := db.PingContext(dbCtx); err != nil {
		log.Fatal(err)
	}

	log.Println("DB connection established")

	// data access
	store := store.NewStore(db)

	app := &application{
		config: config,
		store:  store,
	}

	mux := app.mount()
	app.run(mux)
}
