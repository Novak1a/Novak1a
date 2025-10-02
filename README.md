# 🚀 Infrastructure Docker Multi-Environnements

Infrastructure complète avec 5 environnements Docker pour la production.

## 📋 Environnements

| Environnement | Domaine | Stack | Statut |
|--------------|---------|-------|--------|
| **React Vite** | wydapp.fr | React + Vite + Caddy | 🟢 |
| **Stack 1** | maximemarc.com | Symfony + React + MariaDB + Redis + Caddy | 🟢 |
| **Stack 2** | futurcode.com | Symfony + React + MariaDB + Redis + Caddy | 🟢 |
| **Bot Discord** | - | Node.js + discord.js + MariaDB | 🟢 |
| **N8N** | n8n.maximemarc.com | N8N + MariaDB + Caddy | 🟢 |

## 🛠️ Prérequis

- Docker Engine 24.x ou supérieur
- Docker Compose v2.x ou supérieur
- Git
- Make (optionnel mais recommandé)
- Serveur avec au moins 8GB RAM
- Domaines configurés pointant vers votre serveur

## 🚀 Installation Rapide

### 1. Cloner le repository

```bash
git clone https://github.com/Novak1a/Novak1a.git
cd Novak1a
```

### 2. Configurer les variables d'environnement

```bash
# Copier le fichier global
cp .env.global.example .env.global

# Configurer chaque environnement
cp 1-react-vite/.env.example 1-react-vite/.env
cp 2-symfony-react-stack/.env.example 2-symfony-react-stack/.env
cp 3-symfony-react-stack-bis/.env.example 3-symfony-react-stack-bis/.env
cp 4-discord-bot/.env.example 4-discord-bot/.env
cp 5-n8n/.env.example 5-n8n/.env
```

### 3. Éditer les fichiers .env avec vos valeurs

### 4. Démarrer tous les environnements

```bash
make start
# ou
docker compose up -d
```

## 📦 Commandes Makefile

```bash
make help              # Afficher l'aide
make start             # Démarrer tous les environnements
make stop              # Arrêter tous les environnements
make restart           # Redémarrer tous les environnements
make logs              # Afficher les logs
make ps                # Voir les containers actifs

# Commandes par environnement
make start-wydapp      # Démarrer React Vite
make start-maximemarc  # Démarrer Stack 1
make start-futurcode   # Démarrer Stack 2
make start-bot         # Démarrer Discord Bot
make start-n8n         # Démarrer N8N

# Maintenance
make backup            # Backup toutes les BDD
make restore           # Restaurer les BDD
make clean             # Nettoyer les volumes
```

## 🌐 Configuration DNS

Configurez vos enregistrements DNS :

```
A    wydapp.fr                 → VOTRE_IP_SERVEUR
A    maximemarc.com            → VOTRE_IP_SERVEUR
A    futurcode.com             → VOTRE_IP_SERVEUR
A    n8n.maximemarc.com        → VOTRE_IP_SERVEUR
```

## 🔒 SSL/HTTPS

Les certificats SSL Let's Encrypt sont générés automatiquement par Caddy.

**Email configuré:** contact@maximemarc.com

Caddy s'occupe automatiquement de :
- Génération des certificats
- Renouvellement automatique
- Redirection HTTP → HTTPS

## 📊 Monitoring avec Grafana

Accéder au monitoring :

```bash
cd monitoring
docker compose up -d
```

Grafana sera disponible sur `http://localhost:3000`
- User: `admin`
- Password: voir `.env` dans `monitoring/`

## 💾 Backup et Restauration

### Backup automatique

```bash
# Backup toutes les bases de données
make backup

# Les backups sont stockés dans /var/docker-data/backups/
```

### Restauration

```bash
# Restaurer depuis un backup
make restore BACKUP_DATE=2025-10-02
```

## 📁 Structure du Projet

```
.
├── 1-react-vite/              # React + Vite + Caddy
├── 2-symfony-react-stack/     # Stack complète Symfony
├── 3-symfony-react-stack-bis/ # Stack complète Symfony (site 2)
├── 4-discord-bot/             # Bot Discord
├── 5-n8n/                     # N8N Workflow automation
├── monitoring/                # Grafana + Loki
├── scripts/                   # Scripts utilitaires
├── .github/workflows/         # CI/CD GitHub Actions
├── docker-compose.yml         # Orchestrateur principal
├── Makefile                   # Commandes simplifiées
└── README.md                  # Ce fichier
```

## 🔧 Détails des Environnements

### 1. React Vite (wydapp.fr)

Application React frontend simple avec Vite.

**Services:**
- Frontend (Node.js 22)
- Caddy (reverse proxy + HTTPS)

**Démarrage:**
```bash
cd 1-react-vite
docker compose up -d
```

### 2. Stack 1 (maximemarc.com)

Stack complète Symfony + React.

**Services:**
- Backend Symfony (PHP 8.3)
- Frontend React (Node.js 22)
- MariaDB 11.x
- Redis 7.x (cache + queue)
- Caddy (reverse proxy)

**Configuration Redis:**
- Cache Symfony: `redis://redis:6379/0`
- Messenger Queue: `redis://redis:6379/1`

### 3. Stack 2 (futurcode.com)

Identique à Stack 1 mais pour un projet différent.

### 4. Bot Discord

Bot Discord avec base de données dédiée.

**Services:**
- Bot Node.js (discord.js)
- MariaDB dédiée

**Accès API:** Le bot peut appeler l'API de maximemarc.com

### 5. N8N (n8n.maximemarc.com)

Plateforme d'automatisation de workflows.

**Services:**
- N8N (dernière version)
- MariaDB
- Caddy

**Authentification activée**
**Webhooks accessibles publiquement**

## 🔐 Sécurité

### Bonnes pratiques appliquées:

✅ Containers non-root  
✅ Secrets via variables d'environnement  
✅ Réseau Docker isolé (app_network)  
✅ Healthchecks sur tous les services  
✅ Rotation des logs  
✅ Limites de ressources (CPU/RAM)  

### Fichiers sensibles à ne JAMAIS commiter:

- `.env`
- `.env.local`
- `secrets/`
- `backups/`

## 🚨 Troubleshooting

### Les certificats SSL ne se générent pas

```bash
# Vérifier les logs Caddy
docker compose logs caddy

# Vérifier que les DNS pointent correctement
dig wydapp.fr
```

### Un service ne démarre pas

```bash
# Voir les logs du service
docker compose logs nom_service

# Vérifier la santé des containers
docker compose ps
```

### Base de données corrompue

```bash
# Restaurer depuis un backup
make restore BACKUP_DATE=2025-10-01
```

## 📚 Documentation Supplémentaire

- [Caddy Documentation](https://caddyserver.com/docs)
- [Docker Documentation](https://docs.docker.com)
- [N8N Documentation](https://docs.n8n.io)
- [Symfony Documentation](https://symfony.com/doc)

## 🤝 Contribution

Pour contribuer à ce projet :

1. Créer une branche depuis `main`
2. Faire vos modifications
3. Tester localement
4. Ouvrir une Pull Request

## 📝 Licence

Projet privé - Tous droits réservés

## 👤 Auteur

**Novak1a**
- GitHub: [@Novak1a](https://github.com/Novak1a)

## 📞 Support

Pour toute question : contact@maximemarc.com

---

**Dernière mise à jour:** 2025-10-02