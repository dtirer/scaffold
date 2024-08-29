-- name: AddBook :exec
INSERT INTO books (id, title, authors, state_id) VALUES (?, ?, ?, ?) RETURNING id;

-- name: GetBook :one
SELECT * FROM books WHERE id = ?;