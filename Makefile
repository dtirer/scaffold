# Load environment variables from .env file
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

setup:
	go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
	go install github.com/a-h/templ/cmd/templ@latest
	go get ./...
	npm install -D tailwindcss
	cp .env.example .env

sqlc:
	sqlc generate

migrate-create:
	@GOOSE_DRIVER=sqlite3 GOOSE_DBSTRING=${DB_NAME}  go run github.com/pressly/goose/v3/cmd/goose@latest -dir=${MIGRATIONS_DIR} create $(filter-out $@,$(MAKECMDGOALS)) sql

migrate-up:
	@GOOSE_DRIVER=sqlite3 GOOSE_DBSTRING=${DB_NAME}  go run github.com/pressly/goose/v3/cmd/goose@latest -dir=${MIGRATIONS_DIR}  up

migrate-down:
	@GOOSE_DRIVER=sqlite3 GOOSE_DBSTRING=${DB_NAME}  go run github.com/pressly/goose/v3/cmd/goose@latest -dir=${MIGRATIONS_DIR}  down

migrate-reset:
	@GOOSE_DRIVER=sqlite3 GOOSE_DBSTRING=${DB_NAME}  go run github.com/pressly/goose/v3/cmd/goose@latest -dir=${MIGRATIONS_DIR}  reset

templ:
	templ generate --watch --open-browser=false --proxy="http://localhost:3000"

tailwind:
	npx tailwindcss -i ./input.css -o ./public/css/app.css --watch

server:
	air \
	--build.cmd "go build --tags dev -o ./tmp/main ./cmd" \
	--build.exclude_dir "node_modules" \
	--build.include_ext "go,templ" \
	--build.stop_on_error "false" \
	--misc.clean_on_exit true \
	--log.main_only true \
	--proxy.enabled true \
	--proxy.proxy_port 3000 \
	--proxy.app_port 8080


dev:
	make -j3 server templ tailwind