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
            command(text:"Save" action: proc{$}
                {Save.save {Append {GetEntry} "\n"} "history/history.txt" true}
                {DialogBox "History saved"}
            end) %Sauvegarde historique
            command(text:"Reload" action: proc{$} {ReloadApp} end)
            command(text:"Image" action:proc{$} {ShowImage} end)
            command(text:"Quitter"action:proc{$} {Application.exit 0} end)
        )
        Menu2=menu(
            command(text:"Add dataset" action:AddDataSetWindow) %Sauvegarde historique
            command(text:"Select datasets" action:SelectDatasetWindow)
            command(text: "Reset datasets" action:proc{$} {Save.resetDataSet} {DialogBox "Datasets successfully reset"} end)
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
                    button(text:"Next" width:15 height:2 background:yellow foreground:black pady:5 action:proc{$} {System.show 'Show next proba'} end)
                    button(text:"Save" width:15 height:2 background:green pady:5 action:proc{$}
                        {Save.saveInHistory {GetEntry}}
                        {DialogBox "History saved"}end
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

    %Reloading the app :
    proc {ReloadApp}
        S = {New Shell init}
    in
        {S cmd('make run')}
        {S close}
        {Application.exit 0}
    end
end