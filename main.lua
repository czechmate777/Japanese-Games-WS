-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"
_G.charTableHiragana = {
	{ let = "n"  , sym = "ん"},
	{ let = "wa" , sym = "わ"},
	{ let = "ra" , sym = "ら"},
	{ let = "ya" , sym = "や"},
	{ let = "ma" , sym = "ま"},
	{ let = "ha" , sym = "は"},
	{ let = "na" , sym = "な"},
	{ let = "ta" , sym = "た"},
	{ let = "sa" , sym = "さ"},
	{ let = "ka" , sym = "か"},
	{ let = "a"  , sym = "あ"},
	{ let = "ri" , sym = "り"},
	{ let = "mi" , sym = "み"},
	{ let = "hi" , sym = "ひ"},
	{ let = "ni" , sym = "に"},
	{ let = "chi", sym = "ち"},
	{ let = "shi", sym = "し"},
	{ let = "ki" , sym = "き"},
	{ let = "i"  , sym = "い"},
	{ let = "ru" , sym = "る"},
	{ let = "yu" , sym = "ゆ"},
	{ let = "mu" , sym = "む"},
	{ let = "fu" , sym = "ふ"},
	{ let = "nu" , sym = "ぬ"},
	{ let = "tsu", sym = "つ"},
	{ let = "su" , sym = "す"},
	{ let = "ku" , sym = "く"},
	{ let = "u"  , sym = "う"},
	{ let = "re" , sym = "れ"},
	{ let = "me" , sym = "め"},
	{ let = "he" , sym = "へ"},
	{ let = "ne" , sym = "ね"},
	{ let = "te" , sym = "て"},
	{ let = "se" , sym = "せ"},
	{ let = "ke" , sym = "け"},
	{ let = "e"  , sym = "え"},
	{ let = "wo" , sym = "を"},
	{ let = "ro" , sym = "ろ"},
	{ let = "yo" , sym = "よ"},
	{ let = "mo" , sym = "も"},
	{ let = "ho" , sym = "ほ"},
	{ let = "no" , sym = "の"},
	{ let = "to" , sym = "と"},
	{ let = "so" , sym = "そ"},
	{ let = "ko" , sym = "こ"},
	{ let = "o"  , sym = "お"}
}

-- load menu screen
composer.gotoScene( "menu" )