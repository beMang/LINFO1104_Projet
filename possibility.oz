functor %Module qui s'occupe de traiter la structure possibilities, qui est de la forme possibilities(word1:freq word2:freq ...)
export 
    getPrevision:GetPrevision
    getNMostProbableWord:GetNMostProbableWord
define
    %Retourne le mot le plus probable avec sa probabilité
    fun {GetPrevision Prevision}
        %Prevision est un record avec les mots croisés et le nombre de fois où on les a croisés
        local Total Mykees TheWord NumberOcc Probability NumbFloat TotFloat in 
        {Arity Prevision Mykees}
        Total= {GetSumElements Prevision Mykees 0}
        TheWord= {GetWordMax Prevision Mykees nil 0}
        NumberOcc= {GetMaxNumber Prevision Mykees 0}
        {Int.toFloat NumberOcc NumbFloat}
        {Int.toFloat Total TotFloat}
        Probability= NumbFloat/TotFloat
        [TheWord Probability]
        end
    end

    %retourne la somme des occurences du duo de mots grâce à possibilities
    fun {GetSumElements Prevision Mykees Acc}
        %Mykees est donné par arity sur prevision
        case Mykees
        of nil then Acc
        [] H|T then 
        {GetSumElements Prevision T Acc+Prevision.H}
        else
        0
        end
    end

    %retourne le nombre d'apparitions du mot le plus fréquent 
    fun {GetMaxNumber Prevision Mykees Acc }
        %Acc doit être à 0 au début
        case Mykees 
        of nil then Acc 
        [] H|T then 
        if (Acc<Prevision.H) then 
            {GetMaxNumber Prevision T Prevision.H}
        else
            {GetMaxNumber Prevision T Acc}
        end
        end
    end

    %retourne le mot qui est le plus fréquent
    fun {GetWordMax Prevision Mykees Acc Number}
        %Acc doit etre à nil au début et Number à 0
        case Mykees 
        of nil then Acc
        [] H|T then 
        if (Number<Prevision.H) then
            {GetWordMax Prevision T [H] Prevision.H}
        elseif (Number==Prevision.H) then 
            {GetWordMax Prevision T H|Acc Prevision.H}
        else
            {GetWordMax Prevision T Acc Number}
        end
        end
    end

    %Renvoie les N mots les plus probables contenus dans le record possiblity
    fun {GetNMostProbableWord Possibility N}
        RecordAsList = {Record.toListInd Possibility}
        Ordered = {List.sort RecordAsList RecordPossiblityComparator}
    in
        {RemoveOccurence {List.take Ordered N} nil}
    end

    %Comparateur utilisé pour trier les records possibility (dans l'ordre croissant)
    fun {RecordPossiblityComparator R1 R2}
        if R1.2 - R2.2 < 0 then true else false end
    end

    %Retire le nombre d'occurence d'une liste dont les éléments sont word#occurence (et inverse la liste)
    fun {RemoveOccurence L Acc}
        case L 
        of nil then Acc
        [] H|T then {RemoveOccurence T H.1|Acc}
        end
    end
end