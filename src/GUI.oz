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

	%Construit la description de la fenêtre
    fun {GetDescription Press}
        Radio Check
        Menu1=menu(
            command(text:"Sauvegarder" action: proc{$} X in X = 
                {File.save {Append {GetEntry} "\n"} "history.txt" true} 
                {DialogBox "Historique sauvegardé"}
            end) %Sauvegarde historique
            command(text:"Quitter"action:proc{$} {Application.exit 0} end)
            separator
            checkbutton(text:"Spawn window"
                        action:proc{$} {DialogBox "Ceci est un message"} end
                        init:false
                        return:Check)
            cascade(text:"Cascade"
                     action:proc{$} {System.show cascade} end
                     menu:menu(tearoff:false
                               radiobutton(text:"Radiobutton 3"
                                        action:proc{$} {System.show radiobutton} end
                                        group:radiogroup)
                                radiobutton(text:"Radiobutton 1"
                                        action:proc{$} {System.show radiobutton} end
                                        group:radiogroup
                                        init:true
                                        return:Radio)
                                radiobutton(text:"Radiobutton 2"
                                        action:proc{$} {DialogBox "Ceci est un message"} end
                                        group:radiogroup
                                        init:false)
                                )))
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
                    button(text:"Reload" width:15 height:2 background:green pady:5 action:Reload)
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
            message(aspect:400 init:Message padx:50 pady:50)
            button(text:"OK" width:4 background:green action:proc{$}X in {Window close} end)
            )
        Window={QTk.build Description}
    in
        {Window show}
    end

    proc {SelectDatasetWindow}
        Desc=td(
            checkbutton(text:"Default" action:proc{$} {System.show 'hey'} end)
            checkbutton(text:"History" init:true)
            checkbutton(text:"Custom1" init:true)
            button(text:"OK" width:4 background:green pady:5 action:proc{$}X in {Window close} end)
        )
        Window={QTk.build Desc}
    in
        {Window show}
    end

    %Lance le rechargement de l'arbre
    proc {Reload}
        {System.show {String.toAtom "Reloading ?"}}
        {OutputText tk(insert 'end' "Loading... Please wait.")}
        {Clear}
    end
end