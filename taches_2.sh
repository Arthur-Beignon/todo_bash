#!/bin/bash

fichier_csv="taches.csv"

if [ ! -f "$fichier_csv" ]
then
    echo "ID;TACHE;PRIORITE;DUREE;CATEGORIE;ECHEANCE;STATUT" > "$fichier_csv"
    echo "1;Exemple de tâche;haute;3;projet;2025-12-17;pas commencée" >> "$fichier_csv"
fi

while true
do
    echo ""
    echo "---------------------------------"
    echo "Menu:"
    echo "1. Ajouter une tâche"
    echo "2. Lister les tâches trié"
    echo "3. Modifier une tâche"
    echo "4. Quitter"
    echo "Choisissez une option (ex : 1) : "
    read choix

    if [ "$choix" -eq 1 ]
    then
        derniere_ligne=$(tail -n 1 "$fichier_csv")
        dernier_id=$(echo "$derniere_ligne" | cut -d';' -f1)
        id=$((dernier_id + 1))

        echo "Description : "
        read tache
        echo "Priorité (haute/moyenne/basse) : "
        read priorite
        echo "Durée estimée (en jours) : "
        read duree
        echo "Catégorie : "
        read categorie
        echo "Date d’échéance (YYYY-MM-DD) : "
        read echeance

        statut="pas commencée"

        echo "$id;$tache;$priorite;$duree;$categorie;$echeance;$statut" >> "$fichier_csv"

    elif [ "$choix" -eq 2 ]
    then
        echo ""
        echo "Options de tri :"
        echo "1. Par statut"
        echo "2. Par date d’échéance"
        echo "3. Retour"
        read tri_choix

        if [ "$tri_choix" -eq 1 ]
        then
            tail -n +2 "$fichier_csv" | sort -t';' -k7,7 | column -s ';' -t
        elif [ "$tri_choix" -eq 2 ]
        then
            tail -n +2 "$fichier_csv" | sort -t';' -k6,6 | column -s ';' -t
        fi

    elif [ "$choix" -eq 3 ]
    then
        echo "Entrez l'ID de la tâche à modifier : "
        read id_modif

        ligne_modif=$(grep "^$id_modif;" "$fichier_csv")

        if [ -z "$ligne_modif" ]
        then
            echo "Tâche introuvable."
        else
            echo "Tâche actuelle :"
            echo "$ligne_modif" | column -s ';' -t
            echo ""

            echo "Nouvelle description : "
            read tache
            echo "Nouvelle priorité : "
            read priorite
            echo "Nouvelle durée : "
            read duree
            echo "Nouvelle catégorie : "
            read categorie
            echo "Nouvelle date d’échéance : "
            read echeance
            echo "Nouveau statut : "
            read statut

            sed -i "/^$id_modif;/c\\$id_modif;$tache;$priorite;$duree;$categorie;$echeance;$statut" "$fichier_csv"


            echo "Tâche modifiée."
        fi

    elif [ "$choix" -eq 4 ]
    then
        echo "Au revoir !"
        break
    else
        echo "Choix invalide, veuillez réessayer."
    fi
done
