functor  
import
    File at 'files.ozf'
    Str at 'str.ozf'
    Save at 'save.ozf'
export
    parseFile:ParseFile
    formatStr:FormatStr
define
    BetterParsing = {Save.isExtensionActive 'better_parse'} %Si on a activé le parsing un peu meilleur que celui de base (pour ne pas aller demander à l'appli à chaque fois)

    %Retire les symboles inutiles des mots
    fun {FormatStr S}
        if BetterParsing then {Str.deleteCarBegin {Str.toLower S}} else S end
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
        if BetterParsing then
            {GetSampleHelperPort {Str.split Sentence [32]} nil nil P} %32 code Ascii de espace, donc on envoie les mots
        else
            {GetSampleHelperPort {Str.splitAndRemoveNotAlphaNum Sentence} nil nil P}
        end
    end
    
    %Fonctions parsant un fichier, fonctionnant avec un port, les résultats sont envoyés à celui-ci
    proc{ParseFile FileName P}
        if BetterParsing then
            {ParseFileHelper {File.getSentences FileName} P}
        else
            {ParseFileHelper {Str.split {File.readFile FileName} [10]} P}
        end
    end
    
    proc {ParseFileHelper Sentences P}
        case Sentences
        of nil then skip
        [] H|T then
            {GetSamplePort H P}
            {ParseFileHelper T P}
        end
    end
end