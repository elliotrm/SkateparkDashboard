# Analyse statistique spatiale des skateparks de Rennes

## Contexte et objectif

Ce projet a été réalisé dans le cadre d'un Master 1 (M1) du Magistère Sciences et Management de l'Environnement (SME). L'objectif principal de ce projet est de réaliser une analyse statistique spatiale des skateparks et street spots de la ville de Rennes. L'analyse porte notamment sur l'accessibilité à ces infrastructures via des isochrones, la densité spatiale des spots existants, ainsi que l'optimisation de l'implantation de nouveaux skateparks. L'outil principal utilisé est **R**, avec les packages `sf`, `tmap`, et `spatstat`.

## Fonctionnement du projet

Le projet nécessite de calculer des isochrones pour modéliser l'accessibilité aux skateparks en fonction du temps de trajet à vélo. Ces isochrones sont ensuite analysés pour identifier les zones sous-desservies et potentiellement intéressantes pour l'implantation de nouveaux skateparks. En plus des isochrones, des analyses de densité spatiale et de la fonction K de Ripley sont réalisées pour mieux comprendre la répartition des skateparks dans la ville.

## Installation et prérequis

1. **Installer Java** :  
   Le calcul des isochrones nécessite l'utilisation de l'outil [Open Trip Planner (OTP)](http://www.openstreetmap.org) qui est basé sur Java. Il est donc nécessaire d'installer une version compatible de Java. La version recommandée est **Java 11**, mais la version spécifique sera indiquée dans les fichiers de configuration.

2. **Créer un dossier pour les fichiers de sortie** :  
   Pour le bon fonctionnement du calcul des isochrones, il est essentiel de créer le dossier suivant où seront enregistrés les fichiers nécessaires :  OTP/graphs/default

Ce dossier sera utilisé pour stocker les graphes et autres fichiers intermédiaires générés lors du calcul des isochrones.

3. **Installation des packages R nécessaires** :  
Ce projet utilise plusieurs bibliothèques R pour l'analyse spatiale et la visualisation des données, telles que `sf`, `tmap`, et `spatstat`. Assurez-vous d'installer les dépendances suivantes dans R :
```R
install.packages(c("sf", "tmap", "spatstat", "dplyr"))
```

## Fonctionnement du calcul des isochrones

Le calcul des isochrones se fait en utilisant les données géographiques de Rennes et en appliquant le modèle de temps de trajet à vélo. Le processus comprend plusieurs étapes :

1. **Préparation des données** :  
   Les données géographiques des skateparks, des IRIS de Rennes et d'autres éléments pertinents (comme les pharmacies et la population jeune) sont importées et préparées dans R.

2. **Calcul des isochrones** :  
   Utilisation d'un outil comme **Open Trip Planner (OTP)** pour calculer les isochrones. Ce processus génère des zones représentant les distances accessibles à vélo dans un certain délai, par exemple 7 minutes, 9 minutes, etc.

3. **Exportation des résultats** :  
   Les résultats des isochrones sont enregistrés dans des fichiers dans le dossier `OTP/graphs/default`, prêts à être utilisés pour les analyses suivantes.

4. **Visualisation des isochrones** :  
   Les isochrones sont ensuite visualisés sur des cartes interactives et statiques, ce qui permet de mieux comprendre les zones accessibles dans un temps de trajet donné.

## Visualisations et analyse

Les résultats des calculs sont présentés sous forme de cartes interactives et statiques pour illustrer l'accessibilité des skateparks à Rennes. Ces cartes montrent les isochrones pour différents temps de trajet et permettent de visualiser les zones sous-desservies ou les zones d'attrait pour de nouveaux skateparks.

### Cartes des isochrones

Les isochrones sont visualisées avec la librairie `tmap` dans R, ce qui permet de montrer les zones accessibles par vélo dans différents intervalles de temps. Ces cartes permettent d'analyser la couverture actuelle et de déterminer les zones qui pourraient bénéficier d'un nouvel équipement.

### Densité spatiale et fonction K de Ripley

En plus des isochrones, une analyse de la densité spatiale des skateparks et des résultats de la fonction K de Ripley sont utilisés pour évaluer la distribution des skateparks à travers la ville. Cette analyse permet de détecter des tendances d'agrégation spatiale, en observant si les skateparks sont concentrés dans certaines zones ou dispersés de manière aléatoire.

## Justification des nouveaux emplacements

Sur la base des résultats de l'analyse spatiale, de nouveaux skateparks sont proposés dans des zones spécifiques de Rennes qui présentent des caractéristiques démographiques favorables, telles qu'une forte population jeune ou un manque d'infrastructures sportives.

### Skatepark de Beauregard

- Zone avec forte population jeune (0-19 ans)
- Absence actuelle de skatepark dans le quartier
- Proximité de gymnases et d'autres infrastructures sportives
- Complète la couverture au nord-ouest de Rennes, actuellement sous-équipée

### Skatepark de Canada

- Quartier en développement avec une population jeune croissante
- Proximité des pharmacies et d'autres services essentiels
- Renforce l'offre dans le sud de Rennes
- Permet une meilleure répartition spatiale des skateparks dans la ville

Ces emplacements ont été choisis en tenant compte des résultats des isochrones et des données démographiques et sociales, visant à optimiser la couverture des skateparks tout en répondant aux besoins des usagers.

## Structure des fichiers

Le projet suit la structure suivante :

/
├── OTP/
│   └── graphs/
│       └── default/     Dossier pour les fichiers OTP
├── data/                Données géographiques (skateparks, iris, etc.)
├── scripts/             Scripts R pour l'analyse
├── output/              Cartes et résultats des analyses
└── README.md            Documentation du projet


## Conclusion

Ce projet offre une analyse spatiale approfondie de l'accessibilité aux skateparks à Rennes, fournissant des éléments utiles pour l'urbanisme et l'aménagement des infrastructures sportives en ville. Les résultats et la méthodologie peuvent être utilisés pour planifier des implantations futures et optimiser l'accès aux sports de glisse dans la ville.


