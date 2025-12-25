
-- is this bloat? probably yea
-- why did i add this? why not!
-- only on singleplayer though
-- unless everyone's SMW, then allow it in MP, why not!
-- -Pac

-- NOTE TO SELF:
-- please finish this later
-- here's a lil list of stuff as a reminder!
-- - Everything after the walking part is supposed to end
--   - that includes the eggs hatching thingie with the THANK YOU! text
--   - and also the enemies thingies, if i decide i want to include those!!
-- - The eggs following you in the walking part, shouldn't be hard to do, but i dont feel like doing so rn
-- - Update the credits if 2.2.14 changes them (if this 2.2.14 releases before i finish everything, that is. Very likely)
-- - Possibly optimize this? I feel GFZ1 not that much of a consistent FPS to me isn't that big of a deal
--    since i have a, what i'd consider, a low-end machine, but it c'mon, it ran fine before, maybe i should cache the LUIGI sprites?

-- wtf was i on typing these reminders
-- i don't understand some of this

local SMW = RealSMWLuigi
local hud = SMW.dofile("Libs/hud.lua") ---@type smw_hudlib

local creditsList = { -- never would you guess i copied this from source, except i also modified it!
	/*{'Sonic Robo Blast 2', true},
	{'Credits', true},
	{''},*/
	{'Game Design', true},
	{'Sonic Team Junior'},
	{'"SSNTails"'},
	{'Johnny "Sonikku" Wallbank'},
	{''},
	{'Programming', true},
	{'"altaluna"'},
	{'Alam "GBC" Arias'},
	{'Logan "GBA" Arias'},
	{'Zolton "Zippy_Zolton" Auburn'},
	{'Colette "fickleheart" Bordelon'},
	{'Andrew "orospakr" Clunis'},
	{'Sally "TehRealSalt" Cochenour'},
	{'Gregor "Oogaland" Dick'},
	{'Callum Dickinson'},
	{'Scott "Graue" Feeney'},
	{'Victor "SteelT" Fuentes'},
	{'Nathan "Jazz" Giroux'},
	{'"Golden"'},
	{'Vivian "toaster" Grannell'},
	{'Julio "Chaos Zero 64" Guir'},
	{'"Hanicef"'},
	{'"Hannu_Hanhi"'}, // For many OpenGL performance improvements!
	{'Kepa "Nev3r" Iceta'},
	{'Thomas "Shadow Hog" Igoe'},
	{'Iestyn "Monster Iestyn" Jealous'},
	{'"Kaito Sinclaire"'},
	{'"Kalaron"'}, // Coded some of Sryder13's collection of OpenGL fixes, especially fog
	{'"katsy"'},
	{'Ronald "Furyhunter" Kinard'}, // The SDL2 port
	{'"Lat\'"'}, // SRB2-CHAT, the chat window from Kart
	{'"LZA"'},
	{'Matthew "Shuffle" Marsalko'},
	{'Steven "StroggOnMeth" McGranahan'},
	{'"Morph"'}, // For SRB2Morphed stuff
	{'Louis-Antoine "LJ Sonic" de Moulins'}, // de Rochefort doesn't quite fit on the screen sorry lol
	{'John "JTE" Muniz'},
	{'Colin "Sonict" Pfaff'},
	{'James "james" Robert Roman'},
	{'Sean "Sryder13" Ryder'},
	{'Ehab "Wolfy" Saeed'},
	{'Tasos "tatokis" Sahanidis'}, // Corrected C FixedMul, making 64-bit builds netplay compatible
	{'Riku "Ors" Salminen'}, // Demo consistency improvements
	{'Jonas "MascaraSnake" Sauer'},
	{'Wessel "sphere" Smit'},
	{'"SSNTails"'},
	{'"VelocitOni"'}, // Wrote the original dashmode script
	{'Ikaro "Tatsuru" Vinhas'},
	{'Ben "Cue" Woodford'},
	{'Lachlan "Lach" Wright'},
	{'Marco "mazmazz" Zafra'},
	{'"Zwip-Zwap Zapony"'},
	{''},
	{'Art', true},
	{'Victor "VAdaPEGA" Araujo'}, // Araújo -- sorry for our limited font! D:
	{'"Arrietty"'},
	{'Ryan "Blaze Hedgehog" Bloom'},
	{'Graeme P. "SuperPhanto" Caldwell'}, // for the new brak render
	{'"ChrispyPixels"'},
	{'Paul "Boinciel" Clempson'},
	{'Sally "TehRealSalt" Cochenour'},
	{'"Dave Lite"'},
	{'Desmond "Blade" DesJardins'},
	{'Sherman "CoatRack" DesJardins'},
	{'"DirkTheHusky"'},
	{'Jesse "Jeck Jims" Emerick'},
	{'"Fighter_Builder"'}, // for the CEZ3 button debris
	{'Buddy "KinkaJoy" Fischer'},
	{'Vivian "toaster" Grannell'},
	{'James "SwitchKaze" Hale'},
	{'James "SeventhSentinel" Hall'},
	{'Kepa "Nev3r" Iceta'},
	{'Iestyn "Monster Iestyn" Jealous'},
	{'William "GuyWithThePie" Kloppenberg'},
	{'Alice "Alacroix" de Lemos'},
	{'Logan "Hyperchaotix" McCloud'},
	{'Alexander "DrTapeworm" Moench-Ford'},
	{'Andrew "Senku Niola" Moran'},
	{'"MotorRoach"'},
	{'Phillip "TelosTurntable" Robinson'},
	{'"Scizor300"'},
	{'Wessel "sphere" Smit'},
	{'David "Instant Sonic" Spencer Jr.'},
	{'"SSNTails"'},
	{'Daniel "Inazuma" Trinh'},
	{'"VelocitOni"'},
	{'Jarrett "JEV3" Voight'},
	{''},
	{'Music and Sound', true},
	{'Production', true, true},
	{'Victor "VAdaPEGA" Araujo'}, // Araújo
	{'Malcolm "RedXVI" Brown'},
	{'Dave "DemonTomatoDave" Bulmer'},
	{'Paul "Boinciel" Clempson'},
	{'"Cyan Helkaraxe"'},
	{'Claire "clairebun" Ellis'},
	{'James "SeventhSentinel" Hall'},
	{'Kepa "Nev3r" Iceta'},
	{'Iestyn "Monster Iestyn" Jealous'},
	{'Jarel "Arrow" Jones'},
	{'Alexander "DrTapeworm" Moench-Ford'},
	{'Stefan "Stuf" Rimalia'},
	{'Shane Mychal Sexton'},
	{'Dave "Big Wave Dave" Spencer'},
	{'David "instantSonic" Spencer'},
	{'"SSNTails"'},
	{''},
	{'Level Design', true},
	{'Colette "fickleheart" Bordelon'},
	{'Hank "FuriousFox" Brannock'},
	{'Matthew "Fawfulfan" Chapman'},
	{'Paul "Boinciel" Clempson'},
	{'Sally "TehRealSalt" Cochenour'},
	{'Desmond "Blade" DesJardins'},
	{'Sherman "CoatRack" DesJardins'},
	{'Ben "Mystic" Geyer'},
	{'Nathan "Jazz" Giroux'},
	{'Vivian "toaster" Grannell'},
	{'James "SeventhSentinel" Hall'},
	{'Kepa "Nev3r" Iceta'},
	{'Thomas "Shadow Hog" Igoe'},
	{'"Kaito Sinclaire"'},
	{'Alexander "DrTapeworm" Moench-Ford'},
	{'"Revan"'},
	{'Anna "QueenDelta" Sandlin'},
	{'Wessel "sphere" Smit'},
	{'"SSNTails"'},
	{'Rob Tisdell'},
	{'"Torgo"'},
	{'Jarrett "JEV3" Voight'},
	{'Johnny "Sonikku" Wallbank'},
	{'Marco "mazmazz" Zafra'},
	{''},
	{'Boss Design', true},
	{'Ben "Mystic" Geyer'},
	{'Vivian "toaster" Grannell'},
	{'Thomas "Shadow Hog" Igoe'},
	{'John "JTE" Muniz'},
	{'Samuel "Prime 2.0" Peters'},
	{'"SSNTails"'},
	{'Johnny "Sonikku" Wallbank'},
	{''},
	{'Testing', true},
	{'Discord Community Testers'},
	{'Hank "FuriousFox" Brannock'},
	{'Cody "Playah" Koester'},
	{'Skye "OmegaVelocity" Meredith'},
	{'Stephen "HEDGESMFG" Moellering'},
	{'Rosalie "ST218" Molina'},
	{'Samuel "Prime 2.0" Peters'},
	{'Colin "Sonict" Pfaff'},
	{'Bill "Tets" Reed'},
	{''},
	{'Special Thanks', true},
	{'id Software'},
	{'Doom Legacy Project'},
	{'FreeDoom Project'}, // Used some of the mancubus and rocket launcher sprites for Brak
	{'Kart Krew'},
	{'Alex "MistaED" Fuller'},
	{'Howard Drossin'}, // Virtual Sonic - Sonic & Knuckles Theme
	{'Pascal "CodeImp" vd Heiden'}, // Doom Builder developer
	{'Randi Heit (<!>)'}, // For their MSPaint <!> sprite that we nicked
	{'Simon "sirjuddington" Judd'}, // SLADE developer
	{'SRB2 Community Contributors'},
	{''},
	{'Produced By', true},
	{'Sonic Team Junior'},
	{''},
	{'Published By', true},
	{'A 28K dialup modem'}/*,
	{''},
	'\1Thank you       ',
	'\1for playing!       ',*/
}

