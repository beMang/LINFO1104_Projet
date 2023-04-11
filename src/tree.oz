functor 
import 
    Str at 'str.ozf'
export
    lookUp:LookUp
    insert_in_bigtree: Insert_in_bigtree
    insert_in_value: Insert_in_value
    insert_in_subtree: Insert_in_subtree

define

   

   fun{LookUp Actual Str1 Str2}
        %fonction récursive utilisée par press pour trouver dans l'arbre le Ngramme voulu
        %Actual c'est là où on en est dans le parcours de l'arbre, 
        %Retourne la value du record du duo Str1 Str2
        %Retourne 0 si pas trouvé
      if {Str.compare Actual.string Str1} ==0 then   %Si record est trouvé
         if (Str2==nil) then          %si on était déjà à la recherche du 2e mot      
            Actual.value 
         else
            {LookUp Actual.subtree Str2 nil} %on passe à la recherche du 2e mot 
         end
      else
         if {Str.compare Str1 Actual.string}==~1 then 
               if Actual.left==nil then 
                  0
               else
                  {LookUp Actual.left Str1 Str2}
               end
         else
               if Actual.right==nil then 
                  0
               else
                  {LookUp Actual.right Str1 Str2}
               end
         end
      end
   end


   fun {Insert_in_bigtree StringToInsert Str2 Str3 Tree}
      %on insere un nouveau duo dans l'arbre avec leur 3e mot
      %retourne un nouveau bigtree adapté
      case Tree

      of nil then tree(string:StringToInsert right:nil left:nil subtree:{Insert_in_subtree Str2 Str3 nil}) %cas rencontré à la fin si on n'avait jamais rencontré le premier mot
 
      [] tree(string:Y right:R left:L subtree:S) andthen {Str.compare Y StringToInsert}==0 then     %cas où le 1er mot a déjà été rencontré, alors on doit ajuster le subtree
            tree(string:StringToInsert right:R left:L subtree:{Insert_in_subtree Str2 Str3 S})

      [] tree(string:Y right:R left:L subtree:S) andthen {Str.compare StringToInsert Y}==~1 then    %cas où notre string est plus haut dans l'alphabet
            tree(string:Y right:R left:{Insert_in_bigtree StringToInsert Str2 Str3 L } subtree:S) 

      [] tree(string:Y right:R left:L subtree:S) andthen {Str.compare StringToInsert Y}==1 then %cas où notre string est plus bas dans l'alphabet
          tree(string:Y right:{Insert_in_bigtree StringToInsert Str2 Str3 R} left:L subtree:S) 
         
      end
   end


   fun {Insert_in_subtree Str2 Str3 SubTree}
      %insere le 2e mot dans le subtree
      %retourne un nouveau subtree adapté
      case SubTree

      of nil then tree(string:Str2 right:nil left:nil value:{Insert_in_value Str3 nil}) %cas où le deuxième mot n'vaiat jamais été rencontré
     
      [] tree(string:Y right:R left:L value:V) andthen {Str.compare Str2 Y}==0 then %cas où le deuxième mot a déjà été rencontré et on doit adapter value
         tree(string: Str2 right:R left:L value: {Insert_in_value Str3 V})

      [] tree(string:Y right:R left:L value:V) andthen {Str.compare Str2 Y}==~1 then   %cas où le deuxième mot est plus haut dans l'ordre alphabétique 
         tree(string:Y right:R left:{Insert_in_subtree Str2 Str3 L} value:V)

      [] tree(string:Y right:R left:L value:V) andthen {Str.compare Str2 Y}==1 then  %cas où le deuxième mot est plus bas dans l'ordre alphabétique
         tree(string:Y right:{Insert_in_subtree Str2 Str3 R} left:L value:V)
      end
   end


   fun {Insert_in_value Str3 Val}
      %insere le 3e mot dans les probabilités
      %ATTENTION Str3 doit être en chaine de caractères donc 'Je' et pas "Je"
      case Val
      of nil then 
         {AdjoinList possibilities() [Str3#1]}
      else
         local Keys Nb in 
            Keys= {Arity Val}
            if ({Member Str3 Keys}) then 
               Nb= Val.Str3
               {AdjoinList Val [Str3#(Nb+1)]}
            else
               {AdjoinList Val [Str3#1]} 
            end
         end
      end
   
   end

end