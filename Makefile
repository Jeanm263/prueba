# Variables
SERVICE_NAME=holaflask
IMAGE_NAME=holaflask
REGISTRY=ghcr.io

.PHONY: build run logs stop rm down rebuild clean run-local build-multi publish test status start check help

# Construir la imagen Docker
build:
	docker build -t $(IMAGE_NAME) .

# Ejecutar el contenedor
run:
	docker run -d -p 5000:5000 --name $(SERVICE_NAME) $(IMAGE_NAME)

# Ver logs del servicio Flask
logs:
	docker logs -f $(SERVICE_NAME)

# Detener el contenedor
stop:
	docker stop $(SERVICE_NAME)

# Eliminar el contenedor
rm:
	docker rm $(SERVICE_NAME)

# Detener y eliminar
down: stop rm

# Reconstruir completamente el servicio
rebuild:
	docker stop $(SERVICE_NAME) || true
	docker rm $(SERVICE_NAME) || true
	docker build -t $(IMAGE_NAME) .
	docker run -d -p 5000:5000 --name $(SERVICE_NAME) $(IMAGE_NAME)

# Limpiar imágenes huérfanas
clean:
	docker system prune -f

# Ejecutar localmente sin Docker
run-local:
	python app.py

# Construir imagen para múltiples plataformas
build-multi:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE_NAME) .

# Publicar en GitHub Packages
publish:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(REGISTRY)/$(IMAGE_NAME):latest . --push

# Probar que el contenedor funciona correctamente
test:
	@echo "Probando el contenedor..."
	@timeout /t 3 >nul || sleep 3
	@curl -f http://localhost:5000 || echo "Error: El contenedor no responde"

# Ver estado del contenedor
status:
	@docker ps -a --filter name=$(SERVICE_NAME)

# Iniciar todo desde cero (build + run)
start: build run
	@echo "Contenedor iniciado. Prueba: http://localhost:5000"

# Verificar que todo está listo para Git
check:
	@echo "Verificando archivos..."
	@if exist app.py (echo [OK] app.py) else (echo [ERROR] Falta app.py)
	@if exist Dockerfile (echo [OK] Dockerfile) else (echo [ERROR] Falta Dockerfile)
	@if exist requirements.txt (echo [OK] requirements.txt) else (echo [ERROR] Falta requirements.txt)
	@if exist .gitignore (echo [OK] .gitignore) else (echo [ERROR] Falta .gitignore)
	@if exist .dockerignore (echo [OK] .dockerignore) else (echo [ERROR] Falta .dockerignore)
	@echo "Verificacion completa!"

# Ayuda
help:
	@echo "Comandos disponibles:"
	@echo "  make build       - Construir imagen Docker"
	@echo "  make run         - Ejecutar contenedor"
	@echo "  make start       - Build + Run en un comando"
	@echo "  make logs        - Ver logs del contenedor"
	@echo "  make status      - Ver estado del contenedor"
	@echo "  make test        - Probar que funciona"
	@echo "  make stop        - Detener contenedor"
	@echo "  make down        - Detener + Eliminar contenedor"
	@echo "  make rebuild     - Reconstruir todo"
	@echo "  make clean       - Limpiar imagenes huerfanas"
	@echo "  make check       - Verificar archivos para Git"
	@echo "  make publish     - Publicar en GHCR"
	@echo "  make run-local   - Ejecutar sin Docker"