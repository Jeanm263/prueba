STACK_NAME=db_stack

.PHONY: help
help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo "  deploy      to deploy the stack"
	@echo "  ps          to show stack services"
	@echo "  logs        to view postgres service logs"
	@echo "  rm          to remove the stack"
	@echo "  networks    to list networks"
	@echo "  volumes     to list volumes"
	@echo "  build       to build the Flask app image"

build:
	docker build -t flask-app:latest .

deploy:
	docker stack deploy -c stack.yml $(STACK_NAME)

ps:
	docker stack ps $(STACK_NAME)

logs:
	docker service logs $(STACK_NAME)_postgres -f

rm:
	docker stack rm $(STACK_NAME)

networks:
	docker network ls

volumes:
	docker volume ls