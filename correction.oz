functor 
import 
    Tr at 'tree.ozf'
    Possibility at 'possibility.ozf'
    System
    Parse at 'parse.ozf'
export
    getNewWord:GetNewWord
define

    fun {GetNewWord Tree TwoWords LastWord}  
        local Values Prevision Prevision2 BestWord in 
            Values= {Tr.lookUp Tree TwoWords}
            Prevision= {Possibility.getPrevision Values}
            case Prevision.1        
                of H|T then 
                    Prevision2=Prevision.1
                    BestWord=Prevision2.1
                else
                    BestWord=Prevision.1
                end
            if {Verif Tree TwoWords LastWord}==0 then
                BestWord 
            else
                if BestWord==LastWord then
                    case Prevision.1
                    of H|T then 
                        T.1
                    else
                        {GetSecondBestWord Values} 
                    end
                else
                    BestWord  
                end
            end
        end
    end
    
    fun {GetSecondBestWord Values}
        "Whore" %TODO
    end

 
    %Renvoie 1 si le mot entré par l'utilisateur est dans les values
    %Renvoie 0 sinon
    fun {Verif Tree TwoWords LastWord}
        local Values Find in
            Values= {Tr.lookUp Tree TwoWords}
            Find= {VerifHelper Values LastWord}
            Find
        end
    end

    %L est la liste des values de l'arbre du N-gramme qui nous intéresse
    %Word est le mot qui a été entré par l'utilisateur
    fun {VerifHelper L Word}
        case L
        of nil then 0
        [] H|T then 
            if H==Word then 
                1
            else
                {VerifHelper T Word}
            end
        else
            0
        end
    end

    %Renvoie le dernier mot d'une liste de mots
end

