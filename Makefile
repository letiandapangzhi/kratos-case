# 变量定义
SERVICE_NAME ?= $(error [请显式传递 SERVICE_NAME 变量! 用法: make xxx SERVICE_NAME=xxx])
REGISTRY ?= localhost:5000
VERSION ?= $(or $(shell git describe --tags --always 2>/dev/null), $(error [请显式传递 VERSION 变量! 用法: make xxx VERSION=xxx]))

# 调试输出
.PHONY: print
print:
	@echo "REGISTRY: $(REGISTRY)"
	@echo "VERSION: $(VERSION)"
	@echo "SERVICE_NAME: $(SERVICE_NAME)"


.PHONY: new_mono
# 执行 shell 脚本（新服务创建）
SERVICE_NAME ?= demo
new_mono:
	@echo ">> 创建新服务 $(SERVICE_NAME)"; \
	export FROM_MAKEFILE=1; \
	bash ./template/new_mono_repo.sh $(SERVICE_NAME)