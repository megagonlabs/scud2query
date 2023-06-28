
all: lint test validate

setup: setup_npm setup_python


setup_npm:
	npm install

lint:lint_markdown

lint_markdown:
	find *.md | grep '\.md$$' \
		| xargs npx markdownlint --config ./.markdownlint.json

POETRY_NO_ROOT:= --no-root
setup_python:
	poetry install $(POETRY_OPTION)

yamllint:
	find . -name '*.yml' -type f | grep -v node_modules | xargs yamllint --no-warnings

test: yamllint

validate: validate_example validate_correctness_labeled 

validate_example:
	python -m asdc.check.format --type example -i ./data/correctness_labeled_scud/scud2query --prefix "correctness_labeled."

validate_correctness_labeled:
	python -m asdc.check.format --type correctness_labeled_example -i ./data/correctness_labeled_scud/scud2query

.PHONY: all setup \
	yamllint \
	test validate \
	validate_example validate_correctness_labeled 

