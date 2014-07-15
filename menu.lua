-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local numBtn
local hirBtn
local background

-- 'onRelease' event listener for numBtn
local function onnumBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "numbers", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onhirBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "hiragana", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	background = display.newImageRect( "bgMenu.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "title.png", 264, 42 )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100
	
	-- create a widget button (which will loads level1.lua on release)
	numBtn = widget.newButton{
		label="Numbers",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onnumBtnRelease	-- event listener function
	}
	numBtn.x = display.contentWidth*0.5
	numBtn.y = display.contentHeight - 125
	
	hirBtn = widget.newButton{
		label="Hiragana",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onhirBtnRelease	-- event listener function
	}
	hirBtn.x = display.contentWidth*0.5
	hirBtn.y = display.contentHeight - 85
	
	-- all display objects must be inserted into group
	--sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( numBtn )
	sceneGroup:insert( hirBtn )
	background:toBack()
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
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if numBtn then
		numBtn:removeSelf()	-- widgets must be manually removed
		numBtn = nil
	end
	if hirBtn then
		hirBtn:removeSelf()
		numBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene