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
  - [Intérêt de la factorisation de code (pour les modules locaux par exemple)](#intérêt-de-la-factorisation-de-code-pour-les-modules-locaux-par-exemple)
  - [Créer un module en respectant les "bonnes pratiques"](#créer-un-module-en-respectant-les-bonnes-pratiques)
- [Useful links](#useful-links)

<!--TOC-->

# Objectifs du TP
Comment, à quoi et pourquoi créer des modules Terraform au quotidien.
Qu'est-ce qu’un module, ou en trouver ds tout fait, structure, bonne pratiques.

=> Montrer l'intérêt d'éviter la répétition de code et de boucler sur l'appel d'un module
=> Montrer l'intérêt de grouper un ensemble de ressources étroitement liées dans un module pour leur déploiement
=> Montrer les différentes façon de référencer un module (local, git, registry communautaire)

# Pré-requis

## Collab
* Dernière version de terraform installée sur le poste
* terraform-docs d’installé sur leur machine
* Set up de git sur leur machine
* Maîtrise de l’assume rôle AWS fédéré et l’utiliser pour déployer les ressources à travers terraform

## Formateur
* Repo git pour que les collaborateurs puissent le fork pour l’avoir dans leur espace gitlab perso 
* Bout de code répétitif à refacto par les collabs
* Gitlab CI dans le README pour préparer le TP5 / ou dans un fichier qui ne va pas trigger les runners durant ce TP
* Énoncé dans le README

# Déroulé 

## Intérêt de la factorisation de code (pour les modules locaux par exemple)
=> Montrer un code avec des copier - coller de bout de code identiques 
=> Exercice : factoriser le code dans un module en local pour éviter cette répétition
=> EC2 + IAM + VOLUMES + SG
"Le nécessaire pour créer une simple EC2 bien configurée" (l’idée de rassembler un ensemble de ressources cohérentes au sein d’un même module)
Faire utiliser le module lambda (registry) pour la syntaxe

## Créer un module en respectant les "bonnes pratiques"
step 1 : Sortir le module local et le push sur le repo Gitlab ippon (espace perso)
step 2: modifier l’appel local par le remote git
step 3 : appliquer les bonnes pratiques 
versionning 
documentation (terraform-docs)
structure de fichier (variables, outputs, main, fixer la version des providers)

# Useful links 
- Doc de préparation de la formation terraform : https://docs.google.com/document/d/1UE8m4J_4Z66ZYg-gkjlobd-XGnDbmrtY6_uGOzW4Rpo/edit

