functor  
import
    File at 'files.ozf'
    Str at 'str.ozf'
    Tree at 'tree.ozf'
export
    parseFilePort:ParseFilePort
define
    fun {FormatStr S} %%on l'utilise pour virer les symboles nuls 
        local S2 in 
            S2={Str.toLower S}
            {DeleteCarBegin S2}
        end
    end

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
            

    

    %Créer une sample (liste du type word1|word2|prediction|nil) et l'envoie dans le port P
    proc {GetSampleHelperPort WordsL Word1 Word2 P}
        case WordsL
        of nil then skip
        [] H|T then
            if Word1==nil then
                {GetSampleHelperPort T H Word2 P} %Initialiser
            else
                if Word2==nil then
                    {GetSampleHelperPort T Word1 H P} %Initialiser
                else
                    local W1={FormatStr Word1} W2={FormatStr Word2} W3={String.toAtom {FormatStr H}} in
                        if W1==nil then skip
                        elseif W2==nil then skip
                        elseif W3==nil then skip
                        else
                            {Port.send P [
                                {FormatStr Word1}
                                {FormatStr Word2}
                                {String.toAtom {FormatStr H}}
                            ]}
                        end
                    end
                    {GetSampleHelperPort T Word2 H P}
                end
            end
        end
    end
    proc {GetSamplePort Sentence P}
        {GetSampleHelperPort {Str.split Sentence [32]} nil nil P} %32 code Ascii de espace, donc on envoie les mots
    end
    
    %Fonctions parsant un fichier, fonctionnant avec un port, les résultats sont envoyés à celui-ci
    proc{ParseFileHelperPort SentenceArray P}
        case SentenceArray
        of nil then skip
        [] H|T then
            {GetSamplePort H P}
            {ParseFileHelperPort T P}
        end
    end
    proc {ParseFilePort FileName P}
        {ParseFileHelperPort {File.getSentences FileName} P}
    end
end