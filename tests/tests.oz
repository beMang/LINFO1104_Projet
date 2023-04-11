functor
import
   Str at '../src/str.ozf'
   Tree at '../src/tree.ozf'
   Browser
define
   proc {Browse Buf}
      {Browser.browse Buf}
   end

   A= state(string:"mange" right:nil left:nil value:F)
   B= state(string:"bois" right: A left: nil value:nil)
   Test= state(string :"Je" right: nil left:nil subtree:B)
   F= state(beaucoup:3 bien:5 des:7)


   %fun {Test_LookUp} 
   %   local D in 
   %      D={Tree.lookUp_or_create Test "Je" "cours"}
   %      D==A
   %   end
   %end
   %%fun {Test_Change_probability}
   %   %E=A.value.beaucoup
   %   %C= {Change_probability "beaucoup" A}
   %   %A.value.beaucoup== E+1
   %%end
   %fun {Test_Looking_for}
   %   local G in 
   %      G={Tree.looking_for Test "Je" "mange"}
   %      G==F
   %   end
   %end


   Entier= {Str.compare "je" "tu"}
   {Browse Entier}

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
