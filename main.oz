functor
import 
	QTk at 'x-oz://system/wp/QTk.ozf'
   Parse at 'src/parse.ozf'
   Debug at 'src/debug.ozf'
	System
	Application
	Open
	OS
	Property
	Browser
define
   %%% Pour ouvrir les fichiers
   class TextFile
      	from Open.file Open.text
   end

   proc {Browse Buf}
        {Browser.browse Buf}
   end
   
   local Head in 
      Head= state(string : "nil" right: nil left: nil subtree: nil) 

   %%% /!\ Fonction testee /!\
   %%% @pre : les threads sont "ready"
   %%% @post: Fonction appellee lorsqu on appuie sur le bouton de prediction
   %%%        Affiche la prediction la plus probable du prochain mot selon les deux derniers mots entres
   %%% @return: Retourne une liste contenant la liste du/des mot(s) le(s) plus probable(s) accompagnee de 
   %%%          la probabilite/frequence la plus elevee. 
   %%%          La valeur de retour doit prendre la forme:
   %%%                  <return_val> := <most_probable_words> '|' <probability/frequence> '|' nil
   %%%                  <most_probable_words> := <atom> '|' <most_probable_words> 
   %%%                                           | nil
   %%%                  <probability/frequence> := <int> | <float>
   fun {Press}
       % Fuck ne s'attend pas à avoir une valeur de retour donc on a une excpetion
      %%Q?: Comment on accède aux mots tapés? 
      %%ici je vais les appeler s1 et s2 


      %declare

      %Ngramme myhead= Head;
      %string arg= {Change_to_one_word s1 s2}
      %Ngramme mygramme= {Looking_for myhead arg }
      %mygramme.most_probable_words | mygramme.probability
      0
   end

   fun{Looking_for Actual Recherche}
      %fonction récursive utilisée par press pour trouver dans l'arbre le Ngramme voulu
      %Actual c'est là où on en est dans le parcours de l'arbre, 
      %changer recherche en Recherche1 et 2 c'est les string qu'on cherche
      %refaire pareil que Looking_for_ngramme mais légèrement différent
      if (Actual.string==Recherche) then
         Actual 
      else 
         if (Actual.string<Recherche) then 
            {Looking_for Actual.right Recherche}
         else 
               {Looking_for Actual.left Recherche}
         end
      end
   end

   
    %%% Lance les N threads de lecture et de parsing qui liront et traiteront tous les fichiers
    %%% Les threads de parsing envoient leur resultat au port Port
   proc {LaunchThreads Port N}
        % TODO
      skip
   end
   proc{ReadingFile Port Filename}
      %%Fonction que vont accomplir les threads
      %%Lis le tweet et récupère tous les duos de mots pour les mettre dans l'arbre de N-Words 
      skip
   end
   
   
   proc{Change_probability String3 Ngramme}
      %Ngramme c'est un objet qui a le premier mot, le deuxième, tous les autres mots déjà repérés après et leur probabilité
      % On ajuste la probabilité grâce à string3 (qui est tjrs le même qu'au dessus)
      skip
   end
   
   %%% Ajouter vos fonctions et procédures auxiliaires ici


   %%% Fetch Tweets Folder from CLI Arguments
   %%% See the Makefile for an example of how it is called
   fun {GetSentenceFolder}
      Args = {Application.getArgs record('folder'(single type:string optional:false))}
   in
      Args.'folder'
   end
    
   %%% Procedure principale qui cree la fenetre et appelle les differentes procedures et fonctions
   proc {Main}
      TweetsFolder = {GetSentenceFolder}
   in
      %METHOD MAIN

      local Result in
         Result = {Parse.parseFile "tweets/part_1.txt"}
         {Debug.printSampleList Result} %Virer cette ligne pour l'affichage ça peut prendre bcp de temps
      end
       
      local NbThreads InputText OutputText Description Window SeparatedWordsStream SeparatedWordsPort in
     {Property.put print foo(width:1000 depth:1000)}  % for stdout siz
     
   % Creation de l interface graphique
     Description=td(
            title: "Text predictor"
            lr(text(handle:InputText width:50 height:10 background:white foreground:black wrap:word) button(text:"Predict" width:15 action:Press))
            text(handle:OutputText width:50 height:10 background:black foreground:white glue:w wrap:word)
            action:proc{$}{Application.exit 0} end % quitte le programme quand la fenetre est fermee
            )
     
   % Creation de la fenetre
     Window={QTk.build Description}
     {Window show}
     
     {InputText tk(insert 'end' "Loading... Please wait.")}
     {InputText bind(event:"<Control-s>" action:Press)} % You can also bind events (ici ctrl-s lance la fonction press)
      
    % On lance les threads de lecture et de parsing
     SeparatedWordsPort = {NewPort SeparatedWordsStream}
     NbThreads = 4
     {LaunchThreads SeparatedWordsPort NbThreads}
     
     {InputText set(1:"")}
      end
   end

    % Appelle la procedure principale
   {Main}
end
end