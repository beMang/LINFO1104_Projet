functor
import 
	QTk at 'x-oz://system/wp/QTk.ozf'
   Parse at './src/parse.ozf'
   Tree at './src/tree.ozf'
   Str at './src/str.ozf'
   Possibility at './src/possibility.ozf'
   GUI at './src/GUI.ozf'
   FileM at './src/files.ozf'
   Save at './src/save.ozf'
   Property
   Application
   System
define
   Window SeparatedWordsStream SeparatedWordsPort MyTree InputText NberWord

   NberWord=5 %défini le nombre de mot affiché si more_gramme est activé

   /* @pre : les threads sont "ready"
   @post: Fonction appellee lorsqu on appuie sur le bouton de prediction
         Affiche la prediction la plus probable du prochain mot selon les deux derniers mots entres
   @return: Retourne une liste contenant la liste du/des mot(s) le(s) plus probable(s) accompagnee de 
         la probabilite/frequence la plus elevee. 
         La valeur de retour doit prendre la forme:
                  <return_val> := <most_probable_words> '|' <probability/frequence> '|' nil
                  <most_probable_words> := <atom> '|' <most_probable_words> 
                                           | nil
                  <probability/frequence> := <int> | <float> */
   fun {Press}
      TwoLast = {Str.lastWord {GUI.getEntry} 2}
   in
      if TwoLast==nil then /*Si pas assez de mot pour la prédiction */
         {GUI.setOutput ""}
         [[nil] 0]
      else
         local Prediction Final in
            Prediction = {Tree.lookUp MyTree [{Parse.formatInput {Nth TwoLast 1}} {Parse.formatInput {Nth TwoLast 2}}]}
            if Prediction==0 then
               {GUI.setOutput ""}
               [[nil] 0]
            else
               Final= {Possibility.getPrevision Prediction}
               if {Save.isExtensionActive 'more_gramme'} == false then
                  {GUI.setOutput Final.1.1}
               else
                  {GUI.setOutput {VirtualString.toString {Value.toVirtualString {Possibility.getNMostProbableWord Prediction NberWord} 200 200}}}
               end
               Final
            end
         end
      end
   end
   
   /* Lance les N threads de lecture et de parsing qui liront et traiteront tous les fichiers
   Les threads de parsing envoient leur resultat au port Port */
   proc {LaunchThreads P N}
      Files = {FileM.getAllFilesToLoad}
   in
      thread
         MyTree = {Tree.getTreeFromList SeparatedWordsStream}
      end
      if {LaunchThreadsHelper Files P N}==0 then 
         {Port.send P nil} 
      else 
         {Exception.error "Erreur lors du parsing des fichiers."}
      end
   end

   fun {LaunchThreadsHelper Files P N}
         ToProcess = {Length Files} div N X Y
   in
      if N==1 then
         thread
            X = {ProcessFiles Files P}
         end
         {Wait X}
         X
      else
         thread
            {Thread.setThisPriority high}
            Y = {ProcessFiles {List.take Files ToProcess} P}
         end
         X = {LaunchThreadsHelper {List.drop Files ToProcess} P N-1}
         {Wait Y}  /*Attendre que notre thread ait fini*/
         {Wait X} /*Attendre que les threads lancés aient finis*/
         X
      end
   end

   /*Parse les fichiers dans la liste Files*/
   fun {ProcessFiles Files P}
      case Files
      of nil then 0
      [] H|T then
         {Parse.parseFile H P}
         {ProcessFiles T P}
      end
   end
   
   proc {Main}
      {Property.put print foo(width:1000 depth:1000)}

      /*Creation de la fenetre*/
      Window={QTk.build {GUI.getDescription Press InputText}}
      {Window show}
      {GUI.init Press InputText}
      /*On lance les threads de lecture et de parsing*/
      SeparatedWordsPort = {NewPort SeparatedWordsStream}
      {LaunchThreads SeparatedWordsPort 4}
      
      {Wait MyTree}
      {GUI.clear}
      %%ENDOFCODE%%
   end
   {Main}
end
