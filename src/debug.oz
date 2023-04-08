%Ce module s'occupe de tout ce qui est affichage dans le browser pour que ça soit pas bagdad
functor
import
    Browser
    Str at 'str.ozf'
export
    printNicely:PrintNicely
    printList:PrintList
    printSampleList:PrintSampleList
define
    proc {Browse Buff}
        {Browser.browse Buff}
    end

    %Affiche une chaine S mais sans les \n
    proc {PrintNicely S}
        {Browse {Str.split S [10]}}
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

    %Imprime une liste de Sample proprement
    proc{PrintSampleList L}
        case L 
        of nil then skip
        [] H|T then
            local W1 W2 Content Result in
                W1 = {Str.concat "{w1: " H.w1}
                W2 = {Str.concat " - w2: " H.w2}
                Content = {Str.concat " - val: " H.val}
                Result = {Str.concat {Str.concat W1 W2} Content}
                {Browse {String.toAtom Result}}
            end
            {PrintSampleList T}
        end
    end
end