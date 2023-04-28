functor  
import
	Open
    Str at 'str.ozf'
    Save at 'save.ozf'
    OS
export  
  	readFile:ReadFile
    getSentences:GetSentences
    getLines:GetLines
    appendFile:AppendFile
    isDir:IsDir
    writeFileTruncate:WriteFileTruncate
    getAllFilesToLoad:GetAllFilesToLoad
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

    % Ajoute du contenu à un fichier et le réinitialise
    proc {WriteFileTruncate FileName Content}
        File={New Open.file init(name:FileName flags: [write create truncate] mode:  mode(owner: [read write] group: [read write]))}
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

    %Détermine si un dossier existe
    fun {IsDir DirName}
        X Result
    in
        try
            X = {OS.getDir DirName}
            Result = true
        catch system(...) then
            Result=false
        end
        Result
    end

    %--------------------------Fonctions plus spécifiques au projet----------------------


    %Renvoie tous les fichiers à charger selon le fichier de configuration
    fun {GetAllFilesToLoad}
        {GetAllFilesToLoadHelper {Save.getFoldersToLoad} nil}
    end
    fun {GetAllFilesToLoadHelper Folders Acc}
        case Folders
        of nil then Acc
        [] H|T then
            {GetAllFilesToLoadHelper T {Append Acc {AddFolderToListFile H {OS.getDir H} nil}}}
        end
    end

    %Fusionne une liste de fichiers en y ajoutant pour chaque élément de la liste le préfixe Folder
    fun {AddFolderToListFile Folder F Acc}
        case F
        of nil then Acc
        [] H|T then
            {AddFolderToListFile Folder T {Append Acc [{Append Folder {Append "/" H}}]}} %Fusion du type folder/file
        end
    end
end