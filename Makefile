LOGFILE=$(LOGPATH) `date +'%A-%b-%d-%Y-TIME-%H-%M-%S'`

.PHONY: cm
cm: ## 🌱 git commit
	@echo '************👇  run command 👇************'
	git add .
	git commit -m "🌱Go-interview-Questions💙-${LOGFILE}"
	git push -u origin main