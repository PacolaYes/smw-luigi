
-- color!!

local SMW = RealSMWLuigi

SMW.overlayColor = {}

freeslot(
	"SKINCOLOR_SMWGREEN",
	"SKINCOLOR_SMWRED",
	"SKINCOLOR_SMWWHITE",
	
	-- colors for the overalls :D
	"SKINCOLOR_SMWBLURPLE",
	"SKINCOLOR_SMWAQUA",
	"SKINCOLOR_SMWFIREGREEN",
	"SKINCOLOR_SMWFIRERED"
)

SMW.overlayColor[SKINCOLOR_SMWGREEN] = SKINCOLOR_SMWBLURPLE
SMW.overlayColor[SKINCOLOR_SMWRED] = SKINCOLOR_SMWAQUA
SMW.overlayColor[SKINCOLOR_SMWWHITE] = SKINCOLOR_SMWFIREGREEN

-- using one of the overalls colors, may as well make the overalls the normal one :P
SMW.overlayColor[SKINCOLOR_SMWBLURPLE] = SKINCOLOR_SMWGREEN
SMW.overlayColor[SKINCOLOR_SMWAQUA] = SKINCOLOR_SMWRED
SMW.overlayColor[SKINCOLOR_SMWFIREGREEN] = SKINCOLOR_SMWWHITE
SMW.overlayColor[SKINCOLOR_SMWFIRERED] = SKINCOLOR_SMWWHITE

-- clothing: 1, 7, 16
-- overalls: 1, 8, 16

skincolors[SKINCOLOR_SMWGREEN] = {
	name = "SMW-Green",
	ramp = {123, 123, 123, 124, 124, 124, 124, 125, 125, 125, 126, 126, 126, 127, 127, 127},
	invcolor = SKINCOLOR_SMWRED,
	invshade = 9,
	chatcolor = V_GREENMAP,
	accessible = true
}

skincolors[SKINCOLOR_SMWRED] = {
	name = "SMW-Red",
	ramp = {33, 33, 33, 33, 204, 204, 204, 205, 205, 206, 207, 207, 63, 63, 44, 45},
	invcolor = SKINCOLOR_SMWGREEN,
	invshade = 12,
	chatcolor = V_ROSYMAP,
	accessible = true
}

skincolors[SKINCOLOR_SMWWHITE] = {
	name = "SMW-White",
	ramp = {1, 2, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
	invcolor = SKINCOLOR_SMWRED,
	invshade = 14,
	chatcolor = 0,
	accessible = true
}

skincolors[SKINCOLOR_SMWBLURPLE] = {
	name = "SMW-Blurple",
	ramp = {148, 148, 148, 163, 163, 164, 164, 164, 165, 166, 166, 167, 167, 167, 168, 168},
	invcolor = SKINCOLOR_SMWAQUA,
	invshade = 14,
	chatcolor = V_BLUEMAP,
	accessible = true
}

skincolors[SKINCOLOR_SMWAQUA] = {
	name = "SMW-Aqua",
	ramp = {140, 140, 141, 141, 141, 142, 142, 142, 142, 142, 142, 137, 137, 137, 137, 137},
	invcolor = SKINCOLOR_SMWBLURPLE,
	invshade = 14,
	chatcolor = V_AQUAMAP,
	accessible = true
}

skincolors[SKINCOLOR_SMWFIREGREEN] = {
	name = "SMW-FieryGreen",
	ramp = {114, 114, 115, 115, 115, 116, 116, 116, 116, 116, 117, 127, 127, 127, 127, 127},
	invcolor = SKINCOLOR_SMWFIRERED,
	invshade = 11,
	chatcolor = V_GREENMAP,
	accessible = true
}

skincolors[SKINCOLOR_SMWFIRERED] = {
	name = "SMW-FieryRed",
	ramp = {36, 36, 37, 37, 38, 38, 39, 40, 41, 41, 42, 43, 44, 45, 71, 46},
	invcolor = SKINCOLOR_SMWFIREGREEN,
	invshade = 11,
	chatcolor = V_REDMAP,
	accessible = true
}

-- overall index = 10, 13, 16
-- clothing index = 1, 3, 6
-- 1	  2	3	 4	   5	 6	   7	  8	9	   10	  11	12	   13	 14	15	  16
-- 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111
-- 33, 204, 205, 206, 207, 45, 236, 19, 14, 140, 140, 141, 142, 172, 137, 137
-- 1	  2	 3		4		5		6	 7		8  9    10    11    12   13    14   15    16
-- 36, 39, 46