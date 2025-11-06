# Variables
SERVICE_NAME=holaflask

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