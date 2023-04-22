functor  
import
	Open
    Str at 'str.ozf'
    OS
    Application
export  
  	readFile:ReadFile
    getSentences:GetSentences
    getLines:GetLines
    appendFile:AppendFile
    save:Save
    getSentenceFolder:GetSentenceFolder
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

    % Ajoute du contenu à un fichier
    proc {AppendFile FileName Content}
    File={New Open.file init(name:FileName flags: [write create append] mode:  mode(owner: [read write] group: [read write]))}
    in
        {File write(vs:Content)}
        {File close}
    end

    %Renvoie les lignes d'un fichier
    fun {GetLines File}
        {Str.split {ReadFile File} [10]} %10 correspond au numéro ASCII du backspace
    end

    %Renvoie les phrases d'un fichier
    fun {GetSentences File}
        {Str.split {ReadFile File} [10 46 63 33 34 40 41]} %10->saut de ligne, 46->point, 63->point d'interrogation,33->point d'exclamation, 34-> guillemet, 40 41-> parenthèses
    end

    %Permet d'écrire dans le dossier de sauvegarde
    %Content est le contenu à sauvegarder
    %Name le nom du fichier dans le dossier save
    %Append si le fichier doit être étendu ou pas
    fun {Save Content Name AppendF}
        if AppendF then
            {AppendFile {Append "save/" Name} Content}
            0
        else
            ~1 %TODO
        end
    end

    % Fetch Tweets Folder from CLI Arguments
    % See the Makefile for an example of how it is called
    fun {GetSentenceFolder}
        Args = {Application.getArgs record('folder'(single type:string optional:false))}
    in
        Args.'folder'
    end
end