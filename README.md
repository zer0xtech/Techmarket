# TechMarket

**TechMarket** est une plateforme web d'achat et de revente de matériel high-tech d'occasion, développée en **PHP / MySQL**. Les annonces sont modérées (manuellement par l'équipe, avec l'aide d'une **IA locale via Ollama**) avant d'être publiées.

---

## Fonctionnalités

### Utilisateurs
- Inscription / connexion / déconnexion
- Consultation et modification du profil
- Publication d'annonces avec upload de plusieurs photos
- Consultation de ses propres annonces et de leur statut (`en_attente`, `validee`, `refusee`)
- Gestion des **favoris** (ajout / retrait)

### Catalogue
- Recherche par mots-clés (titre et description)
- Filtres : catégorie, sous-catégorie (liste dynamique en JavaScript), prix min/max, ville, état
- Tri : plus récentes, plus anciennes, prix croissant, prix décroissant
- Seules les annonces **validées** sont visibles publiquement

### Intelligence artificielle (Ollama)
- **Aide à la rédaction** : deux modes de publication
  - *Mode classique* : l'IA réécrit la description saisie par l'utilisateur
  - *Mode assisté* : l'utilisateur remplit un formulaire (marque, modèle, état, année, etc.) et l'IA génère la description
- **Aide à la modération** : l'IA analyse l'annonce et renvoie un JSON (contenu inapproprié, orthographe, catégorisation, prix anormal, détection des produits hors-sujet) avec une décision recommandée (`validation`, `refus`, `validation_avec_modifications`)

### Espace d'administration / modération
- Modération des annonces (valider / refuser)
- Visualisation de toutes les annonces
- Gestion des utilisateurs : changement de rôle, blocage / déblocage, suppression
- Gestion des catégories et sous-catégories
- Graphiques d'évolution (annonces et inscriptions sur 30 jours) avec **Chart.js**

### Rôles
| Rôle | Droits |
|------|--------|
| `utilisateur` | Publier, gérer ses annonces et favoris |
| `moderateur` | Modérer les annonces |
| `administrateur` | Accès complet (utilisateurs, catégories, statistiques) |

---

## Stack technique

- **Back-end** : PHP (PDO)
- **Base de données** : MySQL / MariaDB
- **Front-end** : HTML, CSS (`style_web.css`), JavaScript
- **Graphiques** : [Chart.js](https://www.chartjs.org/)
- **IA** : [Ollama](https://ollama.com/) avec le modèle `qwen2.5:3b`
- **Icônes** : Material Symbols (Google Fonts)

---

## Structure du projet

```
.
├── index.php                  # Accueil + recherche / filtres
├── login_web.php              # Connexion
├── inscription_web.php        # Inscription
├── logout_web.php             # Déconnexion
├── datab_web.php              # Connexion PDO + session
├── consultation_profil.php    # Profil utilisateur
├── modification_profil.php    # Modification du profil
├── mes_annonces.php           # Annonces de l'utilisateur
├── publication_web.php        # Publication (formulaire classique)
├── publication_web_ia.php     # Publication avec assistance IA
├── ia_moderation.php          # Analyse d'annonces via Ollama
├── affiche_catalogue.php      # Catalogue par catégorie
├── favoris.php                # Liste des favoris
├── ajout_favoris.php          # Ajout d'un favori
├── dashboard_admin.php        # Modération des annonces
├── visualisation_posts.php    # Toutes les annonces (admin)
├── gestion_personnes.php      # Gestion des utilisateurs (admin)
├── gestion_categories.php     # Gestion des catégories (admin)
├── graphes_stats.php          # Statistiques (admin)
├── data/user_test.php         # Fonctions métier (login, inscription, publication...)
├── includes/navbar.php        # Barre de navigation
├── images/                    # Logos
└── style_web.css              # Feuille de style
```

---

## Base de données

Base : `techmarket`

| Table | Colonnes principales |
|-------|----------------------|
| `users` | `id`, `nom`, `prenom`, `email`, `phone`, `ville`, `password`, `role`, `blocked`, `date_inscription` |
| `annonces` | `id`, `user_id`, `titre`, `description`, `prix`, `categorie`, `sous_categorie`, `etat`, `ville`, `url_photo`, `statut`, `motif_refus`, `creation_date` |
| `categories` | `id`, `nom`, `parent_id` (`NULL` = catégorie principale) |
| `favoris` | `id`, `id_annonce`, `id_user` |

Valeurs de `annonces.statut` : `en_attente`, `validee`, `refusee`.

---

## Installation

### Prérequis
- PHP 8+ (extensions `pdo_mysql` et `curl`)
- MySQL / MariaDB
- Un serveur local (XAMPP, WAMP, MAMP, Laragon ou `php -S`)
- [Ollama](https://ollama.com/download) (pour les fonctionnalités IA)

### Étapes

1. **Cloner le dépôt**
   ```bash
   git clone https://github.com/zer0xtech/techmarket.git
   cd techmarket
   ```

2. **Créer la base de données**
   ```sql
   CREATE DATABASE techmarket CHARACTER SET utf8 COLLATE utf8_general_ci;
   ```
   Puis importer le fichier SQL du projet.

3. **Configurer la connexion** dans `datab_web.php` :
   ```php
   new PDO('mysql:host=127.0.0.1;dbname=techmarket;charset=utf8', 'root', '');
   ```

4. **Installer et lancer Ollama**
   ```bash
   ollama pull qwen2.5:3b
   ollama serve
   ```
   L'API doit être accessible sur `http://localhost:11434`.

5. **Lancer le projet**
   ```bash
   php -S localhost:8000
   ```
   Puis ouvrir [http://localhost:8000](http://localhost:8000).

---

## Limites connues / pistes d'amélioration

- Hasher les mots de passe avec `password_hash()` / `password_verify()`
- Ajouter des jetons CSRF sur les formulaires POST (suppression, changement de rôle, etc.)
- Utiliser des identifiants de base de données dédiés plutôt que `root` sans mot de passe
- Protéger les actions de modération (vérification du rôle côté serveur sur toutes les pages)
- Vérifier que l'annonce ajoutée en favori existe et possède bien le statut `validee`
- Pages de détail d'annonce et de suppression de favoris à finaliser

