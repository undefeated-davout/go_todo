.PHONY: help build build-local up down logs ps test
.DEFAULT_GOAL := help

DOCKER_TAG := latest
build: ## デプロイ用Dockerビルド
	docker build -t gotodo:${DOCKER_TAG} \
		--target deploy ./

build-local: ## ローカル用Dockerビルド
	docker compose build --no-cache

up: ## 起動
	docker compose up -d

down: ## 終了
	docker compose down

logs: ## ログ表示
	docker compose logs -f

ps: ## コンテナ状態表示
	docker compose ps

test: ## テスト実行
	go test -race -shuffle=on ./...

dry-migrate: ## マイグレーションDLL表示
	mysqldef -u todo -p todo -h todo-db -P 3306 todo --dry-run < ./_tools/mysql/schema.sql

migrate: ## マイグレーション実行
	mysqldef -u todo -p todo -h todo-db -P 3306 todo < ./_tools/mysql/schema.sql

generate: ## コード生成
	go generate ./...

help: ## ヘルプ表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
