functor 
import 
    Str at 'str.ozf'
    Browser
export
   lookUp:LookUp
   getTreeFromList:GetTreeFromList
   insertInTree:InsertInTree
define

   %fonction récursive utilisée par press pour trouver dans l'arbre le Ngramme voulu
   %Retourne la value du record pour la liste de mot L (dans le cas de 2-gramme, la liste aura une longueur 2)
   %Retourne 0 si pas trouvé
   fun{LookUp Tree L}
      case Tree
      of nil then 0 %pas de résultat trouvé si l'arbre est nul
      else
         case L
         of H|T then
            if {Str.compare Tree.string H} ==0 then   %Si on trouve le mot
               if {Length L}==1 then          %si on était à la recherche du denier mot => on est sur un feuille
                  Tree.value
               else
                  {LookUp Tree.subtree T} %on passe à la recherche du prochain mot
               end
            elseif {Str.compare H Tree.string}==~1 then 
                  {LookUp Tree.left L}
            else
                  {LookUp Tree.right L}
            end
         else 
            0
         end
      end
   end

   % Création de l'arbre :

   %Insère une entrée dans l'arbre, avec une liste de mots (et plus 3 arguments comme avant)
   %Leaf représente les records qui contiennent un champ "value" et contenant un record possibilities
   %Pas le cas des records "tree"
   fun {InsertInTree Words Tree}
      Size = {Length Words}
   in
      case Words
      of nil then Tree
      [] H|T then
         case Tree
         of nil then
            if Size==2 then %On regarde si on traite les 2 derniers mots.
               leaf(string:H right:nil left:nil value:{InsertContentLeaf {Nth Words 2} nil}) %Jamais rencontré ce mot (on le rencontre à la fin) et c'est le dernier !
            else
               tree(string:H right:nil left:nil subtree:{InsertInTree T nil}) %Jamais rencontré ce mot (on le rencontre à la fin)
            end
   
         [] tree(string:Y right:R left:L subtree:S) andthen {Str.compare Y H}==0 then     %cas où le 1er mot a déjà été rencontré, alors on doit ajuster le subtree
               tree(string:H right:R left:L subtree:{InsertInTree T S})

         [] tree(string:Y right:R left:L subtree:S) andthen {Str.compare H Y}==~1 then    %cas où notre string est plus haut dans l'alphabet
               tree(string:Y right:R left:{InsertInTree Words L} subtree:S)

         [] tree(string:Y right:R left:L subtree:S) andthen {Str.compare H Y}==1 then %cas où notre string est plus bas dans l'alphabet
            tree(string:Y right:{InsertInTree Words R} left:L subtree:S)
         
         [] leaf(right:R left:L string:Y value:V) andthen {Str.compare H Y}==0 then %cas où le dernier mot a déjà été rencontré et on doit adapter value
            if Size==2 then
               leaf(string:H right:R left:L value: {InsertContentLeaf {Nth Words 2} V})
            else {Exception.error "Cas non traité lors de la création de la feuille"} end
      
         [] leaf( right:R left:L string:Y value:V) andthen {Str.compare H Y}==~1 then   %cas où le dernier mot est plus haut dans l'ordre alphabétique
            if Size==2 then
               leaf(string:Y right:R left:{InsertInTree Words L} value:V)
            else {Exception.error "Cas non traité lors de la création de la feuille"} end
      
         [] leaf( right:R left:L string:Y value:V) andthen {Str.compare H Y}==1 then  %cas où le dernier mot est plus bas dans l'ordre alphabétique
            if Size==2 then
               leaf(string:Y right:{InsertInTree Words R} left:L value:V)
            else {Exception.error "Cas non traité lors de la création de la feuille"} end

         else
            {Exception.error "Cas non traité dans la création de l'arbre"}
         end
      else
         {Exception.error "Cas non traité dans la création de l'arbre"}
      end
   end

   % Insère la valeur str dans le record de possiblité d'une leaf
   fun {InsertContentLeaf Str Val}
      case Val
      of nil then 
         {AdjoinList possibilities() [Str#1]}
      else
         local Keys Nb in 
            Keys= {Arity Val}
            if ({Member Str Keys}) then 
               Nb= Val.Str
               {AdjoinList Val [Str#(Nb+1)]}
            else
               {AdjoinList Val [Str#1]} 
            end
         end
      end
   end

   % Créée l'arbre à partir d'une liste L de sample
   fun {GetTreeFromListHelper L Acc}
      case L
      of nil then Acc
      [] H|T then %H is a sample
         if H==nil then Acc
         else
            {GetTreeFromListHelper T {InsertInTree H Acc}} %A adapter si on veut un N-Gramme
         end
      end
   end

   fun {GetTreeFromList L}
      {GetTreeFromListHelper L nil}
   end
end
