-----------------------------------------------------------------------------------------
--
-- hiragana.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
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

local charTable = _G.charTableHiragana
local curTable = {1, 2, 3}		-- temporary values
local symbolSize = 72
local symbolSpacing = 150
local letterIndex
local letText
local choice1
local choice2
local choice3
local letterToggle
local letterToggleCross
local showLetter = true

local background
local speech

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
--==                       Functions                          ==--
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
function lowerHealth()
	-- perform what needs to be done
end
function onLetterTap(event)
	audio.play(speach)
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
		-- target:setFillColor(1, 0, 0) -- turn red
		transition.fadeOut(target, {time = 1000})
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
	---------------------------------
	--- display next matching
	letterIndex = math.random(46)
	local letterStr = charTable[letterIndex].let
	-- display letter set
	letText = display.newText(letterStr, halfW, halfH-50, native.systemFont, 72)
	if showLetter then
		letText.alpha = 1
	else
		letText.alpha = 0
	end

	-- Load and play sound
	speach = audio.loadSound("Audio/"..charTable[letterIndex].let..".mp3")
	audio.play(speach)

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
		halfW-symbolSpacing, halfH+choicesOffset, native.systemFont, symbolSize)
	choice2 = display.newText(charTable[curTable[2]].sym,
		halfW, halfH+choicesOffset, native.systemFont, symbolSize)
	choice3 = display.newText(charTable[curTable[3]].sym,
		halfW+symbolSpacing, halfH+choicesOffset, native.systemFont, symbolSize)
	print("Done displaying")

	-- indexes for symbols
	choice1.index = curTable[1]
	choice2.index = curTable[2]
	choice3.index = curTable[3]

	-- tap listeners for symbols and letters
	choice1:addEventListener( "tap", onSymbolTap )
	choice2:addEventListener( "tap", onSymbolTap )
	choice3:addEventListener( "tap", onSymbolTap )
	letText:addEventListener( "tap", onLetterTap )

	return true
end

function onLetterToggleTap(event)
	-- When toggler tapped, check if on or off
	if showLetter then
		showLetter = false		-- change boolean
		transition.fadeOut(letText , { time=200 } )	-- fade out letText
		transition.fadeOut(letterToggleCross, {time = 200})		-- change toggler
		transition.fadeIn(speaker, {time = 1000})
	else
		showLetter = true		-- change boolean
		transition.fadeIn(letText , { time=1000 } )	-- fade in letText
		transition.fadeIn(letterToggleCross, {time = 200})		-- change toggler
		transition.fadeOut(speaker, {time = 200})
	end
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

	letterToggleCross = display.newImageRect("letterToggleCross.png", 50, 50)
	letterToggleCross.x, letterToggleCross.y = screenW-50, 50

	letterToggle = display.newImageRect("letterToggle.png", 50, 50)
	letterToggle.x, letterToggle.y = screenW-50, 50
	letterToggle:addEventListener( "tap", onLetterToggleTap )

	speaker = display.newImageRect("speaker.png", 100, 100)
	speaker.x, speaker.y = halfW, halfH-50
	speaker:addEventListener("tap", onLetterTap)
	speaker.alpha = 0
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert(letterToggle)
	sceneGroup:insert(letterToggleCross)
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