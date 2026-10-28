SRC_DIR := src
OUT_DIR := out

SOURCES := $(wildcard $(SRC_DIR)/*.md)
OUTPUTS := $(patsubst $(SRC_DIR)/%.md, $(OUT_DIR)/%.html, $(SOURCES))

node_modules: package-lock.json
	npm ci
	@touch node_modules

deps: node_modules

$(OUT_DIR)/%.html: $(SRC_DIR)/%.md package-lock.json | $(OUT_DIR) node_modules
	@echo "BUILD $< -> $@"
	@npm run --silent build -- $< $@

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

build: $(OUTPUTS)

test: build
	@npm test --silent

clean:
	rm -rf $(OUT_DIR) *.tgz

package: test
	npm pack

ci: clean deps build test package

.PHONY: all build clean ci deps test package
