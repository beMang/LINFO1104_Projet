functor
import 
	QTk at 'x-oz://system/wp/QTk.ozf'
   Parse at 'src/parse.ozf'
   Debug at 'src/debug.ozf'
   Tree at 'src/tree.ozf'
   Str at 'src/str.ozf'
	System
	Application
	Open
	OS
	Property
	Browser
define
   local NbThreads InputText OutputText Description Window SeparatedWordsStream SeparatedWordsPort MyTree in
   proc {Browse Buf}
        {Browser.browse Buf}
   end

   
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
      Input = {InputText get($)}
      TwoLast = {Str.lastWord Input 2}
   in
      local Prediction Text Final in
         Prediction = {Tree.lookUp MyTree {Nth TwoLast 1} {Nth TwoLast 2}}
         Final= {Tree.getPrevision Prediction}
         Text = {VirtualString.toString {Value.toVirtualString Final 20 25}} %On convertit le record en string (c'est un début)
         {OutputText set(1:Text)}
         Final  %Il faut encore retravailler ce résultat pour matcher les spécifications
      end
   end
   
   %%% Lance les N threads de lecture et de parsing qui liront et traiteront tous les fichiers
   %%% Les threads de parsing envoient leur resultat au port Port
   proc {LaunchThreads P N}
      Files = {OS.getDir {GetSentenceFolder}}
   in
      if {LaunchThreadsHelper Files {GetSentenceFolder} P N}==0 then 
         {Port.send P nil} 
      else 
         {Browse aie} 
      end
   end

   fun {LaunchThreadsHelper Files Folder P N}
         ToProcess = {Length Files} div N
         X
         Y %ne sert à rien mais pour pas planter
   in
      if N==1 then
         thread
            X = {ProcessFiles Files Folder P}
         end
         {Wait X}
         X
      else
         thread 
            X = {LaunchThreadsHelper {List.drop Files ToProcess} Folder P N-1}
         end
         Y = {ProcessFiles {List.take Files ToProcess} Folder P}
         {Wait X}
         X
      end
   end


   %Parse les fichiers dans la liste Files
   fun {ProcessFiles Files Folder P}
      case Files
      of nil then 0 % Code succès
      [] H|T then
         {ReadingFile P {Append Folder {Append "/" H}}}
         {ProcessFiles T Folder P}
      end
   end

   %%Fonction que vont accomplir les threads
   %%Lis le tweet et récupère tous les duos de mots pour les mettre dans l'arbre de N-Words
   proc{ReadingFile P FileName}
      {Parse.parseFilePort FileName P}
   end

   %%% Fetch Tweets Folder from CLI Arguments
   %%% See the Makefile for an example of how it is called
   fun {GetSentenceFolder}
      Args = {Application.getArgs record('folder'(single type:string optional:false))}
   in
      Args.'folder'
   end
    
   %%% Procedure principale qui cree la fenetre et appelle les differentes procedures et fonctions
   proc {Main}
         {Property.put print foo(width:1000 depth:1000)}  % for stdout siz
      
         % Creation de l interface graphique
         Description=td(
            title: "Text predictor"
            lr(text(handle:InputText width:50 height:10 background:white foreground:black wrap:word) button(text:"Predict" width:15 action:proc{$}X in X = {Press}end))
            text(handle:OutputText width:50 height:10 background:black foreground:white glue:w wrap:word)
            action:proc{$}{Application.exit 0} end % quitte le programme quand la fenetre est fermee
         )
      
         % Creation de la fenetre
         Window={QTk.build Description}
         {Window show}
         
         {InputText tk(insert 'end' "Loading... Please wait.")}
         {InputText bind(event:"<Control-s>" action:proc{$}X in X = {Press}end)} % You can also bind events (ici ctrl-s lance la fonction press)
         
         % On lance les threads de lecture et de parsing
         SeparatedWordsPort = {NewPort SeparatedWordsStream}
         NbThreads = 12
         {LaunchThreads SeparatedWordsPort NbThreads}

         %Création de l'arbre : QUESTION : faudra t'il mettre ça dans des threads aussi et avoir plusieurs petits arbres à rassembler.
         local X in
            thread 
               MyTree = {Tree.getTreeFromList SeparatedWordsStream}
               X = 0
            end
            {Wait X}
         end
         
         {InputText set(1:"")}
   end
   {Main}
   end
end
