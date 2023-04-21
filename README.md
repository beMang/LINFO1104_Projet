# Projet OZ Twitoz

## TODO :
* Bien respecter la valeur de retour
* Trier mieux les mots (dégager @, ', #, (,), [, ],  ) -> Laura
* Extension 1 : base de donnée custom **
* Extension 2 : historique **
* Extension 3 : proposer d'autres n-grammes *

## Commentaires des extensions :

### Généralisation N-gramme 2 étoiles 
Faisaible en généralisant la fonction insert, à voir pour le reste du code si ça devient chiant, mais les arguments content les 2 premiers mots deviendront une liste.

### Optimisation
Ca me semble relou mais why not. Adrien dit non.

### Ajouter des bases de données custom OUI 2 étoiles 1ER
Il suffit de faire une liste dans le makefile avec de nouveau dossier et le tour est joué
Utiliser le bouton save data

### Garder un historique OUI 2 étoiles 2E
Il suffit d'ajouter un bouton sauver l'entrée et on tape ça dans un nouveau fichier (attention à bien ajouter l'arbre la nouvelle entrée => fusion d'arbre)
Ou plutôt relier ça au bouton press

### Proposition automatique
Pas de clique sur le bouton, proposition aparrait tt seul.
Question : est-ce qu'on veut un truc qui "valide" une proposition à la manière de vscode et de pouvoir choisir les autres probas.

Le tier 2 a l'air plus chaud mais why not.

### Plus de 1 N-Gramme OUI 3E 1 etoile
Pas l'air très compliqué, il faut juste chipoter avec la liste

### Correction 3 étoiles 4E
En regardant la liste si le mot actuel a une proba + basse qu'un autre on le remplace ?

### Interface
Why not mais barbant mdr

### MakeFile
Pq pas mais pareil pas très passionant.
On a déjà modifié le makefile pour les tests, on peut faire des tests un peu plus clean et les laisser dans la remise finale