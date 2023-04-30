functor %Module qui s'occupe de traiter la structure possibilities
export 
    getPrevision:GetPrevision
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
end