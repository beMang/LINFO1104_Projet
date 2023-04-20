%Fichier qui gère l'interface utilisateur

functor
import
    QTk at 'x-oz://system/wp/QTk.ozf'
	Application
	System
	Browser
export
    getDescription:GetDescription
	getEntry:GetEntry
	setOutput:SetOutput
	init:Init
	clear:Clear
define
	InputText OutputText

	%Construit la descrition de la fenêtre
    fun {GetDescription Press}
        Radio Check
        Menu=menu(command(text:"Command"
                    action:proc{$} {System.show command} end)
            separator
            checkbutton(text:"Checkbutton"
                        action:proc{$} {System.show checkbutton} end
                        init:false
                        return:Check)
            radiobutton(text:"Radiobutton 1"
                        action:proc{$} {System.show radiobutton} end
                        group:radiogroup
                        init:true
                        return:Radio)
             radiobutton(text:"Radiobutton 2"
                        action:proc{$} {System.show radiobutton} end
                        group:radiogroup
                        init:false)
            cascade(text:"Cascade"
                     action:proc{$} {System.show cascade} end
                     menu:menu(tearoff:false
                               radiobutton(text:"Radiobutton 3"
                                           action:proc{$} {System.show radiobutton} end
                                           group:radiogroup))))
        Description=td(
            title: "Text predictor"
            menubutton(glue:nw text:"File" menu:Menu)
            lr(
               text(handle:InputText width:50 height:10 background:white foreground:black wrap:word)
               td(
                  	button(text:"Predict" width:15 background:blue action:proc{$}X in X = {Press}end)
                  	button(text:"Save text" width:15 background:green action:proc{$}X in X = {Press}end) %Encore rien de fonctionel
                	button(text:"Exit" width:15 background:red action:proc{$}{Application.exit 0}end)
               )
            )
            text(handle:OutputText width:50 height:10 background:black foreground:white glue:w wrap:word)
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