LOGFILE=$(LOGPATH) `date +'%A-%b-%d-%Y-TIME-%H-%M-%S'`
branch := $(shell git branch --show-current)

.PHONY: cm
cm: ## 🌱 git commit
	@echo '************👇  run command 👇************'
	git add .
	git commit -m "ggg-${LOGFILE}"
	git push origin "go-interview-2581"
