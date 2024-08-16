local generalFunctions = {}

function generalFunctions.getRamInDict(dict)
    local ram = {}

    for k, v in pairs(dict) do
        table.insert(ram, k)
    end
    return ram[math.random(1,#ram)]
end

return generalFunctions