%Ce fichier s'appelle str pour éviter les conflits avec String, mais fait référence à la gestion des chaines de caractère dans le projet
functor
import
    Lst at 'lst.ozf' %Lst à la place de List pour évite les conflicts
export
    compare:Compare
    split:Split
    concat:Concat
    toLower:ToLower
define
    %compare deux mots, sans prendre en compte les majuscules 
    fun{Compare String1 String2}
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
                    {Compare String1.2 String2.2}
                
            end
        end
    end

    fun {SplitHelper S Carr Acc Result}
        if Carr==nil then %A la fin de la chaine donc on renvoie le résultat
            Result
        else
            case S
            of H|T then
                if {Lst.contains Carr H} then
                    if Acc==nil then %Si chaine de caractère vide on ne l'ajoute pas
                        {SplitHelper T Carr nil Result} 
                    else 
                        {SplitHelper T Carr nil {List.append Result Acc|nil}}
                    end
                else
                    {SplitHelper T Carr {List.append Acc H|nil} Result}
                end
            [] nil then %Fini de traiter la chaine
                if Acc==nil then %Si chaine de caractère vide on ne l'ajoute pas
                    {SplitHelper nil nil nil Result} 
                else
                    {SplitHelper nil nil nil {List.append Result Acc|nil}}
                end
            end
        end
    end

    % Sépare une chaine de caractère en une liste de chaine de caractère
    % Carr contient les caractères utilisés pour séparé la liste S
    fun {Split S Carr}
        {SplitHelper S Carr nil nil}
    end

    %Concatène 2 chaine des caractères
    fun {Concat S1 S2}
        {List.append S1 S2}
    end

    fun {ToLowerHelper S Acc}
        case S
        of nil then Acc
        [] H|T then
            {ToLowerHelper T {List.append Acc {Char.toLower H}|nil}}
        end
    end
    %Met tout en minuscule
    fun {ToLower S}
        {ToLowerHelper S nil}
    end
end