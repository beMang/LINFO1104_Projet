functor  
import
    Browser
export
    printList:PrintList
    contains:Contains
    containsOne:ContainsOne
define
    proc {Browse Buf}
        {Browser.browse Buf}
    end

    % Affiche le contenu d'une liste
    proc {PrintList L}
        case L
        of nil then skip
        [] H|T then
            if {IsString H} then % Pour afficher proprement les strings
                {Browse {String.toAtom H}}
            else
                {Browse H}
            end
            {PrintList T}
        end
    end

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
end