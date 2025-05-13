-- +goose Up
CREATE TABLE "Comment" (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES "User"(id),
    post_id BIGINT NOT NULL REFERENCES "Post"(id),
    content text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- +goose Down
DROP TABLE "Comment";