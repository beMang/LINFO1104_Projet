functor
import
   Str at '../src/str.ozf'
   Lst at '../src/lst.ozf'
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

   fun {Test_LookUp} 
      local D in 
         D={Lst.lookUp_or_create Test "Je" "mange"}
         D==A
      end
   end
   %fun {Test_Change_probability}
      %E=A.value.beaucoup
      %C= {Change_probability "beaucoup" A}
      %A.value.beaucoup== E+1
   %end
   fun {Test_Looking_for}
      local G in 
         G={Lst.looking_for Test "Je" "mange"}
         G==F
      end
   end
   Entier= {Str.compare "je" "tu"}
   {Browse Entier}

   % Test toLower:
   S = "START MAKING VENTILATORS NOW"
   {Browse {String.toAtom {Str.toLower S}}}
   {Browse {Test_LookUp}}
   {Browse {Test_Looking_for}}
end
