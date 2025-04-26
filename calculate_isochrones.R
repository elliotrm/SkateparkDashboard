# Script pour calculer et sauvegarder les isochrones des skateparks
# Ce script est à exécuter séparément avant de générer le dashboard

# Chargement des bibliothèques nécessaires
library(readxl)
library(sf)
library(dplyr)
library(opentripplanner)

# 1. Chargement des données
message("Chargement des données skateparks...")
skateparks <- read_excel("data/skateparks.xlsx", col_names = TRUE)
# Remplacement des virgules par des points et conversion en numérique
skateparks$Latitude <- as.numeric(gsub(",", ".", skateparks$Latitude))
skateparks$Longitude <- as.numeric(gsub(",", ".", skateparks$Longitude))

# Conversion en objet sf
skateparks_sf <- st_as_sf(skateparks, 
                         coords = c("Longitude", "Latitude"), 
                         crs = 4326)

# 2. Configuration d'OpenTripPlanner
message("Configuration d'OpenTripPlanner...")
# IMPORTANT: Modifiez ce chemin pour pointer vers votre dossier OTP
path_data <- "C:/Users/ellio/Desktop/Scolarite_etudes_supp/Rennes_M1/COURS/S2/Magistère Statistique Spatiale/Projet skatepark geo/Skateparkdashboard/OTP"
path_otp <- otp_dl_jar()  

# Vérification de Java
java_status <- otp_check_java()
if (!java_status) {
  stop("Java n'est pas correctement configuré. Veuillez installer/configurer Java avant de continuer.")
}

# 3. Démarrage du serveur OTP
message("Démarrage du serveur OTP...")
log1 <- otp_setup(otp = path_otp, dir = path_data)
# Connexion au serveur
otpcon <- otp_connect()

# 4. Calcul des isochrones pour chaque skatepark
message("Calcul des isochrones...")

results <- list()
for (i in 1:nrow(skateparks)) {
  message(paste("Traitement du spot", i, "sur", nrow(skateparks), ":", skateparks$Nom[i]))
  
  # Sélectionner les coordonnées du point
  single_point <- c(skateparks$Longitude[i], skateparks$Latitude[i])

  # Calcul des isochrones
  iso <- tryCatch({
    otp_isochrone(
      otpcon,
      fromPlace = single_point,
      mode = c("BICYCLE"),
      maxWalkDistance = 2000,
      date_time = as.POSIXct(strptime("2023-12-22 08:35", "%Y-%m-%d %H:%M")),
      cutoffSec = c(5, 7, 9, 11) * 60
    )
  }, error = function(e) {
    message(paste("Erreur pour le spot", i, "-", skateparks$Nom[i], ":", e$message))
    return(NULL)
  })
  
  # Si l'isochrone a été calculé avec succès
  if (!is.null(iso) && nrow(iso) > 0) {
    # Ajout des informations sur le temps en minutes
    iso$minutes <- iso$time / 60
    # Ajout d'une colonne avec le nom du skatepark
    iso$spot_name <- skateparks$Nom[i]
    iso$spot_type <- skateparks$Type[i]
    # Ajout du résultat à la liste
    results[[i]] <- iso
  }
}

# 5. Extraction de tous les isochrones de 7 minutes
message("Extraction des isochrones de 7 minutes...")
iso7min_list <- lapply(results, function(x) {
  if (!is.null(x) && nrow(x) > 0) {
    return(x[x$time == 420, ])  # 7 minutes = 420 secondes
  } else {
    return(NULL)
  }
})

# Filtrer les éléments NULL
iso7min_list <- iso7min_list[!sapply(iso7min_list, is.null)]
# Combiner en un seul objet sf si possible
if (length(iso7min_list) > 0) {
  iso7min <- do.call(rbind, iso7min_list)
} else {
  iso7min <- NULL
  warning("Aucun isochrone de 7 minutes n'a pu être calculé.")
}

# 6. Sauvegarde des résultats
message("Sauvegarde des résultats...")
# Créer un dossier pour les données si nécessaire
if (!dir.exists("data/isochrones")) {
  dir.create("data/isochrones", recursive = TRUE)
}

# Sauvegarde de tous les isochrones
saveRDS(results, "data/isochrones/all_isochrones.rds")
message("Tous les isochrones sauvegardés dans data/isochrones/all_isochrones.rds")

# Sauvegarde des isochrones de 7 minutes
if (!is.null(iso7min)) {
  saveRDS(iso7min, "data/isochrones/iso7min.rds")
  message("Isochrones de 7 minutes sauvegardés dans data/isochrones/iso7min.rds")
}

# 7. Arrêt du serveur OTP
message("Arrêt du serveur OTP...")
otp_stop()

message("Traitement terminé avec succès!")