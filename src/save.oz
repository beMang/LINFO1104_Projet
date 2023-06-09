functor %Module qui gère tout ce qui est sauvegarde de l'historique ainsi que des base de données custom à utiliser ou pas
import
    Files at 'files.ozf'
    Str at 'str.ozf'
    Application
export
    getFoldersToLoad:GetFoldersToLoad
    save:Save
    isExtensionActive:IsExtensionActive
    loadDataSet:LoadDataSet
    resetDataSet:ResetDataSet
    setDataSet:SetDataset
    writeDataSet:WriteDataSet
    saveInHistory:SaveInHistory
define
    %Permet d'écrire dans le dossier de sauvegarde
    %Content est le contenu à sauvegarder
    %Name le nom du fichier dans le dossier save
    %AppendF si le fichier doit être étendu ou pas
    proc {Save Content Name AppendF}
        if Content==nil then skip
        elseif Content=="\n" then skip
        else
            if AppendF then
                {Files.appendFile {Append "save/" Name} Content}
            else
                {Files.writeFileTruncate {Append "save/" Name} Content}
            end
        end
    end

    fun {GetArgs}
        {Application.getArgs record(
            'folder'(single type:string optional:false) 
            'custom_dataset'(single type:string default:false optional:false)
            'history'(single type:string default:false optional:false)
            'automatic'(single type:string default:false optional:false)
            'better_parse'(single type:string default:false optional:false)
            'more_gramme'(single type:string default:false optional:false)
        )}
    end
    
    % Fetch Tweets Folder from CLI Arguments
    % Voir le Makefile pour un exemple d'appel de cette fonction
    fun {GetSentenceFolder}
        Args = {GetArgs}
    in
        Args.'folder'
    end

    fun {IsExtensionActive Name}
        Args = {GetArgs}
    in
        if Args.Name=="true" then true else false end
    end

    fun {GetHistoryFolder}
        "save/history/"
    end

    proc {InitHistory}
        DataSet={LoadDataSet}
        UpdateDataSet
    in
        if {DataSetExist "History" DataSet}==false then %Si la clé n'est pas initialisée
            UpdateDataSet={SetDataset "History" "false" DataSet}
            {WriteDataSet UpdateDataSet}
        end
    end
    %Sauve dans l'historique ce qui est écrit par l'utilisateur
    proc {SaveInHistory Content}
        {Save {Append Content "\n"} "history/history" true}
        {InitHistory}
    end

    %Va lire le fichier de configuration save/custom_dataset pour aller voir les dossiers à charger
    fun {GetFoldersToLoad}
        if {IsExtensionActive 'custom_dataset'} == true then %Si on demande de charger d'autres base de donnée
            {GetFoldersToLoadHelper {LoadDataSet} nil}
        else
            [{GetSentenceFolder}]
        end
    end
    fun {GetFoldersToLoadHelper Lines Acc}
        case Lines
        of nil then Acc
        [] H|T then
            if H.key=="Default" then
                if H.value=="true" then
                    {GetFoldersToLoadHelper T {Append [{GetSentenceFolder}] Acc}}
                else
                    {GetFoldersToLoadHelper T Acc}
                end
            elseif H.key=="History" then
                if H.value=="true" then
                    {GetFoldersToLoadHelper T {Append [{GetHistoryFolder}] Acc}}
                else
                    {GetFoldersToLoadHelper T Acc}
                end
            else
                if H.value=="true" then
                    if {Files.isDir H.key} then {GetFoldersToLoadHelper T {Append [H.key] Acc}}
                    else 
                        {Exception.error "Dossier invalide dans les datasets sélectionnés"}
                        {GetFoldersToLoadHelper T Acc} 
                    end
                else {GetFoldersToLoadHelper T Acc} end
            end
        end
    end

    %Dataset management - code permettant de gérer les bases de données à utiliser

    %Renvoie un dataset avec la clé name:active ajoutée/mise à jour
    fun {SetDataset Name Active DataSet}
        if {DataSetExist Name DataSet} then
            {ReplaceKey Name Active DataSet nil}
        else {Append DataSet [set(key:Name value:Active)]} end
    end
    fun {ReplaceKey Name Active DataSet Acc}
        case DataSet
        of nil then Acc
        [] H|T then
            if H.key==Name then
                {ReplaceKey Name Active T {Append Acc [set(key:Name value:Active)]}}
            else
                {ReplaceKey Name Active T {Append Acc [set(key:H.key value:H.value)]}}
            end
        end
    end

    %Réinitialise le dataset avec le default à true et history à false
    proc {ResetDataSet}
        ResetDataSet = [set(key:"Default" value:"true") set(key:"History" value:"false")]
    in
        {WriteDataSet ResetDataSet}
    end

    %Vérifie si le set de donnée existe
    fun{DataSetExist Name DataSet}
        {DataSetExistHelper Name DataSet}
    end
    fun {DataSetExistHelper Name Datas}
        case Datas
        of nil then false
        [] H|T then
            if H.key==Name then true
            else {DataSetExistHelper Name T} end
        end
    end

    %Récupère une clé spécifique
    fun {GetKey Name DataSet}
        {GetKeyHelper Name DataSet}
    end
    fun {GetKeyHelper Name Datas}
        case Datas
        of nil then false
        [] H|T then
            if H.key==Name then H.value
            else {DataSetExistHelper Name T} end
        end
    end

    %Renvoie une liste de record du type (key:dossier_set value:active_ou_pas)
    fun{LoadDataSet}
        {LoadDataSetHelper {Files.getSentences "save/custom_dataset"} nil}
    end
    fun{LoadDataSetHelper Lines Acc}
        L
    in
        case Lines
        of nil then Acc
        [] H|T then
            L = {Str.split H [32]}
            {LoadDataSetHelper T {Append Acc [set(key: {Nth L 1} value: {Nth L 2})]}}
        end
    end

    %Sauvegarde un dataset sur le disque dur
    proc{WriteDataSet Datas}
        ToWrite = {DataSetToText Datas nil}
    in
        {Save ToWrite "custom_dataset" false}
    end

    %Prend un dataset et le converti en texte pour l'écrire dans un fichier
    fun {DataSetToText Datas Acc}
        case Datas
        of nil then Acc
        [] H|T then
            {DataSetToText T {Append Acc {Append H.key {Append " " {Append H.value "\n"}}}}}
        end
    end
end
