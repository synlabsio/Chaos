--[[
    zDATA standalone module port.
]]

local zData = {}

zData.bardName = "Jaskier"
zData.bardVoice = " with a melodic voice"

function zData.echo(text)
    hecho(rainbow("\n"..zData.bardName..", appears strumming his lute to a tune of your greatness.\nEager to record your recent hunt in lavish detail and song, "..zData.bardName.." frantically works his quill."))
    cecho("\n\n<gold>"..zData.bardName.."<cyan> says to you"..zData.bardVoice..", \"Quite the slaughter you had at "..text.."\"\n\n")
end

zData.deleteAble = false

createStopWatch("zoneHuntWatch")
stopStopWatch("zoneHuntWatch")
resetStopWatch("zoneHuntWatch")

zData.db = {}

zData.defs = {}

zData.char = {
    lastArea = "NA",
    tempTime = 0,
    minuteTime = 0,
    xpGains = 0,
    xpGainsMin = 0,
    killsPerMinute = 0,
    totalAttacks = 0,
    crithits = 0,
    crit1 = 0,
    crit2 = 0,
    crit3 = 0,
    crit4 = 0,
    crit5 = 0,
    crit6 = 0,
    searedglyph = 0,
    shield = 0,
    paragon = 0,
    mayafigure = 0,
    ogold = 0,
    gold = 0,
    gpm = 0,
    xp = 0,
    oxp = 0,
    str = 0,
    dex = 0,
    int = 0,
    con = 0,
    killsCount = 0,
    killList = {},
    taliCount = 0,
    taliList = {},
    when = 0,
}

zData.classList =  {
    ["alchemist"] = {["int"] = zData.char.int,},
    ["apostate"] = {["int"] = zData.char.int,},
    ["bard"] = {["str"] = zData.char.str,},
    ["blademaster"] = {["str"] = zData.char.str,},
    ["depthswalker"] = {["str"] = zData.char.str,},
    ["druid"] = {["str"] = zData.char.str,},
    ["infernal"] = {["str"] = zData.char.str,},
    ["jester"] = {["str"] = zData.char.str,},
    ["magi"] = {["int"] = zData.char.int,},
    ["monk"] = {["str"] = zData.char.str,["int"] = zData.char.int,},
    ["occultist"] = {["int"] = zData.char.int,},
    ["paladin"] = {["str"] = zData.char.str,},
    ["pariah"] = {["int"] = zData.char.int,},
    ["priest"] = {["int"] = zData.char.int,},
    ["psion"] = {["str"] = zData.char.str,["int"] = zData.char.int,},
    ["runewarden"] = {["str"] = zData.char.str,},
    ["sentinel"] = {["str"] = zData.char.str,},
    ["serpent"] = {["dex"] = zData.char.dex,},
    ["shaman"] = {["int"] = zData.char.int,},
    ["sylvan"] = {["int"] = zData.char.int,},
    ["unnamable"] = {["str"] = zData.char.str,},
    ["red dragon"] = {["str"] = zData.char.str,["int"] = zData.char.int,},
    ["blue dragon"] = {["str"] = zData.char.str,["int"] = zData.char.int,},
    ["gold dragon"] = {["str"] = zData.char.str,["int"] = zData.char.int,},
    ["silver dragon"] = {["str"] = zData.char.str,["int"] = zData.char.int,},
    ["green dragon"] = {["str"] = zData.char.str,["int"] = zData.char.int,},
    ["black dragon"] = {["str"] = zData.char.str,["int"] = zData.char.int,},
    ["dragon"] = "na",
    ["elemental"] = "na"
}

db:create("exp_db", 
  {
    zones={             
      "area",
      "class",
      "boost",
      "critpercent",
      "time",
      "epm",
      "exp",
      "kill",
      "kpm",
      "gold",
      "gpm",
      "str",
      "dex",
      "int",
      "con",  
      "attacks",
      "crits","crits1","crits2","crits3","crits4","crits5","crits6",
      "soa",
      "soaparagon",
      "glyph",
      "maya",
      "tali",
      "killlist",
      "talilist",
      "when",
      },
  })                                                 -- This creates database exp_db (if not already)
zData.db.expdb = db:get_database("exp_db")           -- This assigns the database name to a variable for ease of use purposes.
 
