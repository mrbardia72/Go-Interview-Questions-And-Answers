branch := $(shell git branch --show-current)

.PHONY: cm
cm: ## 🌱 git commit
	git add .
	git commit -m "$(branch)"
	git push origin $(branch)
