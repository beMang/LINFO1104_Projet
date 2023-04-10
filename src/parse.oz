functor  
import
    File at 'files.ozf'
    Str at 'str.ozf'
export
    parseFile:ParseFile
define
    fun {FormatStr S}
        {Str.toLower S}
    end
    fun {GetSampleHelper WordsL Word1 Word2 Result}
        case WordsL
        of nil then Result
        [] H|T then
            if Word1==nil then
                {GetSampleHelper T H Word2 Result} %Initialiser
            else
                if Word2==nil then
                    {GetSampleHelper T Word1 H Result} %Initialiser
                else
                    {GetSampleHelper T Word2 H {List.append Result sample(
                        w1:{FormatStr Word1} 
                        w2:{FormatStr Word2} 
                        val:{FormatStr H}
                    )|nil}} %C'est ici qu'on va choisir le format des éléments sample (record ici)
                end
            end
        end
    end
    fun {GetSample Sentence}
        {GetSampleHelper {Str.split Sentence [32]} nil nil nil} %32 code Ascii de espace, donc on envoie les mots
    end
    
    fun{ParseFileHelper SentenceArray Acc}
        case SentenceArray
        of nil then Acc
        [] H|T then
            {ParseFileHelper T {List.append Acc {GetSample H}}}
        end
    end
    fun {ParseFile FileName}
        {ParseFileHelper {File.getSentences FileName} nil}
    end
end