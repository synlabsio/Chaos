--[[
    Chaos: Common shared functions.
]]

local util = {}

function util.timestamp()
    local h, m, s, ms = getTime().hour,
    getTime().min,
    getTime().sec,
    getTime().msec

    local time = h..":"..m..":"..s..":"..ms
  
    return cecho(" <coral>[<sienna>"..time.."<coral>]")
end

function util.round(num, idp)
    local mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function util.randomstring(length, pattern)
    local f = ""
    for loop = 0, 255 do
        f = f .. string.char(loop)
    end

    local pattern, random = pattern or '.', ''
    local str = string.gsub(f, '[^' .. pattern .. ']', '')
    for loop = 1, length do
        random = random .. string.char(string.byte(str, math.random(1, string.len(str))))
    end

    return random
end

function util.shallowcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else
		copy = orig
	end
	return copy
end

function util.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[util.deepcopy(orig_key)] = util.deepcopy(orig_value)
        end
        setmetatable(copy, util.deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end


function util.mergetable(table1, table2)
	local results = util.copytable(table1)
	for k, v in pairs(table2) do
		table.insert(results, v)
	end

	return results
end


function util.counttable(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end

    return count
end

function util.gagprompt()
    if chaos.debugmode then return false end
    selectString(line, 1)
    replace("")
    resetFormat()
    tempLineTrigger(1, 1, [[
        if isPrompt() then deleteLine() end
        ]])
end

function util.dehex(h)
    local i
    local s = ""
    for i = 1, #h, 2 do
        high = ascii_to_num(string.byte(h,i))
        low = ascii_to_num(string.byte(h,i+1))
        s = s .. string.char((high*16)+low)
    end
    return s
end


function util.asciitonum(c)
    if (c >= string.byte("0") and c <= string.byte("9")) then
        return c - string.byte("0")
    elseif (c >= string.byte("A") and c <= string.byte("F")) then
        return (c - string.byte("A"))+10
    elseif (c >= string.byte("a") and c <= string.byte("f")) then
        return (c - string.byte("a"))+10
    else
        echo("Wrong input for ascii to num convertion.")
    end
end


function util.concatwithand(t)
	assert(type(t) == "table", "util.concatwithand(): argument must be a table")

	if #t == 0 then
		return ""
	elseif #t == 1 then
		return t[1]
	else
		return table.concat(t, ", ", 1, #t - 1).." and "..t[#t]
	end
end


function util.truncatestring(txt, length)
	if not type(txt) == "string" or #txt <= length then return txt end
	return string.sub(txt, 1, length-3).."..."
end

function util.loadtable(t, func)
	if not chaos.conf[t] then
		local location = getMudletHomeDir().. "/chaos.conf."..t..".lua"

		chaos.conf[t] = {}

		if io.exists(location) then
			table.load(location, chaos.conf[t])
        else
            chaos.cprint.error(" >>> FATAL ERROR: util.loadtable(): Location is nil!")
		end

	end

	if func and type(func) == "function" then
		func()
	end
end

function util.savetable(t)
	local location = getMudletHomeDir().."/chaos.conf."..t..".lua"
	table.save(location, chaos.conf[t])
end

return util
