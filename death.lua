-----------------------------------------------------------------------------------------
-- This view is the Start screen.
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require "widget"
local scene = composer.newScene()
local loadsave = require("loadsave")
function scene:create( event )
	local sceneGroup = self.view
	local tempTable = loadsave.loadTable("highscore.json") 
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- create image background to fill screen
	local background = display.newImageRect( "dead.png", display.contentWidth, display.contentHeight) 
	local LoseText = display.newText("YOU LOSE:", display.contentCenterX,7, native.systemFontBold)
	local scoreText = display.newText("Score: ".. tonumber(composer.getVariable("highscore")),display.contentCenterX,20, native.systemFontBold);
	local isHighScoreText = display.newText("Highscore: ".. tempTable["highscore"], display.contentCenterX, 30, native.systemFontBold)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background.xScale = 1.2;
	background.yScale = 1.1;
    local touchSound = audio.loadSound( "deathtoll.wav" )
    audio.play( touchSound )
	local animeSound = audio.loadSound( "spiderman_tokyo_ghoul.mp3" )
    audio.play( animeSound )
	audio.setMaxVolume(.5)
	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	--sceneGroup:insert( startButton  );

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