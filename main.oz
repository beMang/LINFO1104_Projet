functor
import 
	QTk at 'x-oz://system/wp/QTk.ozf'
   Parse at 'src/parse.ozf'
   Tree at 'src/tree.ozf'
   Str at 'src/str.ozf'
   Possibility at 'src/possibility.ozf'
   GUI at 'src/GUI.ozf'
   FileM at 'src/files.ozf'
	OS
define
   Window SeparatedWordsStream SeparatedWordsPort MyTree

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
      TwoLast = {Str.lastWord {GUI.getEntry} 2}
   in
      if TwoLast==nil then %Si pas assez de mot pour la prédiction
         {GUI.setOutput ""}
         nil
      else
         local Prediction Text Final in
            Prediction = {Tree.lookUp MyTree [{Str.toLower {Nth TwoLast 1}} {Str.toLower {Nth TwoLast 2}}]}
            if Prediction==0 then
               {GUI.setOutput ""}
               nil 
            else
               Final= {Possibility.getPrevision Prediction}
               Text = {VirtualString.toString {Value.toVirtualString Final 20 25}}
               {GUI.setOutput Text}
               Final  %Il faut encore retravailler ce résultat pour matcher les spécifications
            end
         end
      end
   end
   
   %%% Lance les N threads de lecture et de parsing qui liront et traiteront tous les fichiers
   %%% Les threads de parsing envoient leur resultat au port Port
   proc {LaunchThreads P N}
      Files = {OS.getDir {FileM.getSentenceFolder}}
   in
      local X in
         thread
            MyTree = {Tree.getTreeFromList SeparatedWordsStream}
         end
      end
      if {LaunchThreadsHelper Files {FileM.getSentenceFolder} P N}==0 then 
         {Port.send P nil} 
      else 
         {Exception.error "Erreur lors du parsing des fichiers."}
      end
   end

   fun {LaunchThreadsHelper Files Folder P N}
         ToProcess = {Length Files} div N X Y
   in
      if N==1 then
         thread
            X = {ProcessFiles Files Folder P}
         end
         {Wait X}
         X
      else
         thread
            {Thread.setThisPriority high}
            Y = {ProcessFiles {List.take Files ToProcess} Folder P}
         end
         X = {LaunchThreadsHelper {List.drop Files ToProcess} Folder P N-1}
         {Wait Y}  %Attendre que notre thread ait fini
         {Wait X} %Attendre que les threads lancés aient finis
         X
      end
   end

   %Parse les fichiers dans la liste Files
   fun {ProcessFiles Files Folder P}
      case Files
      of nil then 0 % Code succès
      [] H|T then
         {Parse.parseFilePort {Append Folder {Append "/" H}} P}
         {ProcessFiles T Folder P}
      end
   end

   proc {Reload}
      MyTree = nil
   end

   proc {Main}
      %{Property.put print foo(width:1000 depth:1000)}  % for stdout siz à quoi ça sert

      % Creation de la fenetre
      Window={QTk.build {GUI.getDescription Press Reload}}
      {Window show}
      {GUI.init Press}
      % On lance les threads de lecture et de parsing
      SeparatedWordsPort = {NewPort SeparatedWordsStream}
      {LaunchThreads SeparatedWordsPort 4}
      
      {Wait MyTree}
      {GUI.clear} %On nettoie les champs de texte
   end
   {Main}
end
