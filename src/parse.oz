functor  
import
    File at 'files.ozf'
    Str at 'str.ozf'
    Tree at 'tree.ozf'
    Browser
export
    parseFile:ParseFile
    parseFiles:ParseFiles
    getTreeFromList:GetTreeFromList
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

    fun {ParseFilesHelper N End Folder Acc}
        if N==End then Acc
        else
            local FileName in
                FileName = {Append "/part_" {Append {IntToString N} ".txt"}} %Nom du fichier twitter, rendre ça + modulable
                {ParseFilesHelper N+1 End Folder {Append {ParseFile {Append Folder FileName}} Acc}}
            end
        end
    end
    fun {ParseFiles Begin End Folder}
        {ParseFilesHelper Begin End Folder nil}
    end

    fun {GetTreeFromListHelper L Acc}
        case L
        of nil then Acc
        [] H|T then %H is a sample
            {GetTreeFromListHelper T {Tree.insertInBigTree H.w1 H.w2 {String.toAtom H.val} Acc}} %Pas oublier la conversion en atom
        end
    end
    fun {GetTreeFromList L}
        {GetTreeFromListHelper L nil}
    end


end