-------------------------------------------------
--                                             --
--  Add a new records: zData.db.zoneAdd(stuff) --
--                                             --
-------------------------------------------------
function zData.db.zoneAdd(area, class, boost, critpercent, time, epm, exp, kill, kpm, gold, gpm, str, dex, int, con, attacks, crits, crits1, crits2, crits3, crits4, crits5, crits6, soa, soaparagon, glyph, maya, tali, killlist, talilist, when)
  db:add(zData.db.expdb.zones,{
    area=area, class=class, boost=boost, critpercent=critpercent, 
    time=time, epm=epm, exp=exp, kill=kill, kpm=kpm, gold=gold, gpm=gpm, 
    str=str, dex=dex, int=int, con=con, 
    attacks=attacks, crits=crits, crits1=crits1, crits2=crits2, crits3=crits3, crits4=crits4, crits5=crits5, crits6=crits6, 
    soa=soa, soaparagon=soaparagon, glyph=glyph, maya=maya, 
    tali=tali, 
    killlist=killlist, 
    talilist=talilist,
    when=when})
  --zData.echo("<magenta>"..area.."<cyan>\! <NavajoWhite>"..string.cut(exp,5).."<cyan> experience. <NavajoWhite>"..string.cut(kpm,4).."<cyan> KPM!")
end

-------------------------------------------------
--                                             --
--  Simple Add +1 : zData.db.addChar(addThis)  --
--                                             --
-------------------------------------------------
function zData.db.addChar(addThis)
  zData.char[addThis] = zData.char[addThis] + 1
end

------------------------------------------------------------
--                                                        --
-- Sort Database: zData.db.showData(sortWith, sortStyle)  --
--                                                        --
-- sortWith = Class / all / area search                   --
-- sortStyle = exp / epm / kill / kpm                     --
--                                                        --
------------------------------------------------------------
function zData.db.showData(sortWith, sortStyle, sortDirection)           -- This is my spaghetti code function 
  if zData.hunter then
    zData.hunter.window:show()
  else
    zData.buildHunter()
  end
  zData.db.localDB = {}                                   -- This is the table for sorting and display database results
  local maxShow = 40                     ------<--<--<--<--< Max number of results to show unless ALL is used. Increase to see more (Over 200 will not allow deleting)
  local titleColor = "gold" 
  local menuColor = "purple" 
  local areaColor = "ansiMagenta"
  local classColor = "purple"
  local taliColor = "ansiMagenta"
  local timeColor = "ansiMagenta"
  
  local critColor = "ansiMagenta"
  
  local killColor = "ansiMagenta"
  local kpmColor = "ansiMagenta"
  local expColor = "ansiMagenta"
  local epmColor = "ansiMagenta"
  local gpmColor = "ansiMagenta"
  local goldColor = "ansiMagenta"
  local showCount = 0  

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Show Rows Based on Sorting  
  local function showCharts(thisChart, thisRow)
    if sortDirection and sortDirection == "down" then
      for _, row in spairs(zData.db.localDB) do
        if row[thisChart] == "" then
          row[thisChart] = 0
        end
      end
    
      for _, row in spairs(zData.db.localDB, function(t,a,b) return tonumber(t[a][thisChart]) < tonumber(t[b][thisChart]) end) do    
-------------------------- Limit results to MAXSHOW        
        if sortWith and string.lower(sortWith) == "all" then 
          zData.deleteAble = false
        else 
          if maxShow < 240 then zData.deleteAble = true end
          showCount = showCount + 1
          if showCount >= maxShow then break end      
        end
--------------------------- Blackout 0 talisman counts        
        if tonumber(row.tali) < 1 then taliColor = "black:black" else 
          if thisChart == "tali" then
            taliColor = "gold" 
          else
            taliColor = "ansiMagenta" 
          end
        end    
--------------------------- Blackout 0 crit counts     
        if thisChart == "critpercent" then   
          if tonumber(row.critpercent) < 1 then 
            critColor = "black:black"
          else  
            critColor = "gold"
          end         
        end    
