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
            command(text:"Sauvegarder" action: proc{$} X in X = {File.save {Append {GetEntry} "\n"} "history.txt" true} end) %Sauvegarde historique
            command(text:"Quitter"action:proc{$} {Application.exit 0} end)
            separator
            checkbutton(text:"Checkbutton"
                        action:proc{$} {System.show checkbutton} end
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
                                        action:proc{$} {System.show radiobutton} end
                                        group:radiogroup
                                        init:false)
                                )))
        Description=td(
            title: "Text predictor"
            lr(menubutton(glue:nw text:"File" menu:Menu1)
                glue:nw
            )
            lr(
                glue:nwse
                text(handle:InputText width:60 height:15 background:white foreground:black wrap:word setgrid:true)
                td(
                    glue:se
                  	button(text:"Predict" width:15 height:2 background:blue action:proc{$}X in X = {Press}end)
               )
            )
            text(handle:OutputText width:60 height:15 background:black foreground:white glue:w wrap:word setgrid:true)
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
		{InputText tk(insert 'end' "Loading... Please wait.")}
      	{InputText bind(event:"<Control-s>" action:proc{$}X in X = {Press}end)} %Bind events
	end

	proc {Clear}
		{InputText set(1:"")}
		{OutputText set(1:"")}
	end
end