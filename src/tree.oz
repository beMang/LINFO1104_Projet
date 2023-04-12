functor 
import 
    Str at 'str.ozf'
export
   lookUp:LookUp
   insertInBigTree:InsertInBigTree
   insertInValue:InsertInValue
   insertInSubtree:InsertInSubtree
define
   fun{LookUp Tree Str1 Str2}
        %fonction récursive utilisée par press pour trouver dans l'arbre le Ngramme voulu
        %Tree c'est là où on en est dans le parcours de l'arbre, 
        %Retourne la value du record du duo Str1 Str2
        %Retourne 0 si pas trouvé
      if {Str.compare Tree.string Str1} ==0 then   %Si record est trouvé
         if (Str2==nil) then          %si on était déjà à la recherche du 2e mot      
            Tree.value 
         else
            {LookUp Tree.subtree Str2 nil} %on passe à la recherche du 2e mot 
         end
      else
         if {Str.compare Str1 Tree.string}==~1 then 
               if Tree.left==nil then 
                  0
               else
                  {LookUp Tree.left Str1 Str2}
               end
         else
               if Tree.right==nil then 
                  0
               else
                  {LookUp Tree.right Str1 Str2}
               end
         end
      end
   end


   fun {InsertInBigTree StringToInsert Str2 Str3 Tree}
      %on insere un nouveau duo dans l'arbre avec leur 3e mot
      %retourne un nouveau bigtree adapté
      %@pre: StringToInsert et Str2 sont des strings, Str3 est une chaine de caractère, Tree est un arbre sous la forme tree(string:_ right:_ left:_ subtree:_)
      %@post: Tree sous la forme tree(string:_ right:_ left:_ subtree:_)
      case Tree

      of nil then tree(string:StringToInsert right:nil left:nil subtree:{InsertInSubtree Str2 Str3 nil}) %cas rencontré à la fin si on n'avait jamais rencontré le premier mot
 
      [] tree(string:Y right:R left:L subtree:S) andthen {Str.compare Y StringToInsert}==0 then     %cas où le 1er mot a déjà été rencontré, alors on doit ajuster le subtree
            tree(string:StringToInsert right:R left:L subtree:{InsertInSubtree Str2 Str3 S})

      [] tree(string:Y right:R left:L subtree:S) andthen {Str.compare StringToInsert Y}==~1 then    %cas où notre string est plus haut dans l'alphabet
            tree(string:Y right:R left:{InsertInBigTree StringToInsert Str2 Str3 L } subtree:S) 

      [] tree(string:Y right:R left:L subtree:S) andthen {Str.compare StringToInsert Y}==1 then %cas où notre string est plus bas dans l'alphabet
          tree(string:Y right:{InsertInBigTree StringToInsert Str2 Str3 R} left:L subtree:S) 
         
      end
   end


   fun {InsertInSubtree Str2 Str3 SubTree}
      %insere le 2e mot dans le subtree
      %retourne un nouveau subtree adapté
      case SubTree

      of nil then subtree(string:Str2 right:nil left:nil value:{InsertInValue Str3 nil}) %cas où le deuxième mot n'vaiat jamais été rencontré
     
      [] subtree( right:R left:L string:Y value:V) andthen {Str.compare Str2 Y}==0 then %cas où le deuxième mot a déjà été rencontré et on doit adapter value
         subtree(string: Str2 right:R left:L value: {InsertInValue Str3 V})

      [] subtree( right:R left:L string:Y value:V) andthen {Str.compare Str2 Y}==~1 then   %cas où le deuxième mot est plus haut dans l'ordre alphabétique 
         subtree(string:Y right:R left:{InsertInSubtree Str2 Str3 L} value:V)

      [] subtree( right:R left:L string:Y value:V) andthen {Str.compare Str2 Y}==1 then  %cas où le deuxième mot est plus bas dans l'ordre alphabétique
         subtree(string:Y right:{InsertInSubtree Str2 Str3 R} left:L value:V)
      else
         0
      end
   end


   fun {InsertInValue Str3 Val}
      %insere le 3e mot dans les probabilités
      %ATTENTION Str3 doit être atom donc 'Je' et pas "Je" (Bien faire la conversion String.toAtom avant)
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