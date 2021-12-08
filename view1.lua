-----------------------------------------------------------------------------------------
-- This view is the Start screen.
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require "widget"
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- create image background to fill screen
	local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight) 
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background.xScale = 1.5;
	background.yScale = 1.3;

	
	-----------------------------------------------------------------------------------------
	-- scene:create StartButton
	----------------------------------------------------------------------------------------
	--start button
	local function handleButtonEvent( event )
	
		if ( "ended" == event.phase ) then
			print( "Button was pressed and released" )
			composer.gotoScene( "view2" )
		end
	end

	--local startButton = display.newImageRect("start.png", 100, 100)
	local startButton = widget.newButton(
		{
			width = 360,
			height = 360,
			defaultFile = "start.png",
			onEvent = handleButtonEvent
		}
	)
	-- Center the button
	startButton.xScale = .5
	startButton.yScale = .5
	startButton.x = display.contentCenterX
	startButton.y = display.contentCenterY+50
	
	-----------------------------------------------------------------------------------------
	-- -- create title
	-----------------------------------------------------------------------------------------
	local title = display.newImageRect( "titlelogo.png", 587, 148 ) --those are the exact image dimensions
		title.x = display.contentCenterX
		title.y = display.contentCenterY-75
		title.xScale = .5
		title.yScale = .5

	
	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( startButton  );
	sceneGroup:insert( title )

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
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene