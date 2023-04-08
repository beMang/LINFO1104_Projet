functor  
import
	Open
    Browser
export  
  	readFile:ReadFile
    listAll:ListAllFiles
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

    proc {ListAllFiles L}
        case L of nil then skip
        [] H|T then {Browser.browse {String.toAtom H}} {ListAllFiles T}
        end
    end
end