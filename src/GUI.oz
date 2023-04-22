%Fichier qui gère l'interface utilisateur
functor
import
    QTk at 'x-oz://system/wp/QTk.ozf'
	Application
	System
    Save at 'save.ozf'
    Files at 'files.ozf'
export
    getDescription:GetDescription
	getEntry:GetEntry
	setOutput:SetOutput
	init:Init
	clear:Clear
define
	InputText OutputText

	%Construit la description de la fenêtre principale
    fun {GetDescription Press}
        Radio Check C R
        Menu1=menu(
            command(text:"Sauvegarder" action: proc{$}
                {Save.save {Append {GetEntry} "\n"} "history/history.txt" true}
                {DialogBox "Historique sauvegardé"}
            end) %Sauvegarde historique
            command(text:"Image" action:proc{$} {ShowImage} end)
            command(text:"Quitter"action:proc{$} {Application.exit 0} end)
        )
        Menu2=menu(
            command(text:"Add dataset" action:AddDataSetWindow) %Sauvegarde historique
            command(text:"Select datasets" action:SelectDatasetWindow)
            command(text: "Reset datasets" action:proc{$} {System.show 'reset datasets'} end)
        )
        Description=td(
            title: "Text predictor"
            lr(menubutton(glue:nw text:"File" menu:Menu1)
                menubutton(glue:nw text:"Dataset" menu:Menu2)
                glue:nw
            )
            lr(
                td(
                    padx:5
                    text(handle:InputText width:60 height:15 background:white foreground:black wrap:word setgrid:true)
                    text(handle:OutputText width:60 height:15 background:black foreground:white glue:w wrap:word setgrid:true)
                )
                td(
                    padx:5
                  	button(text:"Predict" width:15 height:2 background:blue pady:5 action:proc{$}X in X = {Press}end)
                    button(text:"Next" width:15 height:2 background:blue pady:5 action:proc{$} {System.show 'Show next proba'} end)
                    button(text:"Save" width:15 height:2 background:green pady:5 action:proc{$}
                        {Save.save {Append {GetEntry} "\n"} "history/history.txt" true}
                        {DialogBox "Historique sauvegardé"}end
                    )
                    button(text:"Quit" width:15 height:2 background:red pady:5 action:proc{$}{Application.exit 0} end)
               )
            )
        	action:proc{$}{Application.exit 0} end % quitte le programme quand la fenetre est fermee
        )
		in
			Description
    end

	%Récupère le texte entré par l'utilisateur
	fun {GetEntry}
		{InputText get($)}
	end

	%Modifie le texte affiché
	proc {SetOutput Text}
		{OutputText set(1:Text)}
	end

	proc {Init Press}
		{OutputText tk(insert 'end' "Loading... Please wait.")}
      	{InputText bind(event:"<Control-s>" action:proc{$}X in X = {Press}end)} %Bind events
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
        Handle
        Desc={BuildDescDataSet {Save.loadDataSet} td(title:"Select datasets") Window 2}
        Window={QTk.build Desc}
    in
        {Window show}
    end
    fun {BuildDescDataSet DataSet Acc Window Inc}
        case DataSet
        of nil then {Record.adjoin Acc td(button(text:"OK" width:4 background:green pady:5 action:proc{$} {Window close} end))}
        [] H|T then
            {BuildDescDataSet T {Record.adjoin Acc td(Inc:checkbutton(glue:w text:H.key init:true padx:100 selectcolor:black))} Window Inc+1}
        end
    end

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

    %Teste image Peter VR
    proc {ShowImage}
        Image = {QTk.newImage photo(url:'272331001_4808050022621105_5325763678366432642_n.png')}
        Desc = td(
            title:"Image"
            label(image:Image height:1000 width:1000)
        )
        Window={QTk.build Desc}
    in
        {System.show 'hey'}
        {Window show}
    end
end