declare 
proc {PrintNicely S Acc}
    case S
    of H|T then
            if H==10 then
                {Browse Acc}
                {PrintNicely T nil}
            else
                {PrintNicely T {List.append Acc H|nil}}
            end
        [] nil then {Browse Acc}
    end
end

local Result in
    File={New Open.file init(name:'learnings/to_read.txt' flags:[read])}
    {File read(list:Result size:all)}
    {PrintNicely Result nil}
    {File close}
end
