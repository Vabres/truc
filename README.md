# TP4 - Modules terraform

# Table of content
<!--TOC-->

- [TP4 - Modules terraform](#tp4---modules-terraform)
- [Table of content](#table-of-content)
- [Objectifs du TP](#objectifs-du-tp)
- [Pré-requis](#pré-requis)
  - [Collab](#collab)
  - [Formateur](#formateur)
- [Déroulé](#déroulé)
  - [1. Intérêt de la factorisation de code (pour les modules locaux par exemple)](#1-intérêt-de-la-factorisation-de-code-pour-les-modules-locaux-par-exemple)
  - [2. Créer un module en respectant les "bonnes pratiques"](#2-créer-un-module-en-respectant-les-bonnes-pratiques)
- [Useful links](#useful-links)

<!--TOC-->

# Objectifs du TP
- => Montrer l'intérêt d'éviter la répétition de code et de boucler sur l'appel d'un module
- => Montrer l'intérêt de grouper un ensemble de ressources étroitement liées dans un module pour leur déploiement
- => Montrer les différentes façon de référencer un module (local, git, registry communautaire)
- => Mettre en lumière les pièges à éviter

# Pré-requis

## Collab
- Set up de git sur leur machine
- terraform-docs d’installé sur leur machine
- Version de terraform conseillée pour la compatibilité des exercices : ~> 1.0
- Maîtrise de l’assume rôle AWS fédéré et l’utiliser pour déployer les ressources à travers terraform

## Formateur
- Repo git pour que les collaborateurs puissent le fork pour l’avoir dans leur espace gitlab perso 
- Bout de code répétitif à refacto par les collabs
- Gitlab CI dans le README pour préparer le TP5 / ou dans un fichier qui ne va pas trigger les runners durant ce TP
- Énoncé dans le README

# Déroulé 

## 1. Intérêt de la factorisation de code (pour les modules locaux par exemple)
- => Montrer un code avec des copier - coller de bout de code identiques 
- => Exercice : factoriser le code dans un module **local** pour éviter cette répétition

Prendre l'exemple du refacto d'un déploiement du nécessaire pour créer une simple EC2 bien configurée (l’idée de rassembler un ensemble de ressources cohérentes au sein d’un même module) => EC2 + IAM + VOLUMES + SG

## 2. Créer un module en respectant les "bonnes pratiques"
- Step 1 : Sortir le module local et le push sur le repo gitlab ippon (espace perso)
- Step 2 : modifier l’appel local par le remote git
- Step 3 : appliquer les bonnes pratiques 
  - versionning 
  - documentation (terraform-docs)
  - structure de fichier (variables, outputs, main, fixer la version des providers)

# Useful links
- Doc de préparation de la formation terraform : https://docs.google.com/document/d/1UE8m4J_4Z66ZYg-gkjlobd-XGnDbmrtY6_uGOzW4Rpo/edit