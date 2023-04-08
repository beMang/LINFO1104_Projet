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


%_______________LIST_AUX_________________ - Auxiliaire pour les listes/strings
% Affiche le contenu d'une liste
proc {PrintList L}
    case L
    of nil then skip
    [] H|T then
        if {IsString H} then % Pour afficher proprement les strings
            {Browse {String.toAtom H}}
        else
            {Browse H}
        end
        {PrintList T}
    end
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


%_______________PARSE_________________
fun {GetPossibilitiesHelper WordsL Word1 Word2 Result}
    case WordsL
    of nil then Result
    [] H|T then
        if Word1==nil then
            {GetPossibilitiesHelper T H Word2 Result} %Initialiser
        else
            if Word2==nil then
                {GetPossibilitiesHelper T Word1 H Result} %Initialiser
            else
                {GetPossibilitiesHelper T Word2 H {List.append Result sample(w1:Word1 w2:Word2 val:H)|nil}} %C'est ici qu'on va choisir le format des éléments (ici une liste avec 3 éléments)
            end
        end
    end
end
fun {GetPossibilities Sentence}
    {GetPossibilitiesHelper {Split Sentence [32]} nil nil nil} %32 code Ascii de espace, donc on envoie les mots
end

fun{ParseFileHelper SentenceArray Acc}
    case SentenceArray
    of nil then Acc
    [] H|T then
        {ParseFileHelper T {List.append Acc {GetPossibilities H}}}
    end
end
fun {ParseFile File}
    {ParseFileHelper {GetSentences File} nil}
end

%___________TESTS______________ Quelques tests pour voir comment ça se comporte

P = "Ceci est une phrase avec quelques mots et j'aimerais avoir la liste des mots qui se suivent"
L1 = {GetPossibilities P}
{PrintList L1} %Seem to work

%Seem to work too
L2 = {ParseFile "others/to_read.txt"}
{Browse L2}
{PrintList L2}

%Example of nice print
L3 = ["Hello" "Je suis @"]
{PrintList L3}

%TO-DO better-parse :
% Format word, handle special character (how ?)