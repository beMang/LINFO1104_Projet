%Fichier qui gère l'interface utilisateur
functor
import
    QTk at 'x-oz://system/wp/QTk.ozf'
	Application
	System
	Browser
    File at 'files.ozf'
export
    getDescription:GetDescription
	getEntry:GetEntry
	setOutput:SetOutput
	init:Init
	clear:Clear
define
	InputText OutputText

	%Construit la description de la fenêtre principale
    fun {GetDescription Press ReloadProc}
        Radio Check C R
        Menu1=menu(
            command(text:"Sauvegarder" action: proc{$} X in X= 
                {File.save {Append {GetEntry} "\n"} "history.txt" true} 
                {DialogBox "Historique sauvegardé"}
            end) %Sauvegarde historique
            command(text:"Quitter"action:proc{$} {Application.exit 0} end)
        )
        Menu2=menu(
            command(text:"Add dataset" action:proc{$} {System.show 'new dataset'} end) %Sauvegarde historique
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
                    button(text:"Reload" width:15 height:2 background:green pady:5 action:proc{$} {Reload ReloadProc}end)
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
        Desc=td(
            title:"Select datasets"
            checkbutton(glue:w text:"Default" init:true padx:100 handle:Handle selectcolor:black)
            checkbutton(glue:w text:"History" init:true padx:100 selectcolor:black)
            checkbutton(glue:w text:"Custom1" init:false padx:100 selectcolor:black)
            button(text:"OK" width:4 background:green pady:5 action:proc{$} {Window close} end)
        )
        Window={QTk.build Desc}
    in
        {Window show}
    end

    %Lance le rechargement de l'arbre
    proc {Reload MyReload}
        {MyReload}
        {OutputText tk(insert 'end' "Loading... Please wait.")}
        {Clear}
    end
    %Teste image Peter VR
    fun {MyImage}
        {QTk.newImage photo(file: '/home/laura/oz-projet-twitoz/src/272331001_4808050022621105_5325763678366432642_n.pgm')}
    end
end