functor
import 
   QTk at 'x-oz://system/wp/QTk.ozf'
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
%  declare
%  Head;

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
   proc {Press}
      nil % Fuck ne s'attend pas à avoir une valeur de retour donc on a une excpetion
      %%Q?: Comment on accède aux mots tapés? 
      %%ici je vais les appeler s1 et s2 


      %declare

      %Ngramme myhead= Head;
      %string arg= {Change_to_one_word s1 s2}
      %Ngramme mygramme= {Looking_for myhead arg }
      %mygramme.most_probable_words | mygramme.probability
      
   end
   fun {Change_to_one_word s1 s2}
      %%Change s1 et s2 en un seul mot sans espace
      %%dans l'arbre ils seront par ordre alphabétique donc on s'en fout
      %%ca pose problème que pour deux duos qui mixés font pareil mais qui de base sont pas pareil 
      %%donc heu pas ouf mais bon c'est temporaire
      %%ah et on peut dégager les majuscules ici aussi c'est sympa
      local A in 
         string A= "jemange" %c'est un exemple 
         A
      end
   end

   fun{Looking_for Actual Recherche}
      %fonction récursive utilisée par press pour trouver dans l'arbre le Ngramme voulu
      %Actual c'est là où on en est dans le parcours de l'arbre, 
      %Recherche c'est le string qu'on cherche
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
   proc{Looking_for_Ngramme String1 String2 String3}
      %Cherche le Ngramme de l'arbre qui correspond au duo de mot trouvé
      %String1 c'est le premier mot, String2 c'est le 2e, String3 c'est le mot d'après
      %if existe pas encore, on le crée
       
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

   %%% Decomnentez moi si besoin
   %proc {ListAllFiles L}
   %   case L of nil then skip
   %   [] H|T then {Browse {String.toAtom H}} {ListAllFiles T}
   %   end
   %end
    
   %%% Procedure principale qui cree la fenetre et appelle les differentes procedures et fonctions
   proc {Main}
      TweetsFolder = {GetSentenceFolder}
   in
      %% Fonction d'exemple qui liste tous les fichiers
      %% contenus dans le dossier passe en Argument.
      %% Inspirez vous en pour lire le contenu des fichiers
      %% se trouvant dans le dossier
      %%% N'appelez PAS cette fonction lors de la phase de
      %%% soumission !!!
      % {ListAllFiles {OS.getDir TweetsFolder}}
       
      local NbThreads InputText OutputText Description Window SeparatedWordsStream SeparatedWordsPort in
	 {Property.put print foo(width:1000 depth:1000)}  % for stdout siz
	 
            % TODO
	 
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