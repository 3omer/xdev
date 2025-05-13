package store

import (
	"context"
	"database/sql"
	"errors"
	"log"

	"github.com/lib/pq"
)

var ErrPostNotFound = errors.New("Post not found")

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

type Comment struct {
	Id        int64
	UserId    int64
	PostId    int64
	Content   string
	CreatedAt string
	UpdatedAt string
}
type Store struct {
	User interface {
		GetAll(context.Context) (*[]User, error)
		Create(context.Context, *User) error
	}

	Post interface {
		GetAll(context.Context) (*[]Post, error)
		Create(context.Context, *Post) error
		GetById(context.Context, int64) (*Post, error)
	}

	Comment interface {
		GetByPostId(context.Context, int64) (*[]Comment, error)
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

func (repo *PostStore) GetById(ctx context.Context, id int64) (*Post, error) {

	q := `
	SELECT id, user_id, title, content, tags, updated_at, created_at FROM "Post" WHERE id = $1
	`
	row := repo.db.QueryRowContext(ctx, q, id)

	var post Post
	err := row.Scan(
		&post.Id,
		&post.UserId,
		&post.Title,
		&post.Content,
		pq.Array(&post.Tags),
		&post.CreatedAt,
		&post.UpdatedAt)

	if err != nil {
		switch {
		case errors.Is(err, sql.ErrNoRows):
			return nil, ErrPostNotFound
		default:
			log.Printf("store.Post.findById:: %s", err.Error())
			return nil, err
		}
	}

	return &post, nil
}

type CommentStore struct {
	db *sql.DB
}

func (repo *CommentStore) GetByPostId(ctx context.Context, postId int64) (*[]Comment, error) {
	// var comments []Comment
	comments := []Comment{}

	q := `
	SELECT c.id, c.post_id, c.user_id, c.content, c.created_at, c.updated_at 
	FROM "Comment" c JOIN "Post" p 
	ON c.post_id = p.id 
	WHERE c.post_id = $1 
	ORDER BY c.created_at DESC;
	`

	rows, err := repo.db.QueryContext(ctx, q, postId)
	if err != nil {
		log.Printf("GetByPostId failed:: %s", err.Error())
		return nil, err
	}

	var comment Comment
	for rows.Next() {
		err := rows.Scan(
			&comment.Id,
			&comment.PostId,
			&comment.UserId,
			&comment.Content,
			&comment.CreatedAt,
			&comment.UpdatedAt,
		)

		if err != nil {
			log.Printf("Reading row from Comment failed:: %s", err.Error())
			return nil, err
		}

		comments = append(comments, comment)
	}

	return &comments, nil
}

func NewStore(db *sql.DB) Store {
	return Store{
		User:    &UserStore{db},
		Post:    &PostStore{db},
		Comment: &CommentStore{db},
	}
}
