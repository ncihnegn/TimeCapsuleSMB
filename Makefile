# TimeCapsuleSMB Makefile
#
# Prerequisites:
#   - macOS or Linux: Python 3 and smbclient for configure/deploy/doctor
#
# Quick start:
#   1) ./tcapsule bootstrap
#   2) .venv/bin/tcapsule configure
#   3) .venv/bin/tcapsule deploy
#   4) .venv/bin/tcapsule doctor
#
# Targets:
#   make install                 - install Python dependencies into .venv
#   make test                    - run C compile checks and Python pytest suite
#   make test-parallel           - run C compile checks and module-parallel test runner
#   make coverage                - run Python tests with coverage and show missing lines
#   make coverage-html           - write an HTML coverage report to htmlcov/
#   make test-c                  - compile-check mdns/nbns helper sources
#   make discover                - run tcapsule discover (depends on install)
#   make bootstrap-host          - run the host bootstrap helper
#   make set-ssh                 - advanced SSH toggle helper
#   make clean                   - remove the .venv directory

.PHONY: install test test-parallel coverage coverage-html test-c discover bootstrap-host set-ssh setup clean

install: 
	uv sync

test: install test-c
	uv run pytest

test-parallel: install test-c
	uv run pytest -n auto

coverage: install
	uv run coverage run -m pytest
	uv run coverage report

coverage-html: coverage
	uv run coverage html
	@echo "Open htmlcov/index.html to inspect line-by-line coverage."

test-c:
	cc -Wall -Wextra -Werror -o /tmp/mdns-advertiser-test build/mdns-advertiser.c
	cc -Wall -Wextra -Werror -o /tmp/nbns-advertiser-test build/nbns-advertiser.c

discover: install
	uv run tcapsule discover

bootstrap-host:
	./tcapsule bootstrap

set-ssh: install
	uv run tcapsule set-ssh

setup: install

clean:
	uv clean
