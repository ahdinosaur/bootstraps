.PHONY: generate gen

generate gen:
	cfgen --verbose config.yaml && ./repair-executables
