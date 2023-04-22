functor
import
    Files at 'files.ozf'
    Str at 'str.ozf'
    Application
export
    getFoldersToLoad:GetFoldersToLoad
    save:Save
define
    %Permet d'écrire dans le dossier de sauvegarde
    %Content est le contenu à sauvegarder
    %Name le nom du fichier dans le dossier save
    %Append si le fichier doit être étendu ou pas
    fun {Save Content Name AppendF}
        if AppendF then
            {Files.appendFile {Append "save/" Name} Content}
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

    %Va lire le fichier de configuration save/custom_dataset pour aller voir les dossiers à charger
    fun {GetFoldersToLoad}
        {GetFoldersToLoadHelper {Files.getSentences "save/custom_dataset"} nil}
    end
    fun {GetFoldersToLoadHelper Lines Acc}
        L Key Value
    in
        case Lines
        of nil then Acc
        [] H|T then
            L = {Str.split H [32]} %Split l'espace
            Key = {Nth L 1}
            Value = {String.toAtom {Nth L 2}}
            if Key=="default" then
                if Value=='true' then
                    {GetFoldersToLoadHelper T {Append [{GetSentenceFolder}] Acc}}
                else
                    {GetFoldersToLoadHelper T Acc}
                end
            else
                if Value=='true' then {GetFoldersToLoadHelper T {Append [Key] Acc}}
                else {GetFoldersToLoadHelper T Acc} end
            end
        end
    end
end