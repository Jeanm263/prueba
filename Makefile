# Variables
SERVICE_NAME=holaflask

# Construir la imagen
build:
	docker compose build

# Levantar el servicio
up:
	docker compose up -d

# Ver logs del servicio
logs:
	docker compose logs -f $(SERVICE_NAME)

# Detener los contenedores
down:
	docker compose down

# Reconstruir completamente el servicio
rebuild: down build up

# Limpiar imágenes huérfanas
clean:
	docker system prune -f