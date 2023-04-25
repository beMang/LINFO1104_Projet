functor 
import 
    Tr at 'tree.ozf'
    Possibility at 'possibility.ozf'
    System
    Parse at 'parse.ozf'
export
    getNewWord:GetNewWord
define

    fun {GetNewWord Tree TwoWords LastWord }  %je trouve pas le bon format à donner dans les tests à TwoWords mais c'est sur la bonne voie
        local Values Prevision Prevision2 BestWord TwoWords in 
            %TwoWords= {GetTwoFirstWords Words nil}
           
            {System.show "Coucou"}
            Values= {Tr.lookUp Tree TwoWords}
            {System.show "Coucou"}
            Prevision= {Possibility.getPrevision Values}
            %case Prevision.1        
             %   of H|T then 
              %      Prevision2=Prevision.1
               %     BestWord=Prevision2.1
               % else
                    %BestWord=Prevision.1
            BestWord="Yeah"
            {System.show BestWord}
                %end
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

    fun {GetTwoFirstWords Words Acc}   %j'y arrive paas ptn de bordel
        case Words
        of T|nil then Acc
        [] H|T then 
            if Acc==nil then 
                {GetTwoFirstWords T H}
            else
                {GetTwoFirstWords T Acc|H}
            end
        end
    end
 
    %Renvoie 1 si le mot entré par l'utilisateur est dans les values
    %Renvoie 0 sinon
    fun {Verif Tree TwoWords LastWord}
        local Values Find in
            %TwoWords= {GetTwoFirstWords Words nil}
            Values= {Tr.lookUp Tree TwoWords}
            %ToChange= {GetLastWord Words nil}
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
        end
    end

    %Renvoie le dernier mot d'une liste de mots
    fun {GetLastWord Words Acc}
        case Words
        of nil then Acc
        [] H|T then 
            {GetLastWord T H}
        end
    end
end

