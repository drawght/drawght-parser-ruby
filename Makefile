SHELL = /bin/bash
.PHONY: test
.SILENT:

ruby = $(shell command -v ruby)
file ?= test/*_test.rb

test.files = $(wildcard test/*_test.rb)
test.execute = $(ruby) ${file} --verbose --backtrace --fail-fast --defer-output

#? $ make help
#? - Show this message of usage.
help:
	grep -ir "^#?" Makefile | cut -c4-

#? $ make tests
#? - Execute all tests.
tests:
	$(foreach file, ${test.files}, $(test.execute);)

#? $ make test file=<FILE>
#? - Execute only test file FILE.
test:
	$(test.execute)
