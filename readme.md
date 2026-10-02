# Statistiques L3 Psychologie

Supports de cours magistraux de statistiques pour la L3 Psychologie, réalisés avec [Quarto](https://quarto.org/) et Reveal.js.

Le dépôt contient les sources des cours, les assets nécessaires à leur compilation et des exports HTML/PDF.

## Cours disponibles

| Cours | Thème |
|:---:|:---:|
| Chapitre_00 | Organisation du cours |
| Chapitre_01 | Introduction aux statistiques inférentielles |
| Chapitre_02 | Bases de l’ANOVA |
| Chapitre_03 | ANOVA factorielle et ANCOVA |

## Compilation

```bash
quarto render
```

Pour prévisualiser un cours :

```bash
quarto preview cm01.qmd
```

## Structure

```text
cm00.qmd
cm01.qmd
cm02.qmd
cm03.qmd
assets/
exports/
scripts/
theme.scss
_quarto.yml
```

## Objectif pédagogique

Les cours présentent progressivement les tests statistiques à partir du **modèle linéaire**, avec un accent sur l’intuition statistique, les représentations graphiques, les tailles d’effet, l’interprétation et le report des résultats.

Les exemples sont principalement issus ou inspirés de la psychologie et de la neuropsychologie.

## Auteur

**Quentin Sénant**  
Université Grenoble Alpes

Les suggestions et signalements d’erreurs sont les bienvenus via les Issues GitHub, ou par contact mail à [quentin.senant@univ-grenoble-alpes.fr](quentin.senant@univ-grenoble-alpes.fr) ou [quentin.senant@laposte.net](quentin.senant@laposte.net).

## Réutilisation

Les sources sont rendues publiques afin de faciliter la consultation, la reproductibilité et la réutilisation pédagogique.

Si vous réutilisez une partie importante du matériel, une mention de la source et de l'auteur est vivement appréciée.

Les ressources provenant de publications, logiciels, institutions ou auteurs tiers conservent leurs droits et licences respectifs.

