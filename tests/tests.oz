functor
import
   Str at '../src/str.ozf'
   Tree at '../src/tree.ozf'
   Browser
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

   Test2= "jem"


   fun {Test_LookUp} 
      local D in 
         D={Tree.lookUp_or_create Test "Je" "cours"}
         D==A
      end
   end
   fun {Test_Insert_big_tree}
      local Mytree in 
         Mytree = {Tree.insert_in_bigtree "Tu" "manges" 'des' Test}
         Mytree==Result_test_insert
      end
   end
   fun {Test_Looking_for}
      local G in 
         G={Tree.looking_for Test "Je" "mange"}
         G==F
      end
   end
   Entier= {Str.compare "je" "tu"}


   % Test toLower:
   fun {Test_toLower}
      local S Mytest Verif in
         S = "START MAKING VENTILATORS NOW"
         Verif= 'start making ventilators now'   %je désire le contexte de cette phrase test
         Mytest = {String.toAtom{Str.toLower S}}
         %note: toAtom renvoit une chaine de caractères, pas un string, donc on ne peut pas y appliquer Mytest.1
         Verif==Mytest
      end
   end


   fun {TestTreeAndLookUp}
      local T1 T2 in
         T1 = {Tree.insertInBigTree "test1" "test2" test1 {Tree.insertInBigTree "test1" "test2" test1 nil}}
         T2 = {Tree.insertInBigTree "allo" "pompier" feu T1}
         {Browse {Tree.lookUp T1 "test1" "test2"}}
         {Browse {Tree.lookUp T2 "allo" "pompier"}}
      end
      0
   end

   %{Browse {Test_LookUp}}
   %{Browse {Test_Looking_for}}
   {Browse {Test_toLower}}
   {Browse {TestTreeAndLookUp}}
end
