functor %Ce fichier contient quelques tests de nos fonctions qui nous ont été utiles pour debugger le projet
import
   Str at 'str.ozf'
   Tree at 'tree.ozf'
   Save at 'save.ozf'
   Files at 'files.ozf'
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
      local Founded Result in 
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
   fun {TestToLower}
      local S Mytest Verif in
         S = "START MAKING VENTILATORS NOW"
         Verif= 'start making ventilators now'  
         Mytest = {String.toAtom{Str.toLower S}}
         Verif==Mytest
      end
   end

   fun {TestTwoLastWord}
      S = "ceci est une phrase"
      LW = {Str.lastWord S 2}
   in
      LW==["une" "phrase"]
   end

   proc {TestLastChar}
      S1 = "bonjour les amis"
      S2 = "bonjour les amis ?  "
   in
      {System.show {Str.getLastCharExceptSpace S1}}
      {System.show {Str.getLastCharExceptSpace S2}}
   end

   proc {TestNewSplit}
      S1 = "I love Michigan"
      S2 = "12€ allà mAdrid"
   in
      
      {System.show {Str.splitAndRemoveNotAlphaNum S1}}
      {System.show {Str.splitAndRemoveNotAlphaNum S2}}
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

   

   

   %---------Lancement des tests--------%
   {Browse {TestToLower}}
   {TestInsertBigTree}
   {TestLookUp}
   {TestGetTreeFromList}
   {Browse {TestTwoLastWord}}
   %{TestGetFolders}
   %{TestGetAllFiles}
   {TestIsDir "src"}
   {TestLastChar}
   {TestNewSplit}

   {Delay 10*1000} %On attend 10 secondes avant de quitter les tests
   {Application.exit 0}
end
