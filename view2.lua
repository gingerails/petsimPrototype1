-----------------------------------------------------------------------------------------
-- This view is the pet main screen
-- view2.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local panelstuff = require ( "panel" )
local pet = require ( "pet" )


--
--
-- Here is the actual scene code.
--
--
---------------------------------------------------------------------------------
-- Create the scene
---------------------------------------------------------------------------------

	-- Called when the scene's view does not exist.
	-- Initializes the scene. Spawns pet.
function scene:create( event )
	-- all necessary imports
	local sceneGroup = self.view
	local Pet = require('pet')

	
	-- create a white background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 2 )	-- white
	sceneGroup:insert( background )


	---------------------------------------------------------------------------------
	-- CREATE DROPDOWN PANEL WIDGET
	-- This section creates the panel widget, checks that it is shown (panelTransDone),
	-- and creates the panel open/close buttons. It references the panel file.
	-- Put inventory objects here unless we make the inventory OOP?
	------------------------------------------------------------------------------





	local function panelTransDone( target )
		--native.showAlert( "Panel", "Complete", { "Okay" } )
		if ( target.completeState ) then
			print( "PANEL STATE IS: "..target.completeState )
		end
	end
	


	


	local panel = widget.newPanel{
		location = "top",
		onComplete = panelTransDone,
		width = display.contentWidth * 0.8,
		height = display.contentHeight * 0.8,
		speed = 250,
		inEasing = easing.outBack,
		outEasing = easing.outCubic
	}


	local function closePanelEvent(event)
		if (event.phase == "ended") then 
			local burgerImage = display.newImage("burger.png", display.contentCenterX, display.contentCenterY)
			burgerImage:scale(0.05, 0.05)
			panel:hide()
		end
	end




	panel.background = display.newRect( 0, 0, panel.width, panel.height )
	panel.background:setFillColor( 0, 0.25, 0.5 )
	panel:insert( panel.background )
	local burgerButton = widget.newButton(
		{
			width = 360,
			height = 360,
			defaultFile = "burger.png",
			onEvent = closePanelEvent
		}
	)
	panel:insert(burgerButton)
	panel.title = display.newText( "menu", 0, 0, native.systemFontBold, 18 )
	panel.title:setFillColor( 1, 1, 1 )
	panel:insert( panel.title )

	--start button
	local function handleButtonEvent( event )
		
		if ( "ended" == event.phase ) then
			print( "Button was pressed and released" )
			--composer.gotoScene( "view2" )
			panel:hide();
		end
	end

	panel.exitPanel = widget.newButton(
		{
			width = 240,
			height = 120,
			defaultFile = "start.png",
			onEvent = handleButtonEvent
		}
	)
	panel:insert (panel.exitPanel)
	---------------------------------------------------------------------------------
	-- END PANEL CODE
	---------------------------------------------------------------------------------
	-------- Create Pet object
	petObj = Pet:new({xPos=x, yPos=y});
    petObj:spawn(sceneGroup); -- Pet is inserted to the scenegroup here

    -----------------------------------------------------------------------------------------
	-- scene:create panelButton
	----------------------------------------------------------------------------------------
	--start button
	local function handleButtonEvent( event )
	
		if ( "ended" == event.phase ) then
			print( "Button was pressed and released" )
			--composer.gotoScene( "view2" )
			panel:show()
		end
	end

	--local startButton = display.newImageRect("start.png", 100, 100)
	local panelButton = widget.newButton(
		{
			width = 360,
			height = 360,
			defaultFile = "Icon_Inventory.png",
			onEvent = handleButtonEvent
		}
	)
	panelButton.xScale=.2
	panelButton.yScale=.2
	sceneGroup:insert( panelButton) --ADD DROPDOWN MENU
	
	sceneGroup:insert(panel)
    --sceneGroup:insert( petObj )
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		----------------------------------------------------------------------------------------
		--test Menu button
		local function handleMenuButtonEvent( event )
		
			if ( "ended" == event.phase ) then
				print( "Button was pressed and released" )
				--composer.gotoScene( "view2" )
				composer.gotoScene( "view1" )
			end
		end

		--local startButton = display.newImageRect("start.png", 100, 100)
		local menuButton = widget.newButton(
			{
				width = 100,
				height = 200,
				defaultFile = "start.png",
				onEvent = handleMenuButtonEvent
			}
		)
        
		sceneGroup:insert( menuButton) --ADD DROPDOWN MENU
		
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