--------------------------- Display Each Row From The Database, Clickable For More Information
        cechoLink("hunterDisplay", 
          "\n  <"..areaColor..">"..string.cut(row.area.."                   ", 20)
          .." <"..classColor..">"..string.cut(row.class.."            ", 13)
          .. " <"..taliColor..">"..string.cut(string.cut(row.tali,2).."   ", 4)
          .. " <"..timeColor..">"..string.cut(string.cut((row.time/60), 4).."      ", 6)

          .. "  <"..critColor..">"..string.cut(string.cut(row.critpercent, 4).."     ", 5)  

          .. " <"..killColor..">"..string.cut(string.cut(row.kill,4).."     ", 6)
          ..  " <"..kpmColor..">"..string.cut(string.cut(row.kpm,4).."     ", 6)
          ..  " <"..expColor..">"..string.cut(string.cut(row.exp,4).."     ", 6)
          ..  " <"..epmColor..">"..string.cut(string.cut(row.epm,5).."      ", 7)
          ..  " <"..gpmColor..">"..string.cut(string.cut(math.floor(row.gpm),6).."       ", 8) 
          .. " <"..goldColor..">"..string.cut(row.gold .."      ", 7),
        ---------------------------------------------------------------------------------  
          [[zData.db.clickback(]].._..[[)]], [[]], true)                               -- What to do when clicked on
        --------------------------------------------------------------------------------- 
      end --- End of for _,row
    else
      for _, row in spairs(zData.db.localDB) do
        if row[thisChart] == "" then
          row[thisChart] = 0
        end
      end
          
      for _, row in spairs(zData.db.localDB, function(t,a,b) return tonumber(t[a][thisChart]) > tonumber(t[b][thisChart]) end) do    
-------------------------- Limit results to MAXSHOW        
        if sortWith and string.lower(sortWith) == "all" then 
          zData.deleteAble = false
        else 
          if maxShow < 240 then zData.deleteAble = true end
          showCount = showCount + 1
          if showCount >= maxShow then break end      
        end
--------------------------- Blackout 0 talisman counts        
        if tonumber(row.tali) < 1 then taliColor = "black:black" else 
          if thisChart == "tali" then
            taliColor = "gold" 
          else
            taliColor = "ansiMagenta"
          end
        end    
--------------------------- Blackout 0 crit counts     
        if thisChart == "critpercent" then   
          if tonumber(row.critpercent) < 1 then 
            critColor = "black:black"
          else  
            critColor = "gold"
          end         
        end    
