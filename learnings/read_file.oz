declare 
proc {PrintNicely S}
    local Temp in
        Temp = {NewCell ""}
        for C in S do
            if C==10 then
                {Browse @Temp}
                Temp:=""
            else
                Temp:={List.append @Temp C|nil}
            end
        end
        {Browse @Temp}
    end
end

local Result in
    File={New Open.file init(name:'learnings/to_read.txt' flags:[read])}
    {File read(list:Result size:all)}
    {PrintNicely Result}
    {File close}
end
