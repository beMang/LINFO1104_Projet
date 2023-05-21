functor %Ce fichier contient quelques tests de nos fonctions qui nous ont été utiles pour debugger le projet
import
   Str at 'str.ozf'
   Tree at 'tree.ozf'
   Save at 'save.ozf'
   Files at 'files.ozf'
   Possibility at 'possibility.ozf'
   Browser
   System
   Application
define
   proc {Browse Buf}
      {Browser.browse Buf}
   end

   proc {DisplayList L}
      case L
      of nil then skip
      [] H|T then
         {System.show {String.toAtom H}}
         {DisplayList T}
      end
   end
   
   %--------Elements créés pour tester nos fonctions-------%
   TestTree= tree(string : "Je" right: nil left:nil subtree: B)
   A= leaf(string: "mange" right:nil left: nil value: F)
   F= possibilities(beaucoup: 3 bien: 5 des: 7)
   B= leaf(string: "bois" right: A left: nil value:nil)
   C=possibilities(des:1)
   D=leaf(string: "manges" right:nil left:nil value:C)
   E=tree(string:"Tu" right:nil left:nil subtree:D)
   Result_test_insert= tree(string: "Je" right: E left:nil subtree:B)
   G= possibilities(a:1 hier:4 manger:4)
   H=leaf(string: "est" right:nil left:nil value: I)
   I=possibilities(beau:2 gentil:1)
   ResultGetTreeFromList= tree(string: "Il" right: E left: nil subtree:H )



   %------------Tests des fonctions de Tree---------------%
   proc {TestInsertBigTree}
      local Mytree in 
         Mytree = {Tree.insertInTree ["Tu" "manges" 'des'] TestTree}
         {System.show Mytree==Result_test_insert}
      end
   end

   proc {TestLookUp}
      local Founded in 
         Founded={Tree.lookUp TestTree ["Je" "mange"]}
         {System.show Founded==F}
      end
   end

   proc {TestGetTreeFromList}
      local List Result in 
         List= [["Il" "est" 'beau'] ["Tu" "manges" 'des'] ["Il" "est" 'gentil'] ["Il" "est" 'beau']]
         Result={Tree.getTreeFromList List}
         {System.show Result==ResultGetTreeFromList}
      end
   end




   %----------Tests des fonctions de Str--------%
   proc {TestCompare}
      local S1 S2 Result1 Result2 Result3 in 
         S1= "mother"
         S2= "father"
         Result1={Str.compare S1 S2}
         Result2={Str.compare S2 S1}
         Result3={Str.compare S1 S1}
         {System.show Result1==1}
         {System.show Result2==~1}
         {System.show Result3==0}
      end
   end

   proc {TestSplit}
      local S Result S2 in 
         S= "i want money"
         S2= {Str.split S [32]}
         Result= ["i" "want" "money"]
         {System.show S2==Result}
      end
   end


   proc {TestToLower}
      local S Mytest Verif in
         S = "START MAKING VENTILATORS NOW"
         Verif= 'start making ventilators now'  
         Mytest = {String.toAtom{Str.toLower S}}
         {System.show Verif==Mytest}
      end
   end

   proc {TestLastWord}
      local S LW in 
         S = "ceci est une phrase"
         LW = {Str.lastWord S 2}
         {System.show LW==["une" "phrase"]}
      end
   end

   proc {TestGetSentences}
      local Text Phrases in 
         Text="I have one brother. Is he nice? Yes he is!"
         Phrases= ["I have one brother" " Is he nice" " Yes he is"]
         {System.show {Str.getSentences Text}==Phrases}
      end
   end

   proc {TestLastChar}
      S1 = "bonjour les amis"
      S2 = "bonjour les amis ?  "
   in
      {System.show {Str.getLastCharExceptSpace S1}==115}
      {System.show {Str.getLastCharExceptSpace S2}==63}
   end

   proc {TestNewSplit}
      S1 = "I love Michigan"
      S2 = "12€ allà mAdrid"
   in
      {System.show {Str.splitAndRemoveNotAlphaNum S1}==["i" "love" "michigan"]}
      {System.show {Str.splitAndRemoveNotAlphaNum S2}==["12" "all" "madrid"]}
   end

   proc {TestRemoveLastWord}
      local S in 
         S= "I want you"
         {System.show {Str.removeLastWord S}== "I want "}
      end
   end


   %----------Tests des fonctions de files---------%

   proc {TestGetFolders}
      Folders = {Save.getFoldersToLoad}
   in
      {DisplayList Folders}
   end

   proc {TestGetAllFiles}
      F = {Files.getAllFilesToLoad}
   in
      {DisplayList F}
   end

   proc {TestIsDir Name}
      {System.show {Files.isDir Name}}
   end


   %--------Test des fonction de possibility----%
   proc {TestGetPrevision}
      {System.show {Possibility.getPrevision F}== [['des'] 7.0/15.0]}
      {System.show {Possibility.getPrevision G}==[['manger' 'hier'] 4.0/9.0]}
   end

   proc {TestGetNMostProbableWords}
      {System.show {Possibility.getNMostProbableWord F 2}==['des' 'bien']}
   end

   

   

   %---------Lancement des tests--------%
   {System.show {String.toAtom "Tests from Tree file"}}
   {TestInsertBigTree}
   {TestLookUp}
   {TestGetTreeFromList}

   {System.show {String.toAtom "Tests from Str"}}
   {TestCompare}
   {TestSplit}
   {TestToLower}
   {TestLastWord}
   {TestGetSentences}
   {TestLastChar}
   {TestRemoveLastWord}
   {TestNewSplit}
   
   {System.show {String.toAtom "Tests from Files"}}
   %{TestGetFolders}
  % {TestGetAllFiles}
   {TestIsDir "tweets"}

   {System.show {String.toAtom "Tests from Possibility"}}
   {TestGetPrevision}
   {TestGetNMostProbableWords}

   {Delay 10*1000} %On attend 10 secondes avant de quitter les tests
   {Application.exit 0}
end
