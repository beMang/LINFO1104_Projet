functor
import
   Str at 'str.ozf'
   Tree at 'tree.ozf'
   Save at 'save.ozf'
   Files at 'files.ozf'
   Browser
   System
   Application
   Correction at 'correction.ozf'
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

   A= subtree(string: "mange" right:nil left: nil value: F)
   B= subtree(string: "bois" right: A left: nil value:nil)
   Test= tree(string : "Je" right: nil left:nil subtree: B)
   C=possibilities(des:1)
   D=subtree(string: "manges" right:nil left:nil value:C)
   E=tree(string:"Tu" right:nil left:nil subtree:D)
   Result_test_insert= tree(string: "Je" right: E left:nil subtree:B)
   F= possibilities(beaucoup: 3 bien: 5 des: 7)
   G= possibilities(a:1 hier:4 manger:4)

   proc {TestCorrection}
      local A in
         A= ["Je" "mange"]
         {System.show {Correction.getNewWord Test ["Je" "mange"] 'pas'}}
      end
      
      
   end

   fun {TestInsertBigTree}
      local Mytree in 
         Mytree = {Tree.insertInTree ["Tu" "manges" 'des'] Test}
         Mytree==Result_test_insert
      end
   end
   fun {TestLookUp}
      local G in 
         G={Tree.lookUp Test ["Je" "mange"]}
         G==F
      end
   end


   fun {TestToLower}
      local S Mytest Verif in
         S = "START MAKING VENTILATORS NOW"
         Verif= 'start making ventilators now'  
         Mytest = {String.toAtom{Str.toLower S}}
         %note: toAtom renvoit une chaine de caractères, pas un string, donc on ne peut pas y appliquer Mytest.1
         Verif==Mytest
      end
   end

   fun {TestTwoLastWord}
      S = "ceci est une phrase"
      LW = {Str.lastWord S 2}
   in
      LW==["une" "phrase"]
   end

   %Files Tests :

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


   %On lance les tests
   %{Browse {TestToLower}}
   %{TestTreeAndLookUp}
   %{Browse {TestInsertBigTree}}
   %{Browse {TestLookUp}}
   %{Browse {TestTwoLastWord}}
   %{TestGetFolders}
   %{TestGetAllFiles}
   %{TestIsDir "srcf"}
   {TestCorrection}
   
   

   {Delay 10*1000} %On attend 10 secondes et puis on quitte les tests (ouais c'est pas ouf)
   {Application.exit 0}
end
