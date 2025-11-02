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

test-summary:
	@echo "Running K6 with summary output..."
	@HOST=$$(if [ "$(OS)" = "Linux" ]; then echo http://localhost; else echo http://host.docker.internal; fi) && \
	docker run --rm -i \
		-e HOST=$$HOST \
		-v $$(pwd):/k6 \
		loadimpact/k6 run --summary-time-unit=ms /k6/load-test.js

setup: prepare run