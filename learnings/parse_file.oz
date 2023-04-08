% Sera utile pour parser les fichiers, pour l'instant ça prend un fichier et renvoie une liste où chaque élémément contient une phrase.

%_________________READ_A_FILE_____________
declare 
% Renvoie le contenu d'un fichier
fun {ReadFile FileName}
    local Result File in
        File={New Open.file init(name:FileName flags:[read])}
        {File read(list:Result size:all)}
        {File close}
        Result
    end
end
proc {PrintNicely S}
    {Browse {Split S [10]}}
end

%Vérifie si L contient C
fun {Contains L C}
    case L
    of nil then false
    []H|T then
        if H==C then true
        else
            {Contains T C}
        end
    end
end
%Vérifie si L contient au moins un des éléments dans Carr (Pas utile mais je laisse on sait jamais)
fun {ContainsOne L Carr}
    case L
    of nil then false
    []H|T then
        if {Contains Carr H}==true then true else {ContainsOne T Carr} end
    end
end


fun {SplitHelper S Carr Acc Result}
    if Carr==nil then %A la fin de la chaine donc on renvoie le résultat
        Result
    else
        case S
        of H|T then
            if {Contains Carr H} then
                if Acc==nil then %Si chaine de caractère vide on ne l'ajoute pas
                    {SplitHelper T Carr nil Result} 
                else 
                    {SplitHelper T Carr nil {List.append Result Acc|nil}}
                end
            else
                {SplitHelper T Carr {List.append Acc H|nil} Result}
            end
        [] nil then %Fini de traiter la chaine
            if Acc==nil then %Si chaine de caractère vide on ne l'ajoute pas
                {SplitHelper nil nil nil Result} 
            else
                {SplitHelper nil nil nil {List.append Result Acc|nil}}
            end
        end
    end
end

% Sépare une chaine de caractère en une liste de chaine de caractère
% Carr contient les caractères utilisés pour séparé la liste S
fun {Split S Carr}
    {SplitHelper S Carr nil nil}
end

%Renvoie les lignes d'un fichier
fun {GetLines File}
    {Split {ReadFile File} [10]} %10 correspond au numéro ASCII du backspace
end

%Renvoie les phrases d'un fichier
fun {GetSentences File}
    {Split {ReadFile File} [10 46 63 33]} %10->saut de ligne, 46->point, 63->point d'interrogation,33->point d'exclamation
end

{Browse {GetSentences "tweets/part_1.txt"}}
{PrintNicely {ReadFile "learnings/to_read.txt"}}