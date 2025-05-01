.PHONY: install serve deploy clean

VENV_NAME ?= mkdocs-env

install:
	python3 -m venv $(VENV_NAME)
	. $(VENV_NAME)/bin/activate && \
	pip install -U pip && \
	pip install mkdocs-material mkdocs-mermaid2-plugin

serve:
	. $(VENV_NAME)/bin/activate && \
	mkdocs serve

deploy:
	. $(VENV_NAME)/bin/activate && \
	mkdocs gh-deploy --clean

clean:
	rm -rf site/ $(VENV_NAME)