--} -- slade sux :)

local smwscenes = {
	[1] = {
		bg = "SKY159",
		draw = nil
	},
	[2] = {
		bg = "SKY17"
	},
	[3] = {
		bg = "SKY31"
	},
	[4] = {
		bg = "FAKESKY1"
	}
}

local function initVar(p)
	if not (p.mo and p.mo.valid)
	or p.mo.skin ~= "realsmwluigi" then return end
	
	p.smwcredits = {
		active = false,
		time = 0,
		scene = 1,
		changeAnim = {
			num = 0,
			time = 0
		}
	}
end

local function changeScene(p, num)
	if not (p and p.valid)
	or not p.smwcredits then return end
	
	local c = p.smwcredits.changeAnim
	num = $ or 1
	c.num = num
	c.time = 0
end

local creditsEndTime = 60*TICRATE+37*TICRATE -- the song's pretty much 1:37 in length
local changeTime = creditsEndTime-creditsEndTime/4 -- when the last change in scene should happen, more scenes means changes happen faster

addHook("PlayerSpawn", initVar)
addHook("PlayerThink", function(p)
	if not (p.mo and p.mo.valid)
	or p.mo.skin ~= "realsmwluigi" then return end
	
	if p.smwcredits == nil then initVar(p) end
	
	if (p.cmd.buttons & BT_CUSTOM1) -- debugging feature! triggers the credits on custom 1 press
		S_ChangeMusic("SMWSR", false)
		p.smwcredits.active = true
	end
	
	if not p.smwcredits.active then return end
	local c = p.smwcredits
	c.time = $+1 -- increases the time, i think this one's pretty self-explanatory
	
	if c.changeAnim.num then -- handles the lil go up and down thing the bars do when transitioning backgrounds
		c.changeAnim.time = $+1 -- increases the time for the change bg anim
		
		if c.changeAnim.time == 25 then -- if the time is equals to 25 tics (bars have filled up the full screen)
			c.scene = c.changeAnim.num -- then schange the scene to whatever was supplied to the function (this only triggers if that's real anyways :P)
		elseif c.changeAnim.time >= 50 then -- else if the time's higher than or equals to 50 (has gone back to normal)
			c.changeAnim.time = 0 -- then pretty please, reset the variable stuff!
			c.changeAnim.num = 0
		end
	end
	
	-- handles changing the scenes, function not really needed but i think it's neat!!
	if c.time <= changeTime
	and c.time%(changeTime/(#smwscenes-1)) == 0 then
		changeScene(p, c.scene+1)
	end
	
	if not consoleplayer then return end -- if you're the local player
	
	local var = CV_FindVar("showhud") -- then get if the hud's being shown or not
	if var.value ~= 1 -- if it isn't
		CV_StealthSet(var, 1) -- then force it to show
	end
end)

local smallTable = {
	[1] = V_GREENMAP,
	[2] = V_YELLOWMAP,
	[3] = V_REDMAP
}

addHook("HUD", function(v, p)
	if skins[p.skin].name ~= "realsmwluigi"
	or not p.smwcredits
	or not p.smwcredits.active then return end
	
	local c = p.smwcredits
	local scene = smwscenes[c.scene] or {bg = "FAKESKY1"}
	
	local dupx = ((v.width()*FU)-(320*FU*v.dupx()))/v.dupx()
	local dupy = ((v.height()*FU)-(200*FU*v.dupy()))/v.dupy()
	
	local scale = FU/2
	local bgPatch = SMW.getPatch(v, scene.bg or "FAKESKY1") -- get the background for the scene, if no background is found then use the GFZ1 one!
	local bgHeight = bgPatch.height*scale
	while bgHeight < 200*FU+dupy do -- so it atleast fits in the screen, even if it'll never show it fully.
		scale = $+FU/4
		bgHeight = bgPatch.height*scale
	end
	
	local bgWidth = bgPatch.width*scale -- variable for the width of the bg's image
	local bgX = (c.time%bgPatch.width)*scale -- the X value for the background, uses a modulo on the time with the bg's size so it moves all the way until where the 2nd img can be where it started (so it loops "perfectly")
	v.drawScaled(bgX, 0, scale, bgPatch) -- draw the normal bg image
	v.drawScaled(bgX-bgWidth, 0, scale, bgPatch) -- draw the one behind it, to create the illusion of an infinite bg scrolling by
	if bgX+bgWidth < 320*FU+dupx then -- if the bg's width is lower than the screen size
		local i = 1 -- here for multiplication porposues (HWO DO I TRYPE IT)
		while bgX+bgWidth*i < 320*FU+dupx do -- then repeatedly draw it until it fills the screen, please!
			v.drawScaled(bgX+bgWidth*i, 0, scale, bgPatch)
			i = $+1
		end
		print(i)
	end
	
	if c.changeAnim.time then -- if the scene is changing
		local topy = 0
		local bottomy = 0
		if c.changeAnim.time < 25 then -- if the time's lower than 25 tics
			topy = min(100, 50+(c.changeAnim.time*2)) -- make the animation of it going down
			bottomy = max(100, 150-(c.changeAnim.time*2)) -- and one of this going up
		else
			topy = max(50, 100-(c.changeAnim.time*2-50)) -- make the animation of this going back up
			bottomy = min(150, 100+(c.changeAnim.time*2-50)) -- and one of this going back down
		end
		v.drawFill(0, 0, 320, topy+dupy, 31|V_SNAPTOTOP|V_SNAPTOLEFT) -- now actually draw the borders!!
		v.drawFill(0, bottomy+dupy, 320, 100, 31|V_SNAPTOBOTTOM|V_SNAPTOLEFT)
	end
	
	local patch, flip = v.getSprite2Patch(p.skin, SPR2_WALK, false, (c.time/5)%3, 3)
	v.draw(75, 146+(dupy>>FRACBITS), patch, flip and V_FLIP or 0, v.getColormap(p.skin, p.skincolor)) -- LUIGI!!
	v.draw(100, 146+(dupy>>FRACBITS), SMW.getPatch(v, "SMWCREDSPEACH_"+(c.time/5)%3))
	
	if not c.changeAnim.time then -- if the scene isn't changing
		local topy = 50 -- the name of these is pretty self-explanatory, i'd assume
		local bottomy = 150
		if c.time < 50 then -- if the credits have yet to have gone through 50 tics then
			topy = 100-c.time -- make the animation of this going up at the beggining
			bottomy = 100+c.time -- and the animation of this going down at the beggining!
		end
		v.drawFill(0, 0, 320, topy+dupy, 31|V_SNAPTOTOP|V_SNAPTOLEFT) -- then draw the borders!
		v.drawFill(0, bottomy+dupy, 320, 100, 31|V_SNAPTOBOTTOM|V_SNAPTOLEFT)
	end
	
	if c.time < 3*TICRATE+TICRATE/2 -- if the credits text aren't going up;
	or c.time >= creditsEndTime then return end -- or if the credits have already gone all the way up, then don't even bother!!
	
	local smallColor = -1 -- the color for the small text
	local uy = (200<<FRACBITS)-(c.time-(3*TICRATE+TICRATE/2))*(FU+FU/3) -- handle the text going up
	for _, val in ipairs(creditsList) do -- go through the credits list
		if val[1] == '' then -- if it's an empty space then
			uy = $+8*FU -- just leave a space below it
			continue -- and move on
		end
		
		-- handling of the small color, pretty simple, just goes up if the text's small
		if val[2] and not val[3] then smallColor = $+1 end -- maybe not the best way to do this?
		
		-- math
		-- for what size the text should be
		local MATHstuff = val[2] and 8*FU or 16*FU -- is this manual? yeah, it does the job though, i'm not allowing people to chang this anyways >:)
		
		-- if the text is too high up then
		if uy <= -MATHstuff then
			uy = $+MATHstuff+8*FU -- make it go down
			continue -- and don't bother with drawing it
		end
		
		-- if the text is below the screen
		if uy >= 200*FU+MATHstuff then break end -- then get out of this loop since nothing else is being drawn
		
		hud.drawString(v, 160*FU, uy, FU, val[1]:lower(), 0, "center", (val[2] and "SMWFNT" or "SMWBIG"), (val[2] and v.getStringColormap(smallTable[(smallColor%3)+1]) or nil))
		uy = $+MATHstuff+8*FU
	end
end)