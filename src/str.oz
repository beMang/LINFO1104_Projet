%Ce fichier s'appelle str pour éviter les conflits avec String, mais fait référence à la gestion des chaines de caractère dans le projet
functor
export
    compare:Compare
define
    fun{Compare String1 String2}
        %%compare deux mots, sans prendre en compte les majuscules 
        %s1= String1.1
        %s2= String2.1
        %if (s1 >90) then 
            %  s1=s1-32
        %end
        %if (s2>90) then 
            %  s2=s2-32
        %end
        if (String1.1>String2.1) then 
                1       %retourne une valeur positive si le premier string est plus loin dans l'alphabet que le 2e
        elseif (String1.1<String2.1) then
                ~1           %retourne une valeur négative si le premier string est plus tôt dans l'alphabet que le 2e
        else
            if (String1.2==nil) then 
                if (String2.2 ==nil) then 
                    0           %retourne 0 si les deux mots sont les mêmes
                else
                    ~1          %retourne une valeur négative si le premier string est le même que le 2e mais en plus court
                end
            
            elseif (String2.2==nil) then 
                    1              %retourne une valeur positive si le premier string est le meme que le 2e mais en plus long
            else
                    {Compare String1.2 String2.2}
                
            end
        end
    end
end