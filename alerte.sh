#!/bin/bash

fichier_csv="taches.csv"
date_auj=$(date +%Y-%m-%d)

if [ ! -f "$fichier_csv" ]; then
    echo "Fichier $fichier_csv introuvable !"
    exit 1
fi

echo "############  ALERTES  ############"

echo ""
echo "Tâches en retard :"
tail -n +2 "$fichier_csv" | while IFS=';' read id tache priorite duree categorie echeance statut
do
    if [ "$(date -d "$echeance" +%s)" -lt "$(date -d "$date_auj" +%s)" ] && [ "$statut" != "terminée" ]; then
        echo "[$priorite] $tache (échéance $echeance)"
    fi
done

echo ""
echo "Tâches du jour :"
tail -n +2 "$fichier_csv" | while IFS=';' read id tache priorite duree categorie echeance statut
do
    if [ "$echeance" == "$date_auj" ] && [ "$statut" != "terminée" ]; then
        if [ "$priorite" == "haute" ]
        then
            p=1
        elif [ "$priorite" == "moyenne" ]
        then
            p=2
        elif [ "$priorite" == "basse" ]
        then
            p=3
        else
            p=4
        fi
        echo "$p;$priorite;$tache;$duree;$categorie;$statut"
    fi
done | sort -t';' -k1,1n | while IFS=';' read p priorite tache duree categorie statut
do
    echo "[$priorite] $tache"
done

echo "#################################"