--------------------------- Display Each Row From The Database, Clickable For More Information
        cechoLink("hunterDisplay", 
          "\n  <"..areaColor..">"..string.cut(row.area.."                   ", 20)
          .." <"..classColor..">"..string.cut(row.class.."            ", 13)
          .. " <"..taliColor..">"..string.cut(string.cut(row.tali,2).."   ", 4)
          .. " <"..timeColor..">"..string.cut(string.cut((row.time/60), 4).."      ", 6)

          .. "  <"..critColor..">"..string.cut(string.cut(row.critpercent, 4).."     ", 5)          
          
          .. " <"..killColor..">"..string.cut(string.cut(row.kill,4).."     ", 6)
          ..  " <"..kpmColor..">"..string.cut(string.cut(row.kpm,4).."     ", 6)
          ..  " <"..expColor..">"..string.cut(string.cut(row.exp,4).."     ", 6)
          ..  " <"..epmColor..">"..string.cut(string.cut(row.epm,5).."      ", 7)
          ..  " <"..gpmColor..">"..string.cut(string.cut(math.floor(row.gpm),6).."       ", 8) 
          .. " <"..goldColor..">"..string.cut(row.gold .."      ", 7),
        ---------------------------------------------------------------------------------  
          [[zData.db.clickback(]].._..[[)]], [[]], true)                               -- What to do when clicked on
        --------------------------------------------------------------------------------- 
      end --- End of for _,row
    end
  end --- End of local function showCharts()
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------- Show Last 3 Zones
  local function showLast(thisChart, countBack)
    showCount = 0  
    local useRow = tonumber(#zData.db.localDB) - countBack
    for _, row in spairs(zData.db.localDB) do               
      if _ == useRow then
-------------------------- Limit results to 1        
        showCount = showCount + 1
        if showCount >= 2 then break end          
--------------------------- Blackout 0 talisman counts        
        if tonumber(row.tali) < 1 then taliColor = "black:black" else taliColor = "ansiMagenta" end
--------------------------- Display Each Row From The Database, Clickable For More Information
        cechoLink("hunterDisplay", 
          "<"..areaColor..">"..string.cut(row.area.."                   ", 20)
          .." <"..classColor..">"..string.cut(row.class.."            ", 13)
          .. " <"..taliColor..">"..string.cut(string.cut(row.tali,2).."   ", 4)
          .. " <"..timeColor..">"..string.cut(string.cut((row.time/60), 4).."      ", 6)
          .. "  <"..critColor..">"..string.cut(string.cut(row.critpercent, 4).."     ", 5)         
          .. " <"..killColor..">"..string.cut(string.cut(row.kill,4).."     ", 6)
          ..  " <"..kpmColor..">"..string.cut(string.cut(row.kpm,4).."     ", 6)
          ..  " <"..expColor..">"..string.cut(string.cut(row.exp,4).."     ", 6)
          ..  " <"..epmColor..">"..string.cut(string.cut(row.epm,5).."      ", 7)
          ..  " <"..gpmColor..">"..string.cut(string.cut(math.floor(row.gpm),6).."       ", 8) 
          .. " <"..goldColor..">"..string.cut(row.gold .."      ", 7),
        ---------------------------------------------------------------------------------  
          [[zData.db.clickback(]].._..[[)]], [[]], true)                               -- What to do when clicked on
        --------------------------------------------------------------------------------- 
      end --- End of for _,row
    end
  end --- End of local function showCharts()
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
-------------------------- Search For sortWith (First level sort: class name / all / area random
  if sortWith then
    if string.lower(sortWith) == "all" or
       string.lower(sortWith) == "tali" or
       string.lower(sortWith) == "time" or
       
       string.lower(sortWith) == "critpercent" or
       
       string.lower(sortWith) == "kill" or 
       string.lower(sortWith) == "kpm" or
       string.lower(sortWith) == "exp" or
       string.lower(sortWith) == "epm" or
       string.lower(sortWith) == "gold" or
       string.lower(sortWith) == "gpm"
     then
      zData.db.localDB = db:fetch(zData.db.expdb.zones)
    elseif table.contains(zData.classList, string.lower(sortWith)) then
      zData.db.localDB = db:fetch(zData.db.expdb.zones, db:like(zData.db.expdb.zones.class,"%"..sortWith.."%")) 
    else
	    zData.db.localDB = db:fetch(zData.db.expdb.zones, db:like(zData.db.expdb.zones.area,"%"..sortWith.."%")) 
    end   
  else
    zData.db.localDB = db:fetch(zData.db.expdb.zones)
  end
  
-------------------------- Clear Display   
  clearWindow("hunterDisplay") 
-------------------------- Display NO Results
  if #zData.db.localDB == 0 then
    cecho("hunterDisplay", "\n\n<red>     Nothing Found Searching <gold>Zones<red> for the string: <gold>"..sortWith.."\n       <green>Try Typing: <gold>zbash "..string.lower(gmcp.Char.Status.class).."\n")
-------------------------- Display Results
  else
    cecho("hunterDisplay", "\n                                   <"..titleColor..">Detailed Hunting Scrolls\n")
-------------------------- Display Last 3 Zones
  hecho("hunterDisplay", rainbow("@@#################################################################################################@@"))    
  cecho("hunterDisplay", "\n<"..titleColor..">1:")
    showLast("when", 0)
  cecho("hunterDisplay", "\n<"..titleColor..">2:")
    showLast("when", 1)
  cecho("hunterDisplay", "\n<"..titleColor..">3:")
    showLast("when", 2)
  cecho("hunterDisplay", "\n")
  hecho("hunterDisplay", rainbow("@@#################################################################################################@@\n"))
-------------------------- Display
    cecho("hunterDisplay","<"..menuColor..">                                ")
    cechoLink("hunterDisplay","   <"..menuColor..">Tali", [[zData.db.showData("tali")]], [[]], true)
    cechoLink("hunterDisplay","   <"..menuColor..">Time", [[zData.db.showData("time")]], [[]], true)

    cechoLink("hunterDisplay","   <"..menuColor..">Crit", [[zData.db.showData("critpercent")]], [[]], true)

    cechoLink("hunterDisplay","   <"..menuColor..">Kill", [[zData.db.showData("kill")]], [[]], true)
    cechoLink("hunterDisplay","   <"..menuColor..">KPM", [[zData.db.showData("kpm")]], [[]], true)
    cechoLink("hunterDisplay","    <"..menuColor..">Exp", [[zData.db.showData("exp")]], [[]], true)
    cechoLink("hunterDisplay","     <"..menuColor..">EPM", [[zData.db.showData("epm")]], [[]], true)
    cechoLink("hunterDisplay","    <"..menuColor..">GPM", [[zData.db.showData("gpm")]], [[]], true)
    cechoLink("hunterDisplay","      <"..menuColor..">Gold", [[zData.db.showData("gold")]], [[]], true) 
-------------------------- Display Results based on search(sortStyle)    
    if (sortStyle and string.lower(sortStyle) == "all") or (sortWith and string.lower(sortWith) == "all") then
      showCharts("exp", "expColor") 
    elseif (sortStyle and string.lower(sortStyle) == "exp") or (sortWith and string.lower(sortWith) == "exp") then
      expColor = "gold"
      showCharts("exp", "expColor")  
    elseif (sortStyle and string.lower(sortStyle) == "epm") or (sortWith and string.lower(sortWith) == "epm") then
      epmColor = "gold"
      showCharts("epm", "epmColor")  
    elseif (sortStyle and string.lower(sortStyle) == "time") or (sortWith and string.lower(sortWith) == "time") then
      timeColor = "gold"
      showCharts("time", "timeColor")  

    elseif (sortStyle and string.lower(sortStyle) == "critpercent") or (sortWith and string.lower(sortWith) == "critpercent") then
      critColor = "gold"
      showCharts("critpercent", "critColor")  

    elseif (sortStyle and string.lower(sortStyle) == "tali") or (sortWith and string.lower(sortWith) == "tali") then
      taliColor = "gold"
      showCharts("tali", "taliColor")    
    elseif (sortStyle and string.lower(sortStyle) == "gpm") or (sortWith and string.lower(sortWith) == "gpm") then
      gpmColor = "gold"
      showCharts("gpm", "gpmColor") 
    elseif (sortStyle and string.lower(sortStyle) == "gold") or (sortWith and string.lower(sortWith) == "gold") then
      goldColor = "gold"
      showCharts("gold", "goldColor")  
    elseif (sortStyle and string.lower(sortStyle) == "kill") or (sortWith and string.lower(sortWith) == "kill") then
      killColor = "gold"
      showCharts("kill", "killColor")  
    elseif (sortStyle and string.lower(sortStyle) == "kpm") or (sortWith and string.lower(sortWith) == "kpm") then
      kpmColor = "gold"
      showCharts("kpm", "kpmColor")  
    else
      kpmColor = "gold"
      showCharts("kpm", "kpmColor")
    end  
    cecho("hunterDisplay","\n<"..menuColor..">                                ")
    cechoLink("hunterDisplay","   <"..menuColor..">Tali", [[zData.db.showData("tali", nil, "down")]], [[]], true)
    cechoLink("hunterDisplay","   <"..menuColor..">Time", [[zData.db.showData("time", nil, "down")]], [[]], true)

    cechoLink("hunterDisplay","   <"..menuColor..">Crit", [[zData.db.showData("critpercent", nil, "down")]], [[]], true)

    cechoLink("hunterDisplay","   <"..menuColor..">Kill", [[zData.db.showData("kill", nil, "down")]], [[]], true)
    cechoLink("hunterDisplay","   <"..menuColor..">KPM", [[zData.db.showData("kpm", nil, "down")]], [[]], true)
    cechoLink("hunterDisplay","    <"..menuColor..">Exp", [[zData.db.showData("exp", nil, "down")]], [[]], true)
    cechoLink("hunterDisplay","     <"..menuColor..">EPM", [[zData.db.showData("epm", nil, "down")]], [[]], true)
    cechoLink("hunterDisplay","    <"..menuColor..">GPM", [[zData.db.showData("gpm", nil, "down")]], [[]], true)
    cechoLink("hunterDisplay","      <"..menuColor..">Gold", [[zData.db.showData("gold", nil, "down")]], [[]], true)  
  end
-------------------------- Display Footer     
  hecho("hunterDisplay", rainbow("\n@@#################################################################################################@@\n"))  
end 


-------------------------------------------------
--                                             --
--  View a saved record: zData.db.clickback()  --
--                                             --
-------------------------------------------------
function zData.db.clickback(thisRow)
  local deleteRow = 0
-------------------------- Clear Display   
  clearWindow("hunterDisplay") 
-------------------------- DELETE DATABASE ENTRY ---------------------------
  if zData.deleteAble then
    for _, row in spairs(zData.db.localDB) do
      if _ == thisRow then
        deleteRow = _
      end
    end
    cechoLink("hunterDisplay","\n<red>  --@@ DELETE ENTRY @@--  ", [[zData.db.clickbackdelete(]]..thisRow..[[)]], [[Clicking here will PERMENENTLY DELETE this entry]], true)
  end
----------------------------------------------------------------------------
  hecho("hunterDisplay", rainbow("\n@@#################################################################################################@@\n")) 
-------------------------- Display Header ^
  cecho("hunterDisplay","\n  <purple>Extended Report For: <gold>"..string.cut(zData.db.localDB[thisRow].class.."                                        ",40).."<purple>Date: <gold>"..zData.db.localDB[thisRow].when)
  cecho("hunterDisplay","\n  <purple>Hunting in the Zone: <gold>"..zData.db.localDB[thisRow].area)
  cecho("hunterDisplay","\n  <purple>Time Spent: <ansiMagenta>"..string.cut((zData.db.localDB[thisRow].time/60),4).." minutes")
  cecho("hunterDisplay","\n  <purple>Experience: <ansiMagenta>"..zData.db.localDB[thisRow].exp)
  --cecho("hunterDisplay","\n  <purple>Experience Modifier: <ansiMagenta>"..zData.db.localDB[thisRow].boost.."\%\n")
  cecho("hunterDisplay","\n  <purple>Stats: <ansiMagenta>Str: <gold>"..zData.db.localDB[thisRow].str.." <ansiMagenta>Dex: <gold>"..zData.db.localDB[thisRow].dex.." <ansiMagenta>Int: <gold>"..zData.db.localDB[thisRow].int.." <ansiMagenta>Con: <gold>"..zData.db.localDB[thisRow].con.."\n")
  --cecho("hunterDisplay","\n     <purple>Critical Hit Chance: <ansiMagenta>"..zData.db.localDB[thisRow].critpercent.."\%")
  cecho("hunterDisplay","\n <gold>"..zData.db.localDB[thisRow].crits.."  <purple>Critical Hits")
  cecho("hunterDisplay","\n <gold>"..string.cut(zData.db.localDB[thisRow].crits1.."  ",3).." <ansiMagenta> 2x "..string.cut("Critical                    ",25).."<gold>"..zData.db.localDB[thisRow].glyph.."  <ansiMagenta>Seared Glyph")
  cecho("hunterDisplay","\n <gold>"..string.cut(zData.db.localDB[thisRow].crits2.."  ",3).." <ansiMagenta> 4x "..string.cut("Crushing                    ",25).."<gold>"..zData.db.localDB[thisRow].soa.."  <ansiMagenta>Shield of Absorption")
  cecho("hunterDisplay","\n <gold>"..string.cut(zData.db.localDB[thisRow].crits3.."  ",3).." <ansiMagenta> 8x "..string.cut("Obliterating                    ",25).."<gold>"..zData.db.localDB[thisRow].soaparagon.."  <ansiMagenta>SoA Paragon")
  cecho("hunterDisplay","\n <gold>"..string.cut(zData.db.localDB[thisRow].crits4.."  ",3).." <ansiMagenta>16x "..string.cut("Annihilating                    ",25).."<gold>"..zData.db.localDB[thisRow].maya.."  <ansiMagenta>Maya Figurine")
  cecho("hunterDisplay","\n <gold>"..string.cut(zData.db.localDB[thisRow].crits5.."  ",3).." <ansiMagenta>32x "..string.cut("World Shattering                    ",25))
  cecho("hunterDisplay","\n <gold>"..string.cut(zData.db.localDB[thisRow].crits6.."  ",3).." <ansiMagenta>64x "..string.cut("Plane Razing                    ",25))
  cecho("hunterDisplay","\n")   
  cecho("hunterDisplay","\n <gold>"..zData.db.localDB[thisRow].gold.." <ansiMagenta> : Total Gold Gained")
  cecho("hunterDisplay","\n <gold>"..string.cut((zData.db.localDB[thisRow].gpm),5).."<ansiMagenta> : Gold Gained Per Minute")
  cecho("hunterDisplay","\n") 
-------------------------- Breakdown the killList string into a table for display
  local tempTable = string.split(zData.db.localDB[thisRow].killlist, "| ")
  local tempKillTable = {}
  for k, v in pairs(tempTable) do
    if tempKillTable[v] then 
      tempKillTable[v] = tempKillTable[v] + 1
    else
      tempKillTable[v] = 1
    end
  end   
  cecho("hunterDisplay","\n <gold>"..zData.db.localDB[thisRow].kill.." <purple>Kills at <gold>"..string.cut(zData.db.localDB[thisRow].kpm,5).."<purple> Kills Per Minute")
  for k, v in spairs(tempKillTable) do
    if v>9 then
      --cecho("hunterDisplay","\n  <purple>\["..string.cut(" ",1).."<gold>"..string.cut(v.." ",3).."<purple>\]  <ansiMagenta>"..k)
    else
      --cecho("hunterDisplay","\n  <purple>\["..string.cut("  ",2).."<gold>"..string.cut(v.." ",3).."<purple>\]  <ansiMagenta>"..k)
    end
  end
  cecho("hunterDisplay","\n") 
-------------------------- Breakdown the long taliList string into a table for display
  cecho("hunterDisplay","\n <purple>Total Talismans: <gold>"..zData.db.localDB[thisRow].tali)
  if tonumber(zData.db.localDB[thisRow].tali) > 0 then
  tempTable = string.split(zData.db.localDB[thisRow].talilist, "| ") 
  local tempTaliTable = {}
  for k, v in pairs(tempTable) do
    if tempTaliTable[v] then 
      tempTaliTable[v] = tempTaliTable[v] + 1
    else
      tempTaliTable[v] = 1
    end
  end   
  for k, v in spairs(tempTaliTable) do 
    if v>9 then
      --cecho("hunterDisplay","\n  <purple>\["..string.cut(" ",1).."<gold>"..string.cut(v.." ",3).."<purple>\]  <ansiMagenta>"..string.gsub(k, ":", "<purple>:"))
    else
      --cecho("hunterDisplay","\n  <purple>\["..string.cut("  ",2).."<gold>"..string.cut(v.." ",3).."<purple>\]  <ansiMagenta>"..string.gsub(k, ":", "<purple>:"))
    end
  end 
  end
-------------------------- Display Footer  
  cecho("hunterDisplay","\n")
  hecho("hunterDisplay", rainbow("\n@@#############################################################################################@@"))
  cechoLink("hunterDisplay", "\n                                    Click Here For zBash Chart                               ", [[zData.db.showData("kpm")]], [[]], true)
  hecho("hunterDisplay", rainbow("\n@@#############################################################################################@@"))
end 


-------------------------------------------------
--                                             --
--  Delete a saved record:                     --
--               zData.db.clickbackdelete()    --
--                                             --
-------------------------------------------------
function zData.db.clickbackdelete(thisRow)
  db:delete(zData.db.expdb.zones, zData.db.localDB[thisRow]._row_id)
  clearWindow("hunterDisplay") 
  hecho("hunterDisplay", rainbow("\n\n\n\n@@#############################################################################################@@"))  
  cecho("hunterDisplay","\n<red>                                     --@@ DELETED ENTRY @@--  ")
  hecho("hunterDisplay", rainbow("\n@@#############################################################################################@@\n")) 
  cechoLink("hunterDisplay", "                                    Click Here For zBash Chart                               ", [[zData.db.showData("kpm")]], [[]], true)
  hecho("hunterDisplay", rainbow("\n      @@#################################################################################@@\n"))
end

function zData.movement() 
    -----------------------------------------------------------------------------------------------
    -- Update Area    
      if gmcp.Room.Info.area ~= zData.char.lastArea then  -------------<--<--< Zone Change Detected
    
    -----------------------------------------------------------------------------------------------
    -- Collect experience percent from gmcp, check old xp (zData.char.oxp)
        if string.match(gmcp.Char.Status.xp, "%d+.%d+") then
          zData.char.xp = tonumber(string.match(gmcp.Char.Status.xp, "%d+.%d+"))
        elseif string.match(gmcp.Char.Status.xp, "%d+") then
          zData.char.xp = tonumber(string.match(gmcp.Char.Status.xp, "%d+"))
        end
        if zData.char.oxp == 0 then zData.char.oxp = zData.char.xp end
    
    -----------------------------------------------------------------------------------------------
    -- If your exp is not = to your old exp AND you have been in a zone FOR MORE > THAN 60 SECONDS
        if (zData.char.oxp ~= zData.char.xp or zData.char.killsCount > 0) and getStopWatchTime("zoneHuntWatch") > 60 then
          stopStopWatch("zoneHuntWatch")  
    
    -----------------------------------------------------------------------------------------------
    -- Update zData.Character Variables used for saving to the Database
          zData.char.tempTime = getStopWatchTime("zoneHuntWatch")
          zData.char.minuteTime = zData.char.tempTime/60
          zData.char.xpGains = zData.char.xp-zData.char.oxp
          zData.char.xpGainsMin = zData.char.xpGains/zData.char.minuteTime
          zData.char.killsPerMinute = zData.char.killsCount/zData.char.minuteTime
          zData.char.gpm = zData.char.gold/zData.char.minuteTime
    
    -----------------------------------------------------------------------------------------------
    -- Convert tables to strings for the database (will turn back to tables when pulled)
          zData.char.killListString = nil
          if #zData.char.killList > 0 then
            zData.char.killListString = table.concat(zData.char.killList, "| ")
          end
          zData.char.taliListString = nil
          if #zData.char.taliList > 0 then
            zData.char.taliListString = table.concat(zData.char.taliList, "| ")
          end
    
    -----------------------------------------------------------------------------------------------
    -- Record when this happened with getTime(use string)
          zData.char.when = getTime(true)
                
    -----------------------------------------------------------------------------------------------
    -- Send All information to database   
          zData.db.zoneAdd(
            zData.char.lastArea,
            gmcp.Char.Status.class, 
            zData.defs.exp, 
            zData.defs.crit, 
            zData.char.tempTime, 
            zData.char.xpGainsMin, 
            zData.char.xpGains, 
            zData.char.killsCount, 
            zData.char.killsPerMinute, 
            zData.char.gold, 
            zData.char.gpm, 
            zData.char.str, 
            zData.char.dex, 
            zData.char.int, 
            zData.char.con, 
            zData.char.totalAttacks, 
            zData.char.crithits, zData.char.crit1, zData.char.crit2, zData.char.crit3, zData.char.crit4, zData.char.crit5, zData.char.crit6, 
            zData.char.shield, 
            zData.char.paragon, 
            zData.char.searedglyph, 
            zData.char.mayafigure, 
            zData.char.taliCount, 
            zData.char.killListString, 
            zData.char.taliListString,
            zData.char.when
            )
        end
    
    -----------------------------------------------------------------------------------------------
    -- Reset all saved data for next area
        zData.char = {
          lastArea = gmcp.Room.Info.area,
          tempTime = 0,
          minuteTime = 0,
          xpGains = 0,
          xpGainsMin = 0,
          killsPerMinute = 0, 
          killsCount = 0,
          taliCount = 0,
          ogold = gmcp.Char.Status.gold,
          gold = 0,
          gpm = 0,
          totalAttacks = 0,
          crithits = 0,
          crit1 = 0,
          crit2 = 0,
          crit3 = 0,
          crit4 = 0,
          crit5 = 0,
          crit6 = 0,
          searedglyph = 0,
          shield = 0,
          paragon = 0,
          mayafigure = 0,     
          killList = {},
          taliList = {},
          when= 0,
        }
    
    -----------------------------------------------------------------------------------------------
    -- Save OLD experience for new zone    
        if string.match(gmcp.Char.Status.xp, "%d+.%d+") then
          zData.char.oxp = tonumber(string.match(gmcp.Char.Status.xp, "%d+.%d+"))
        elseif string.match(gmcp.Char.Status.xp, "%d+") then
          zData.char.oxp = tonumber(string.match(gmcp.Char.Status.xp, "%d+"))
        end
    
    -----------------------------------------------------------------------------------------------
    -- Reset and Start Stopwatch for this zone (always running / only resets here on zone change)
        resetStopWatch("zoneHuntWatch")
        startStopWatch("zoneHuntWatch") 
        end  
    end
    -----------------------------------------------------------------------------------------------
    registerAnonymousEventHandler("gmcp.Room.Info", "zData.movement") ---<--< Run When Room Updates
    -----------------------------------------------------------------------------------------------

    function zData.buildHunter()
        zData.hunter = {}
      
        --Create the hunter Adjustable
        zData.hunter.window = Adjustable.Container:new({
          name = "zgui.hunter.window",
          x = 0, y = 0,
          width = "50%",
          height = "50%",  
          adjLabelstyle = "background-color:rgba(0,40,100,100%); border: 5px inset purple;",
          buttonstyle=[[
            QLabel{ border-radius: 5px; background-color: rgba(140,140,140,100%);}
            QLabel::hover{ background-color: rgba(160,160,160,50%);}
          ]],
          buttonFontSize = 10,
          buttonsize = 15,          
        },main)
      
        --Create the hunter container
        zData.hunter.container = Geyser.Container:new({
          name = "zData.hunter.back",
          x = 0, y = 0,
          width = "100%",
          height = "100%",        
        },zData.hunter.window)  
      
        --Create the hunter Console
        zData.hunter.console = Geyser.MiniConsole:new({
          name = "hunterDisplay",
          x = 0, y = 0,
          autoWrap = false,
          width = "100%",
          height = "100%",
          color="black",
          --scrollBar = true,
        },zData.hunter.container) 
      
        setFontSize("hunterDisplay", 9)
        zData.hunter.window:setTitle("Hunting Scrolls","gray")
        zData.hunter.window:show()
      
      end

      
return zData