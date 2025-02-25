# Projet SQL S1

## ✨ Description
Ce projet SQL a pour but de centraliser et analyser des données commerciales. Il automatise l'importation des données, gère des offres commerciales, applique des seuils de prix dynamiques et génère des statistiques exploitables. Il inclut aussi un système de logs pour assurer la traçabilité des modifications.

## 📊 Fonctionnalités
- **Importation de données** depuis des fichiers CSV
- **Gestion des offres commerciales** (ajout, mise à jour, suppression)
- **Contrôle des prix** via des seuils définis par catégorie
- **Génération de statistiques** sur les magasins et leurs offres
- **Système de logs** pour suivre les modifications

## 🛠 Installation et utilisation
### 1. Exécution des scripts dans l'ordre :
```sql
1. Data.sql          -- Création des tables et insertion des données initiales
2. Aide_Import.sql   -- Importation des données depuis un fichier CSV
3. Thresholds.sql    -- Définition des seuils de prix
4. Main.sql          -- Traitement des offres et gestion des logs
5. Stats.sql         -- Génération des statistiques
```

### 2. Remarques importantes :
- **Si les seuils de prix sont modifiés**, exécuter `Thresholds.sql` à nouveau.
- **Après chaque nouvel import de données**, relancer `Stats.sql` pour mettre à jour les statistiques.

## 🔧 Ont été utilisées
- **SQL Server** pour le stockage et le traitement des données
- **BULK INSERT** pour l'importation rapide des fichiers CSV
- **Scripts dynamiques SQL** pour l'automatisation des processus

## 👨‍💻 Auteur
- [Axel Bouchaud-Roche](https://github.com/AxelBcr)	
- Encadré par [Clovis Deletre](https://github.com/ClovisDel)	

N'hésitez pas à contribuer ou poser des questions ! 🚀
