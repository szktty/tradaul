.PHONY: generate cli

CLI_PATH = bin/tradaul
CLI_SRC = bin/main.dart

all:
	@echo "Error: select target"

generate:
	dart run build_runner build

cli:
	dart compile exe $(CLI_SRC) -o $(CLI_PATH)

format:
	dart fix --apply
	dart format lib test bin