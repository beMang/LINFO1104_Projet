%Fichier qui gère l'interface utilisateur
functor
import
    QTk at 'x-oz://system/wp/QTk.ozf'
	Application
	System
    Save at 'save.ozf'
    Files at 'files.ozf'
    Str at 'str.ozf'
    Open
    Correction at 'correction.ozf'
export
    getDescription:GetDescription
	getEntry:GetEntry
	setOutput:SetOutput
	init:Init
	clear:Clear
define
	InputText OutputText

	%Construit la description de la fenêtre principale
    fun {GetDescription Press MyCorrection HandleMain}
        Radio Check C R
        Menu1=menu(
            command(text:"Reload" action: proc{$} {ReloadApp} end) %Remove on inginious submission for tests
            command(text:"Quitter"action:proc{$} {Application.exit 0} end)
        )
        Menu2=menu(
            command(text:"Add dataset" action:AddDataSetWindow) %Sauvegarde historique
            command(text:"Select datasets" action:SelectDatasetWindow)
            command(text: "Reset datasets" action:proc{$} {Save.resetDataSet} {DialogBox "Datasets successfully reset"} end)
        )
        Description=td(
            title: "Text predictor"
            1:{BuildMenu Menu1 Menu2}
            2:lr(
                1:td(
                    padx:5
                    text(handle:HandleMain width:60 height:15 background:white foreground:black wrap:word setgrid:true)
                    text(handle:OutputText width:60 height:15 background:black foreground:white glue:w wrap:word setgrid:true)
                )
                2:{BuildButtons
                    ['history' 'custom_dataset' 'correction']
                    td(padx:5 1:button(text:"Predict" width:15 height:2 background:blue pady:5 action:proc{$}{System.show {Press}}end))
                    2
                    MyCorrection
                }
            )
        	action:proc{$}{Application.exit 0} end % quitte le programme quand la fenetre est fermee
        )
		in
			Description
    end

    %Renvoie la description du menu en haut de l'application en fonction des extensions activées ou pas
    fun {BuildMenu Menu1 Menu2}
        if {Save.isExtensionActive 'custom_dataset'} then
            lr(menubutton(glue:nw text:"File" menu:Menu1)
                    menubutton(glue:nw text:"Dataset" menu:Menu2)
                    glue:nw
            )
        else
            lr(menubutton(glue:nw text:"File" menu:Menu1)
                glue:nw
            )
        end
    end

    %Construit la description des boutons en fonction de si les extensions sont activées ou pas
    fun {BuildButtons L Acc I CorrectionAction}
        case L 
        of nil then
            {Record.adjoin Acc td(padx:5 I:button(text:"Quit" width:15 height:2 background:red pady:5 action:proc{$}{Application.exit 0} end))}
        [] H|T then
            case H
            of 'correction' then
                if {Save.isExtensionActive H} then
                    {BuildButtons
                        T
                        {Record.adjoin Acc td(I:button(text:"Correction" width:15 height:2 background:yellow foreground:black pady:5 action:proc{$}{System.show {CorrectionAction}}end))}
                        I+1
                        CorrectionAction
                    }
                else {BuildButtons T Acc I CorrectionAction} end
            [] 'history' then
                if{Save.isExtensionActive H} then
                    {BuildButtons
                        T
                        {Record.adjoin Acc td(I:button(text:"Save" width:15 height:2 background:green pady:5 action:proc{$}
                            {Save.saveInHistory {GetEntry}}
                            {DialogBox "History saved"}end
                        ))}
                        I+1
                        CorrectionAction
                    }
                else {BuildButtons T Acc I CorrectionAction} end
            else {BuildButtons T Acc I CorrectionAction} end
        end
    end

	%Récupère le texte entré par l'utilisateur
	fun {GetEntry}
		{InputText get($)}
	end

	%Modifie le texte affiché
	proc {SetOutput Text}
		{OutputText set(1:Text)}
	end

    %Initialise l'interface et bind les raccourcis claviers (entre autre pour la complétion auto)
	proc {Init Press HandleInput}
        InputText = HandleInput
		{OutputText tk(insert 'end' "Loading... Please wait.")}
      	{InputText bind(event:"<Control-s>" action:proc{$}X in X = {Press}end)}
        if {Save.isExtensionActive 'automatic'} then
            {InputText bind(event:"<KeyPress-space>" action:proc{$}{System.show "Automatic"}end )}
            {InputText bind(event:"<KeyPress-BackSpace>" action:proc{$}{System.show "Automatic"}end )}
        end
	end

    %Nettoie les champs
	proc {Clear}
		{InputText set(1:"")}
		{OutputText set(1:"")}
	end

    %Fait apparaitre une nouvelle fenêtre
    proc {DialogBox Message}
        Description=td(
            title:""
            message(aspect:600 init:Message padx:50 pady:8)
            button(text:"OK" width:4 background:green action:proc{$} {Window close} end pady:8)
            )
        Window={QTk.build Description}
    in
        {Window show}
    end

    %Fenêtre pour choisir les datasets à utiliser
    proc {SelectDatasetWindow}
        DataSet = {Save.loadDataSet}
        DescriptionAndHandle={BuildDescDataSet DataSet [td(title:"Select datasets") h()] Window 1 DataSet}
        Desc = {Nth DescriptionAndHandle 1}
        Window={QTk.build Desc}
    in
        {Window show}
    end
    fun {BuildDescDataSet DataSet Acc Window Inc CompleteDataSet}
        case DataSet
        of nil then [
                    {Record.adjoin 
                        {Nth Acc 1}
                        td(Inc:button(text:"OK" width:4 background:green pady:5 action:proc{$} {CloseSelectDataSetWindow Window {Nth Acc 2} CompleteDataSet} end))
                    } 
                    {Nth Acc 2}
                    ]
        [] H|T then
            local Handle Key={String.toAtom H.key} in
                {BuildDescDataSet 
                    T 
                    [
                        {Record.adjoin {Nth Acc 1} td(Inc:checkbutton(glue:w handle:Handle text:H.key init:{Str.convertToBool H.value} padx:100 selectcolor:black))}
                        {Record.adjoin {Nth Acc 2} h(Key:Handle)}
                    ]
                    Window 
                    Inc+1
                    CompleteDataSet
                }
            end
        end
    end

    %Enregistre le dataset et ferme la fenêtre
    proc {CloseSelectDataSetWindow W Handles DataSet}
        NewDataSet={UpdateDataSetWithHandles Handles DataSet DataSet}
    in
        {Save.writeDataSet NewDataSet}
        {W close}
    end
    %Renvoie un dataset actualisé avec les valeurs du record Handles
    fun {UpdateDataSetWithHandles Handles DataSet Acc}
        case DataSet of nil then Acc
        [] H|T then
            local Key={String.toAtom H.key} Value={Handles.Key get($)} in
                {UpdateDataSetWithHandles Handles T {Save.setDataSet H.key {Str.convertBoolToStr Value} Acc}}
            end
        end
    end
    %Procédure effectuée par le bouton Add Dataset
    proc {AddDataSetWindow}
        InputAddHandle
        Desc=td(
            title:"Add dataset"
            text(handle:InputAddHandle background:white foreground:black width:20 height:2 pady:10)
            checkbutton(glue:w text:"Active" init:true padx:70 pady:5 selectcolor:black)
            button(text:"OK" width:4 background:green pady:5 action:proc{$} 
                if {Files.isDir {InputAddHandle get($)}} then
                    local DataSet in
                        DataSet={Save.setDataSet {InputAddHandle get($)} "true" {Save.loadDataSet}}
                        {Save.writeDataSet DataSet}
                    end
                    {Window close}
                else
                    {InputAddHandle set(1:"Dossier invalide")}
                end
            end)
        )
        Window={QTk.build Desc}
    in
        {Window show}
    end


    %TO REMOVE FOR INGINIOUS VERSION :
    %Pas déclaratif mais autorisé (source - forum moodle : https://moodle.uclouvain.be/mod/forum/discuss.php?d=82591)
    class Shell from Open.pipe Open.text 
        meth init 
           Open.pipe,init(cmd:"sh" args:["-s"])  
        end 
        meth cmd(Cmd)  
           Open.text,putS(Cmd)  
        end 
        meth show 
           case Open.text,getS($) of false then 
              {System.show 'Shell has died.'} {self close}
           elseof S then {System.show S}
           end 
        end 
    end

    %Redémarre l'application pour prendre en compte certaines modifications
    proc {ReloadApp}
        S = {New Shell init}
    in
        {S cmd('make run')}
        {S close}
        {Application.exit 0}
    end
end