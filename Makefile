# ---------
# Variables
# ---------
DEV_COMPOSE = docker-compose.dev.yml
PROD_COMPOSE = docker-compose.prod.yml

# -------------
# Dev Commands
# -------------
dev-up:
	docker compose -f $(DEV_COMPOSE) up

dev-up-d:
	docker compose -f $(DEV_COMPOSE) up -d

dev-down:
	docker compose -f $(DEV_COMPOSE) down

dev-shell:
	docker compose -f $(DEV_COMPOSE) exec modern-web-lab-dev sh


# ----------------
# Production Build
# ----------------
prod-build:
	docker compose -f $(PROD_COMPOSE) build

prod-up:
	docker compose -f $(PROD_COMPOSE) up

prod-up-d:
	docker compose -f $(PROD_COMPOSE) up -d

prod-down:
	docker compose -f $(PROD_COMPOSE) down

prod-logs:
	docker compose -f $(PROD_COMPOSE) logs -f


# ---------------
# Cleanup helpers
# ---------------
clean-images:
	docker image prune -f

clean-all:
	docker system prune -a