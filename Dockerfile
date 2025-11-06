# Imagen base de Python
FROM python:3.10-slim

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos los archivos del proyecto
COPY . .

# Instalamos las dependencias directamente
RUN pip install --no-cache-dir Flask

# Exponemos el puerto 5000
EXPOSE 5000

# Comando que ejecuta la app
CMD ["python", "app.py"]