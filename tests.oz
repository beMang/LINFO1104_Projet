declare

A= state(string: "mange" right:nil left: nil value: F)
B= state(string: "bois" right: A left: nil value:nil)
Test= state(string : "Je" right: nil left:nil subtree: B)
F= state(beaucoup: 3 bien: 5 des: 7)

{Browse Test.subtree}
{Browse Test.string}
Test2= "je"
{Browse Test.subtree.right.value.beaucoup}
fun {Bete_fonction}
    local Myreturn in 
        Myreturn= state(essai: "je")
        Myreturn
    end
end
{Browse {Bete_fonction}}
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
fun{Looking_for_Ngramme Actual String1 String2 }
      %Cherche le record de l'arbre qui correspond au duo de mot trouvé
      %String1 c'est le premier mot, String2 c'est le 2e
      %if existe pas encore, on le crée
      %renvoie le record correspondant
   
      if (Actual.string==String1) then   %Si record est trouvé
         if (String2==nil) then          %si on était déjà à la recherche du 2e mot      
            Actual 
         else
            {Looking_for_Ngramme Actual.subtree String2 nil} %on passe à la recherche du 2e mot 
         end
      else
         if (Actual.string>String1) then 
            if (Actual.left==nil) then    %si en fait le record cherché existe pas encore
               if (String2==nil) then     %savoir si on était à la recherche du premier ou du 2e mot
                  local A in 
                     %A= state (string:nil right:nil left:nil value:nil )   %value doit pas être à nil mais à faire plus tard 
                     A=0
                     Actual.left=A 
                     A
                  end
               else
                  local B C in 
                     %C= state(string: String2 right: nil left: nil value: nil)   %idem value pas à nil mais plus tard
                     %ou alors on laisse value à nil et on le modifie dans la fonction principale
                     %B= state (string: String1 right:nil left:nil subtree: C)
                     C=0
                     B=0
                     Actual.left=B
                     B
                  end
               end
            else
               
               {Looking_for_Ngramme Actual.left String1 String2}
            end
         else
            if (Actual.right==nil) then %%idem mais à droite
               if (String2==nil) then 
                  local A in 
                     %A= state (string: String1 right: nil left: nil value: nil )   %value doit pas être à nil mais à faire plus tard 
                     A=0
                     Actual.right=A 
                     A
                  end
               else
                  local B C in 
                     %C= state(string: String2 right: nil left: nil value: nil)   %idem value pas à nil mais plus tard
                     %B= state (string: String1 right:nil left:nil subtree: C)
                     C=0
                     B=0
                     Actual.right=B
                     B
                  end
               end
            else
               {Looking_for_Ngramme Actual.right String1 String2}
            end
         end
      end
      
   end
