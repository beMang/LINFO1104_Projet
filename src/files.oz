functor  
import
	Open
    Browser
    Str at 'str.ozf'
export  
  	readFile:ReadFile
    getSentences:GetSentences
    getLines:GetLines
define 
   % Renvoie le contenu d'un fichier
    fun {ReadFile FileName}
        local Result File in
            File={New Open.file init(name:FileName flags:[read])}
            {File read(list:Result size:all)}
            {File close}
            Result
        end
    end

    %Renvoie les lignes d'un fichier
    fun {GetLines File}
        {Str.split {ReadFile File} [10]} %10 correspond au numéro ASCII du backspace
    end

    %Renvoie les phrases d'un fichier
    fun {GetSentences File}
        {Str.split {ReadFile File} [10 46 63 33]} %10->saut de ligne, 46->point, 63->point d'interrogation,33->point d'exclamation
    end
end