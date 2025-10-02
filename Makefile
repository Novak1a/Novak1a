.PHONY: help start stop restart logs ps backup restore clean start-wydapp start-maximemarc start-futurcode start-bot start-n8n stop-wydapp stop-maximemarc stop-futurcode stop-bot stop-n8n logs-wydapp logs-maximemarc logs-futurcode logs-bot logs-n8n

# Couleurs pour l'affichage
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

help: ## Afficher cette aide
	@echo "${GREEN}=== Infrastructure Docker Multi-Environnements ===${RESET}"
	@echo ""
	@echo "${YELLOW}Commandes disponibles:${RESET}"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  ${GREEN}%-20s${RESET} %s\n", $$1, $$2}'
	@echo ""

# ===== COMMANDES GLOBALES =====

start: ## Démarrer tous les environnements
	@echo "${GREEN}🚀 Démarrage de tous les environnements...${RESET}"
	@cd 1-react-vite && docker compose up -d
	@cd 2-symfony-react-stack && docker compose up -d
	@cd 3-symfony-react-stack-bis && docker compose up -d
	@cd 4-discord-bot && docker compose up -d
	@cd 5-n8n && docker compose up -d
	@echo "${GREEN}✅ Tous les environnements sont démarrés${RESET}"

stop: ## Arrêter tous les environnements
	@echo "${YELLOW}⏸️  Arrêt de tous les environnements...${RESET}"
	@cd 1-react-vite && docker compose down
	@cd 2-symfony-react-stack && docker compose down
	@cd 3-symfony-react-stack-bis && docker compose down
	@cd 4-discord-bot && docker compose down
	@cd 5-n8n && docker compose down
	@echo "${GREEN}✅ Tous les environnements sont arrêtés${RESET}"

restart: stop start ## Redémarrer tous les environnements

logs: ## Afficher les logs de tous les services
	@echo "${GREEN}📋 Logs de tous les environnements${RESET}"
	@cd 1-react-vite && docker compose logs --tail=50 -f &
	@cd 2-symfony-react-stack && docker compose logs --tail=50 -f &
	@cd 3-symfony-react-stack-bis && docker compose logs --tail=50 -f &
	@cd 4-discord-bot && docker compose logs --tail=50 -f &
	@cd 5-n8n && docker compose logs --tail=50 -f

ps: ## Voir l'état des containers
	@echo "${GREEN}📊 État des containers${RESET}"
	@echo "\n${YELLOW}=== 1. React Vite (wydapp.fr) ===${RESET}"
	@cd 1-react-vite && docker compose ps
	@echo "\n${YELLOW}=== 2. Stack 1 (maximemarc.com) ===${RESET}"
	@cd 2-symfony-react-stack && docker compose ps
	@echo "\n${YELLOW}=== 3. Stack 2 (futurcode.com) ===${RESET}"
	@cd 3-symfony-react-stack-bis && docker compose ps
	@echo "\n${YELLOW}=== 4. Discord Bot ===${RESET}"
	@cd 4-discord-bot && docker compose ps
	@echo "\n${YELLOW}=== 5. N8N (n8n.maximemarc.com) ===${RESET}"
	@cd 5-n8n && docker compose ps

# ===== ENVIRONNEMENTS INDIVIDUELS =====

start-wydapp: ## Démarrer React Vite (wydapp.fr)
	@echo "${GREEN}🚀 Démarrage de React Vite...${RESET}"
	@cd 1-react-vite && docker compose up -d
	@echo "${GREEN}✅ React Vite démarré: https://wydapp.fr${RESET}"

stop-wydapp: ## Arrêter React Vite
	@cd 1-react-vite && docker compose down

logs-wydapp: ## Logs React Vite
	@cd 1-react-vite && docker compose logs -f

start-maximemarc: ## Démarrer Stack 1 (maximemarc.com)
	@echo "${GREEN}🚀 Démarrage de Stack 1...${RESET}"
	@cd 2-symfony-react-stack && docker compose up -d
	@echo "${GREEN}✅ Stack 1 démarrée: https://maximemarc.com${RESET}"

stop-maximemarc: ## Arrêter Stack 1
	@cd 2-symfony-react-stack && docker compose down

logs-maximemarc: ## Logs Stack 1
	@cd 2-symfony-react-stack && docker compose logs -f

start-futurcode: ## Démarrer Stack 2 (futurcode.com)
	@echo "${GREEN}🚀 Démarrage de Stack 2...${RESET}"
	@cd 3-symfony-react-stack-bis && docker compose up -d
	@echo "${GREEN}✅ Stack 2 démarrée: https://futurcode.com${RESET}"

stop-futurcode: ## Arrêter Stack 2
	@cd 3-symfony-react-stack-bis && docker compose down

logs-futurcode: ## Logs Stack 2
	@cd 3-symfony-react-stack-bis && docker compose logs -f

start-bot: ## Démarrer Discord Bot
	@echo "${GREEN}🚀 Démarrage du Bot Discord...${RESET}"
	@cd 4-discord-bot && docker compose up -d
	@echo "${GREEN}✅ Bot Discord démarré${RESET}"

stop-bot: ## Arrêter Discord Bot
	@cd 4-discord-bot && docker compose down

logs-bot: ## Logs Discord Bot
	@cd 4-discord-bot && docker compose logs -f

start-n8n: ## Démarrer N8N (n8n.maximemarc.com)
	@echo "${GREEN}🚀 Démarrage de N8N...${RESET}"
	@cd 5-n8n && docker compose up -d
	@echo "${GREEN}✅ N8N démarré: https://n8n.maximemarc.com${RESET}"

stop-n8n: ## Arrêter N8N
	@cd 5-n8n && docker compose down

logs-n8n: ## Logs N8N
	@cd 5-n8n && docker compose logs -f

# ===== MAINTENANCE =====

backup: ## Backup toutes les bases de données
	@echo "${GREEN}💾 Backup des bases de données...${RESET}"
	@bash scripts/backup-databases.sh

restore: ## Restaurer les bases de données (Usage: make restore BACKUP_DATE=2025-10-02)
	@echo "${GREEN}♻️  Restauration des bases de données...${RESET}"
	@bash scripts/restore-databases.sh $(BACKUP_DATE)

clean: ## Nettoyer les volumes inutilisés
	@echo "${YELLOW}⚠️  Nettoyage des volumes Docker...${RESET}"
	@docker volume prune -f
	@echo "${GREEN}✅ Nettoyage terminé${RESET}"

# ===== MONITORING =====

start-monitoring: ## Démarrer Grafana + Loki
	@echo "${GREEN}📊 Démarrage du monitoring...${RESET}"
	@cd monitoring && docker compose up -d
	@echo "${GREEN}✅ Monitoring accessible: http://localhost:3000${RESET}"

stop-monitoring: ## Arrêter Grafana + Loki
	@cd monitoring && docker compose down

# ===== DÉVELOPPEMENT =====

build: ## Rebuild tous les containers
	@echo "${GREEN}🔨 Rebuild de tous les containers...${RESET}"
	@cd 1-react-vite && docker compose build
	@cd 2-symfony-react-stack && docker compose build
	@cd 3-symfony-react-stack-bis && docker compose build
	@cd 4-discord-bot && docker compose build
	@cd 5-n8n && docker compose build

prune: ## Nettoyer Docker (containers, images, volumes)
	@echo "${YELLOW}⚠️  Nettoyage complet Docker...${RESET}"
	@docker system prune -af --volumes
	@echo "${GREEN}✅ Nettoyage terminé${RESET}"