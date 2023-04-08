declare

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
fun{Compare_string String1 String2}
   %%compare deux mots, en prenant en compte les majuscules
   %local s1 s2 in
      %s1= String1.1
      %s2= String2.1
      %if (s1 >90) then 
       %  s1=s1-32
      %end
      %if (s2>90) then 
       %  s2=s2-32
      %end
      if (String1.1>String2.1) then 
         1       %retourne une valeur positive si le premier string est plus loin dans l'alphabet que le 2e
      elseif (String1.1<String2.1) then
         ~1           %retourne une valeur négative si le premier string est plus tôt dans l'alphabet que le 2e
      else
         if (String1.2==nil) then 
            if (String2.2 ==nil) then 
               0           %retourne 0 si les deux mots sont les mêmes
            else
               ~1          %retourne une valeur négative si le premier string est le même que le 2e mais en plus court
            end
         
         elseif (String2.2==nil) then 
            1              %retourne une valeur positive si le premier string est le meme que le 2e mais en plus long
         else
            {Compare_string String1.2 String2.2}
            
         end
      end
   %end
end
Entier= {Compare_string "je" "tu"}

{Browse Entier}
