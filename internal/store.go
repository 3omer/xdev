package store

import (
	"context"
	"database/sql"
	"log"

	"github.com/lib/pq"
)

type User struct {
	Id         int64  `json:"id"`
	Name       string `json:"name"`
	Email      string `json:"email"`
	Password   string `json:"-"`
	PictureUrl string `json:"picture_url"`
	CreatedAt  string `json:"created_at"`
	UpdatedAt  string `json:"updated_at"`
}

type Post struct {
	Id        int64    `json:"id"`
	UserId    int64    `json:"userId"`
	Title     string   `json:"title"`
	Content   string   `json:"content"`
	Tags      []string `json:"tags"`
	CreatedAt string   `json:"created_at"`
	UpdatedAt string   `json:"updated_at"`
}

type Store struct {
	User interface {
		GetAll(context.Context) (*[]User, error)
		Create(context.Context, *User) error
	}

	Post interface {
		GetAll(context.Context) (*[]Post, error)
		Create(context.Context, *Post) error
	}
}

type UserStore struct {
	db *sql.DB
}

func (repo *UserStore) GetAll(ctx context.Context) (*[]User, error) {

	var users = []User{}

	rows, err := repo.db.QueryContext(ctx, `SELECT id, name, email, picture_url, created_at, updated_at FROM "User"`)

	if err != nil {
		log.Print("User.GetAll: query error: ", err.Error())
		return nil, err
	}

	defer rows.Close()

	for rows.Next() {
		var user User
		picUrl := sql.NullString{}

		err := rows.Scan(
			&user.Id,
			&user.Name,
			&user.Email,
			&picUrl,
			&user.CreatedAt,
			&user.UpdatedAt,
		)

		if err != nil {
			log.Print("User.GetAll: row scan error: ", err.Error())

			return nil, err
		}

		if picUrl.Valid {
			user.PictureUrl = picUrl.String
		} else {
			user.PictureUrl = ""
		}

		users = append(users, user)
	}

	return &users, nil
}

func (repo *UserStore) Create(ctx context.Context, user *User) error {
	q := `
	INSERT INTO public."User" (name, email, password, picture_url) 
	VALUES ($1, $2, $3, $4)
	RETURNING id, created_at
	`

	err := repo.db.QueryRowContext(
		ctx,
		q,
		&user.Name,
		&user.Email,
		&user.Password,
		&user.PictureUrl,
	).Scan(
		&user.Id,
		&user.CreatedAt,
	)

	if err != nil {
		return err
	}

	return nil
}

type PostStore struct {
	db *sql.DB
}

func (repo *PostStore) GetAll(ctx context.Context) (*[]Post, error) {

	rows, err := repo.db.QueryContext(ctx, `SELECT id, userId, title, content, createdAt, updatedAt FROM "Post"`)

	if err != nil {
		return nil, err
	}

	defer rows.Close()

	var posts []Post

	for rows.Next() {
		var post Post

		err := rows.Scan(
			&post.Id,
			&post.UserId,
			&post.Title,
			&post.Content,
			&post.CreatedAt,
			&post.UpdatedAt,
		)

		if err != nil {
			return nil, err
		}

		posts = append(posts, post)
	}

	return &posts, nil
}

func (repo *PostStore) Create(ctx context.Context, post *Post) error {

	q := `
		INSERT INTO "Post" (title, content, tags, user_id) 
		VALUES ($1, $2, $3, $4) 
		RETURNING id, created_at
		`

	err := repo.db.QueryRowContext(ctx,
		q,
		&post.Title,
		&post.Content,
		pq.Array(post.Tags),
		&post.UserId,
	).Scan(
		&post.Id,
		&post.CreatedAt,
	)

	if err != nil {
		log.Printf("Post.Create failed, error: %s", err.Error())
		return err
	}

	return nil
}

func NewStore(db *sql.DB) Store {
	return Store{
		User: &UserStore{db},
		Post: &PostStore{db},
	}
}
