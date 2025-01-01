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
	docker exec -it dotfiles-run zsh
up: build
	docker run \
		--rm \
		-d \
		-v $(PWD):/usr/src/dotfiles \
		--name dotfiles-run \
		dotfiles
