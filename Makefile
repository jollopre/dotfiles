.PHONY: build clean down install lint lint_fix logs shell up

build:
	docker build -t dotfiles .
clean:
	docker rmi dotfiles
down:
	docker stop dotfiles-run
install:
lint:
lint_fix:
logs:
shell:
	docker exec -it dotfiles-run sh
up: build
	docker run \
		--rm \
		-d \
		-v $(PWD)/nvim:/root/.config/nvim \
		--name dotfiles-run \
		dotfiles
