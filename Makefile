
SRC_DIR := src
OUT_DIR := out

SOURCES := $(wildcard $(SRC_DIR)/*.md)
OUTPUTS := $(patsubst $(SRC_DIR)/%.md,$(OUT_DIR)/%.html,$(SOURCES))

.PHONY: all check build deps test package clean ci

all: ci

check:
	@test -n "$(SOURCES)" || (echo "No Markdown source files found"; exit 1)
	@test -f tools/build.js || (echo "Missing tools/build.js"; exit 1)
	@test -f package.json || (echo "Missing package.json"; exit 1)
	@test -f package-lock.json || (echo "Missing package-lock.json"; exit 1)

node_modules: package-lock.json
	npm ci
	@touch node_modules

deps: node_modules

build: $(OUTPUTS)

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(OUT_DIR)/%.html: $(SRC_DIR)/%.md package-lock.json | $(OUT_DIR) node_modules
	@echo "BUILD $< -> $@"
	@npm run --silent build -- $< $@

test: build
	@npm test --silent

package: test
	npm pack

clean:
	rm -rf $(OUT_DIR) *.tgz

ci: clean deps check test package

