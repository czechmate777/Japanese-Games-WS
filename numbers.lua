-----------------------------------------------------------------------------------------
--
-- numbers.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()
physics.setGravity(0,0.3)
--------------------------------------------

-- forward declarations and other locals
local sceneGroup

local screenW, screenH = display.contentWidth, display.contentHeight
local halfW, HalfH = screenW*0.5, screenH*0.5

local background

local bubbleOptions =
{
    -- required parameters
    width = 100,
    height = 100,
    numFrames = 10,
}
local bubbleSeq = {

  { name = "bubbleCount",  --name of animation sequence
    start = 1,  --starting frame index
    count = 10,  --total number of frames to animate consecutively before stopping or looping
    time = 1000,
    loopCount = 1
}
}
local bubbleSheet = graphics.newImageSheet( "bubble.png", bubbleOptions )

local bubble
local bubbleTimer
local scale
local radius = 50
local radiusgap = 55
local initDelay = 1000
local bubbleLife = 6000

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--==    Functions
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
function spawn()
	-- do all the things
	bubble = display.newSprite(bubbleSheet, bubbleSeq)
	scale = math.random(60, 100)*0.01
	bubble:scale(scale, scale)
	bubble.x = math.random(radiusgap, screenW-radiusgap)
	bubble.y = math.random(radiusgap, screenH-radiusgap)
	physics.addBody( bubble, {density=0.5, friction=0, bounce=1, radius=50*scale} )
	bubble:setLinearVelocity(math.random(-20,20), math.random(-20,20))
	bubble:setFrame(math.random(1,10))
	bubble:addEventListener("tap", onTap)

	sceneGroup:insert(bubble)

	bubbleTimer = timer.performWithDelay(math.random(4000, 10000), nextBubble)
end

function nextBubble()
	-- get rid of bubble and spawn new one
	display.remove(bubble)
	bubble=nil
	spawn()
end

function onTap(event)
	-- pop it

	timer.cancel(bubbleTimer)
	physics.removeBody(bubble)
	local frame = bubble.frame
	transition.to( bubble, { time=1000, x=15+30*frame, y=15, width=30, height=30, xScale=1, yScale=1, transition=easing.inOutCubic } )
	spawn()

	-- nextBubble()

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
	
	wallRight = display.newRect(screenW, HalfH, 1, screenH)
	physics.addBody(wallRight, "static", {friction=0,bounce=1})

	wallLeft = display.newRect(-1, HalfH, 1, screenH)
	physics.addBody(wallLeft, "static", {friction=0,bounce=1})

	wallTop = display.newRect(halfW, -1, screenW, 1)
	physics.addBody(wallTop, "static", {friction=0,bounce=1})

	wallBottom = display.newRect(halfW, screenH, screenW, 1)
	physics.addBody(wallBottom, "static", {friction=0,bounce=1})

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert(wallRight)
	sceneGroup:insert(wallLeft)
	sceneGroup:insert(wallTop)
	sceneGroup:insert(wallBottom)

	timer.performWithDelay(initDelay, spawn)
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