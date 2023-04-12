functor
import
   Str at '../src/str.ozf'
   Tree at '../src/tree.ozf'
   Browser
   Application
define
   proc {Browse Buf}
      {Browser.browse Buf}
   end

   A= subtree(string: "mange" right:nil left: nil value: F)
   B= subtree(string: "bois" right: A left: nil value:nil)
   Test= tree(string : "Je" right: nil left:nil subtree: B)
   C=possibilities(des:1)
   D=subtree(string: "manges" right:nil left:nil value:C)
   E=tree(string:"Tu" right:nil left:nil subtree:D)
   Result_test_insert= tree(string: "Je" right: E left:nil subtree:B)
   F= possibilities(beaucoup: 3 bien: 5 des: 7)

   fun {TestInsertBigTree}
      local Mytree in 
         Mytree = {Tree.insertInBigTree "Tu" "manges" 'des' Test}
         Mytree==Result_test_insert
      end
   end
   fun {TestLookUp}
      local G in 
         G={Tree.lookUp Test "Je" "mange"}
         G==F
      end
   end


   fun {TestToLower}
      local S Mytest Verif in
         S = "START MAKING VENTILATORS NOW"
         Verif= 'start making ventilators now'   %je désire le contexte de cette phrase test
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


   proc {TestTreeAndLookUp}
      local T1 T2 in
         T1 = {Tree.insertInBigTree "test1" "test2" test1 {Tree.insertInBigTree "test1" "test2" test1 nil}}
         T2 = {Tree.insertInBigTree "allo" "pompier" feu T1}
         {Browse {Tree.lookUp T1 "test1" "test2"}}
         {Browse {Tree.lookUp T2 "allo" "pompier"}}
      end
   end


   %On lance les tests
   {Browse {TestToLower}}
   {TestTreeAndLookUp}
   {Browse {TestInsertBigTree}}
   {Browse {TestLookUp}}
   {Browse {TestTwoLastWord}}

   {Delay 10*1000} %On attend 10 secondes et puis on quitte les tests (ouais c'est pas ouf)
   {Application.exit 0}
end
