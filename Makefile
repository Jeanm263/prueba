# Variables
SERVICE_NAME=holaflask
IMAGE_NAME=holaflask
REGISTRY=ghcr.io

# Construir la imagen
build:
	docker compose build

# Levantar todos los servicios
up:
	docker compose up -d

# Ver logs del servicio Flask
logs:
	docker compose logs -f $(SERVICE_NAME)

# Ver logs de Traefik
traefik-logs:
	docker compose logs -f traefik

# Detener los contenedores
down:
	docker compose down

# Reconstruir completamente el servicio
rebuild: down build up

# Limpiar imágenes huérfanas
clean:
	docker system prune -f

# Ver el dashboard de Traefik
dashboard:
	echo "Abre tu navegador en http://localhost:8080"

# Construir imagen para múltiples plataformas
build-multi:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE_NAME) -f Dockerfile.multi .

# Publicar en GitHub Packages
publish:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(REGISTRY)/$(IMAGE_NAME):latest -f Dockerfile.multi . --push