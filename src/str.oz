%Ce fichier s'appelle str pour éviter les conflits avec String, mais fait référence à la gestion des chaines de caractère dans le projet
functor
export
    compare:Compare
    split:Split
    toLower:ToLower
    lastWord:LastWord
    deleteCarBegin:DeleteCarBegin
    convertToBool:ConverToBool
    convertBoolToStr:ConvertBoolToStr
    getSentences:GetSentences
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
                if {Member H Carr} then
                    if Acc==nil then %Si chaine de caractère vide on ne l'ajoute pas
                        {SplitHelper T Carr nil Result} 
                    else 
                        {SplitHelper T Carr nil {Append Result Acc|nil}}
                    end
                else
                    {SplitHelper T Carr {Append Acc H|nil} Result}
                end
            [] nil then %Fini de traiter la chaine
                if Acc==nil then %Si chaine de caractère vide on ne l'ajoute pas
                    {SplitHelper nil nil nil Result} 
                else
                    {SplitHelper nil nil nil {Append Result Acc|nil}}
                end
            end
        end
    end

    % Sépare une chaine de caractère en une liste de chaine de caractère
    % Carr contient les caractères utilisés pour séparé la liste S
    fun {Split S Carr}
        {SplitHelper S Carr nil nil}
    end

    fun {ToLowerHelper S Acc}
        case S
        of nil then Acc
        [] H|T then
            {ToLowerHelper T {Append Acc {Char.toLower H}|nil}}
        end
    end
    %Met tout en minuscule
    fun {ToLower S}
        {ToLowerHelper S nil}
    end

    %Retire certains caractères au début des mots
    fun {DeleteCarBegin MyString}
        case MyString
        of nil then nil
        [] H|T then
            case H 
            of 64 then T
            [] 35 then T 
            [] 91 then T 
            [] 45 then T 
            else 
                MyString
            end
        end
    end

    fun{LastWord S N}
        Splited = {Split S [32]}
    in
        if {Length Splited}-N <0 then nil
        else
            {List.drop Splited {Length Splited}-N}
        end
    end

    %Renvoie les phrases d'une chaine de caractère
    fun {GetSentences S}
        {Split S [10 46 63 33 34 40 41]} %10->saut de ligne, 46->point, 63->point d'interrogation,33->point d'exclamation, 34-> guillemet, 40 41-> parenthèses
    end

    %Converti une chaine de caractère en booléen
    fun {ConverToBool S}
        if S=="true" then true
        elseif S=='true' then true
        elseif S==true then true
        else false end
    end

    %Converti un boolean en chaine de caractère (pour l'écriture de la sauvegarde)
    fun {ConvertBoolToStr B}
        if B == true then "true"
        else "false" end
    end
end