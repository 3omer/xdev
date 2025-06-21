-- +goose Up
ALTER TABLE "Post"
ADD COLUMN "is_deleted" BOOLEAN DEFAULT FALSE;
-- +goose Down
ALTER TABLE "Post" DROP COLUMN "is_deleted";