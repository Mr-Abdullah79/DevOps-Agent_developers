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

coverage: build ## the tests again, writing coverage/lcov.info for SonarQube
	@mkdir -p coverage
	node --test --experimental-test-coverage \
		--test-reporter spec --test-reporter-destination=stdout \
		--test-reporter=lcov --test-reporter-destination=coverage/lcov.info

clean:
	rm -rf $(OUT_DIR) coverage *.tgz

package: test
	npm pack

ci: clean deps lint test package

.PHONY: all build clean ci deps test package lint coverage

lint: node_modules ## static analysis
	npm run --silent lint
