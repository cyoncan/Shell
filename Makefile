.PHONY: help
curr_time := $(shell date -d today + %Y%m%d%H%M%S)
help:
	@echo ""
	@echo "-------------------------------------------------------------"
	@echo "enter \`make push\` from local_dir to push all file on github"
	@echo "-------------------------------------------------------------"
	@echo ""
push:
	git add . -A
	git commit -e
	git push 