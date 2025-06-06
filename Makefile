.PHONY: generate cli format test standard-test

CLI_PATH = bin/tradaul
CLI_SRC = bin/tradaul.dart
STD_TEST_PATH = lua-5.4.6-tests

all:
	@echo "Error: select target"

generate:
	dart run build_runner build

cli:
	dart compile exe $(CLI_SRC) -o $(CLI_PATH)

format:
	dart fix --apply
	dart format lib test bin

test:
	dart test

standard-test: cli
	cd $(STD_TEST_PATH) && ../$(CLI_PATH) all.lua
