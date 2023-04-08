functor
import
   Str at '../src/str.ozf'
   Browser
define
   proc {Browse Buf}
      {Browser.browse Buf}
   end

   A= state(string: "mange" right:nil left: nil value: F)
   B= state(string: "bois" right: A left: nil value:nil)
   Test= state(string : "Je" right: nil left:nil subtree: B)
   F= state(beaucoup: 3 bien: 5 des: 7)

   Test2= "jem"

   fun {Bete_fonction}
      	local Myreturn in 
         	Myreturn= state(essai: "je")
         	Myreturn
      end
   end
   {Browse 4}

   %fun {Test_looking_for_Ngramme}
      %   D={Looking_for_Ngramme Test "Je" "mange"}
      %  D==A
   %end
   %fun {Test_Change_probability}
      %E=A.value.beaucoup
      %C= {Change_probability "beaucoup" A}
      %A.value.beaucoup== E+1
   %end
   %fun {Test_Looking_for}
      %G={Looking_for Test "Je" "mange"}
      %G==F
   %end
   Entier= {Str.compare "je" "tu"}
   {Browse Entier}
end
