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

function util.rainbow(str, type, freq)
	-- default settings, set to default if out-of-bounds
	type = type or 0
	if type > 2 or type < 0 then type = 0 end

	freq = freq or 15

	if freq < 0 or freq > 360 then freq = 15 end

	local product = ""
	local phase = 2 * math.pi / 3

	local rand = util.betterrand()


	if type == 0 then -- Non-repeating rainbow
		freq = 2*math.pi / #str
		for i = 1, #str do
			if string.sub(str, i, i) == " " then
				product = product..string.sub(str, i, i)
			else
				r = math.sin(freq*i + phase + rand*10) * 127 + 128
				g = math.sin(freq*i + 0 + rand*10) * 127 + 128
				b = math.sin(freq*i + 2*phase + rand*10) * 127 + 128
				r = string.format("%x", r)
				g = string.format("%x", g)
				b = string.format("%x", b)

				if #r < 2 then r = "0"..r end
				if #g < 2 then g = "0"..g end
				if #b < 2 then b = "0"..b end
				product = product.."|c"..r..g..b..string.sub(str, i, i)
			end
		end
	elseif type == 1 then -- Repeating rainbow

		freq = freq * math.pi / 180
		for i = 1, #str do
			--if string.sub(str, i, i) == " " then
			--	product = product..string.sub(str, i, i)
			--else
				r = math.sin(freq*i + phase + rand*10) * 127 + 128
				g = math.sin(freq*i + 0 + rand*10) * 127 + 128
				b = math.sin(freq*i + 2*phase + rand*10) * 127 + 128
				r = string.format("%x", r)
				g = string.format("%x", g)
				b = string.format("%x", b)

				if #r < 2 then r = "0"..r end
				if #g < 2 then g = "0"..g end
				if #b < 2 then b = "0"..b end
				product = product.."|c"..r..g..b..string.sub(str, i, i)
			--end
		end
	elseif type == 2 then -- Old, uglier rainbow
		local colours = { "|cFF0000", "|cFF6600", "|cFFEE00", "|c00FF00", "|c0099FF", "|c4400FF", "|c9900FF" }
		local pass = math.random(7)

		for char in str:gmatch"." do
			--if char == " " then
			--	product = product .. char
			--else
				product = product .. colours[pass] .. char
				if pass == #colours then pass = 1 end
					pass = pass + 1
			--end
		end
	end
	return product.."|r"
end
 
function util.betterrand()
	local randomtable = {}
	for i = 1, 97 do
		randomtable[i] = math.random()
	end
	local x = math.random()
	local i = 1 + math.floor(97*x)
	x, randomtable[i] = randomtable[i], x
	return x
end


return util
