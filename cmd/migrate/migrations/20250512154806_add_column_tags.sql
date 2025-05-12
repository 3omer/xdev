-- +goose Up
ALTER TABLE "Post"
ADD COLUMN "tags" VARCHAR(100) [];
-- +goose Down
ALTER TABLE "Post" DROP COLUMN "tags" VARCHAR(100) [];