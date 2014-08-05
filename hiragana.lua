-----------------------------------------------------------------------------------------
--
-- hiragana.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local network = require  "network"
local urlEncoder = require("socket.url")
-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()
--------------------------------------------

-- forward declarations and other locals
local sceneGroup

local screenW, screenH = display.contentWidth, display.contentHeight
local halfW, halfH = screenW*0.5, screenH*0.5
local initDelay = 1000
local choicesOffset = 100
local preURL = "http://www.translate.google.com/translate_tts?ie=UTF-8&tl=ja&q="

local charTable = _G.charTableHiragana
local curTable = {1, 2, 3}		-- temporary values
local letterIndex
local letText
local choice1
local choice2
local choice3

local background
local speech

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
--==                       Functions                          ==--
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
local function networkListener( event )
	if ( event.isError ) then
		print ( "Network error - download failed" )
	else
		speech = audio.loadSound( "speak.mp3", system.TemporaryDirectory )
		audio.play( speech )
	end

end

function lowerHealth()
	-- perform what needs to be done
end

function onSymbolTap(event)
	local target = event.target
	if letterIndex == target.index then	-- correct
		target:setFillColor(0, 1, 0.3)
		-- congratulate?

		-- fade out letter and symbols
		transition.fadeOut(letText , { time=1000 } )
		transition.fadeOut(choice1 , { time=1000 } )
		transition.fadeOut(choice2 , { time=1000 } )
		transition.fadeOut(choice3 , { time=1000 } )

		-- load next set
		timer.performWithDelay(2000, displayNext)
	else 								-- incorrect
		target:setFillColor(1, 0, 0)
		lowerHealth()
	end

end

function displayNext()
	-- removal of previous garbage --
	---------------------------------
	display.remove(letText)
	display.remove(choice1)
	display.remove(choice2)
	display.remove(choice3)
	local dir = system.TemporaryDirectory  -- where the file is stored
	os.remove( system.pathForFile( "speak.mp3", dir  ) )
	---------------------------------
	--- display next matching
	letterIndex = math.random(46)
	local letterStr = charTable[letterIndex].let
	-- display letter set
	letText = display.newText(letterStr, halfW, halfH-50, native.systemFont, 72)
	-- get letter sound from Google Translate
	local ending = urlEncoder.escape(charTable[letterIndex].sym)
	local url = preURL..ending
	print(url)
	network.download( 
		url,
		"GET", 
		networkListener, 
		"speak.mp3", 
		system.TemporaryDirectory
		)

	-- pick two other random symbols
	curTable[1], curTable[2], curTable[3] = letterIndex, math.random(46), math.random(46)
	while curTable[1]==curTable[2] or curTable[1]==curTable[3] do
		curTable[2] = math.random(46)
		curTable[3] = math.random(46)
	end

	-- reorder symbol table
	table.sort(curTable)
	print("After sorting")

	-- display 3 choices of symbols
	choice1 = display.newText(charTable[curTable[1]].sym,
		halfW-100, halfH+choicesOffset, native.systemFont, 28)
	choice2 = display.newText(charTable[curTable[2]].sym,
		halfW, halfH+choicesOffset, native.systemFont, 28)
	choice3 = display.newText(charTable[curTable[3]].sym,
		halfW+100, halfH+choicesOffset, native.systemFont, 28)
	print("Done displaying")

	-- indexes for symbols
	choice1.index = curTable[1]
	choice2.index = curTable[2]
	choice3.index = curTable[3]

	-- tap listeners for symbols
	choice1:addEventListener( "tap", onSymbolTap )
	choice2:addEventListener( "tap", onSymbolTap )
	choice3:addEventListener( "tap", onSymbolTap )

	return true
end

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	sceneGroup = self.view

	background = display.newImageRect("bg.png", screenW, screenH)
	background.anchorX, background.anchorY = 0, 0
	background.x, background.y = 0, 0
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()

		-- Initiate timer to start first matching
		timer.performWithDelay(initDelay, displayNext)
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
physics.stop()
elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene