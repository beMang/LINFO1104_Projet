functor 
import 
    Str at 'str.ozf'
export
    contains:Contains
    containsOne:ContainsOne
    lookUp_or_create:LookUp_or_create
    looking_for:Looking_for
define
    %Vérifie si L contient C
    fun {Contains L C}
        case L
        of nil then false
        []H|T then
            if H==C then true
            else
                {Contains T C}
            end
        end
    end
    
    %Vérifie si L contient au moins un des éléments dans Carr (Pas utile mais je laisse on sait jamais)
    fun {ContainsOne L Carr}
        case L
        of nil then false
        []H|T then
            if {Contains Carr H}==true then true else {ContainsOne T Carr} end
        end
    end
    fun{LookUp_or_create Actual String1 String2 }
      %Cherche le record de l'arbre qui correspond au duo de mot trouvé
      %String1 c'est le premier mot, String2 c'est le 2e
      %if existe pas encore, on le crée
      %renvoie le record correspondant
   
      if {Str.compare Actual.string String1} ==0 then   %Si record est trouvé
         if (String2==nil) then          %si on était déjà à la recherche du 2e mot      
            Actual 
         else
            {LookUp_or_create Actual.subtree String2 nil} %on passe à la recherche du 2e mot 
         end
      else
         if {Str.compare String1 Actual.string}==~1 then 
            if (Actual.left==nil) then    %si en fait le record cherché existe pas encore
               if (String2==nil) then     %savoir si on était à la recherche du premier ou du 2e mot
                  local A in 
                     A= state(string: String1 right: nil left: nil value: nil )   %value doit pas être à nil mais à faire plus tard 
                     %A=0
                     Actual.left=A 
                     A
                  end
               else
                  local B C in 
                     C= state(string: String2 right: nil left: nil value: nil)   %idem value pas à nil mais plus tard
                     %ou alors on laisse value à nil et on le modifie dans la fonction principale
                     B= state(string: String1 right:nil left:nil subtree: C)
                     %C=0
                     %B=0
                     Actual.left=B
                     B
                  end
               end
            else
               
               {LookUp_or_create Actual.left String1 String2}
            end
         else
            if (Actual.right==nil) then %%idem mais à droite
               if (String2==nil) then 
                  local A in 
                     A= state(string: String1 right: nil left: nil value: nil )   %value doit pas être à nil mais à faire plus tard 
                     %A=0
                     Actual.right=A 
                     A
                  end
               else
                  local B C in 
                     C= state(string: String2 right: nil left: nil value: nil)   %idem value pas à nil mais plus tard
                     B= state(string: String1 right:nil left:nil subtree: C)
                     %C=0
                     %B=0
                     Actual.right=B
                     B
                  end
               end
            else
               {LookUp_or_create Actual.right String1 String2}
            end
         end
      end
    end

    fun{Looking_for Actual Str1 Str2}
        %fonction récursive utilisée par press pour trouver dans l'arbre le Ngramme voulu
        %Actual c'est là où on en est dans le parcours de l'arbre, 
        %Retourne la value du record du duo Str1 Str2
        %Retourne 0 si pas trouvé
        if {Str.compare Actual.string Str1} ==0 then   %Si record est trouvé
            if (Str2==nil) then          %si on était déjà à la recherche du 2e mot      
               Actual.value 
            else
               {Looking_for Actual.subtree Str2 nil} %on passe à la recherche du 2e mot 
            end
        else
            if {Str.compare Str1 Actual.string}==~1 then 
                if Actual.left==nil then 
                    0
                else
                    {Looking_for Actual.left Str1 Str2}
                end
            else
                if Actual.right==nil then 
                    0
                else
                    {Looking_for Actual.right Str1 Str2}
                end
            end
        end
    end

    proc{Change_probability String3 Ngramme}
      %Ngramme c'est un objet qui a le premier mot, le deuxième, tous les autres mots déjà repérés après et leur probabilité
      % On ajuste la probabilité grâce à string3 (qui est tjrs le même qu'au dessus)
      skip
    end

    fun {Looking_for_in_value Val Mystring}
        if 
end