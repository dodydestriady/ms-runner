# Makefile for microservice runner

prepare:
	@echo "Cloning product-service..."
	git clone git@github.com:dodydestriady/ms-product-service.git product-service
	@echo "Cloning order-service..."
	git clone git@github.com:dodydestriady/ms-order-service.git order-service

run:
	docker compose up -d --build

down:
	docker compose down -v

setup: prepare run