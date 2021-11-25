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
local Item = require ( "item" )
local Spaghetti = require ( "spaghetti" )


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
	local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight) 	background:setFillColor( 2 )	-- white
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background.xScale = 1.5;
	background.yScale = 1;
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
		width = display.contentWidth * 0.95,
		height = display.contentHeight * 0.6,
		speed = 250,
		inEasing = easing.outBack,
		outEasing = easing.outCubic
	}
 ---------------------------------------------------------------------------------
	-- CREATE FOOD ITEMS AND BUTTONS
 -- This closes the panel and spawns the chosen item
	local function chooseBurgerEvent(event)
		if (event.phase == "ended") then 
			-------- Create Burger object
			burger = Item:new({xPos=x, yPos=y});
			burger:spawn(sceneGroup); 
			panel:hide()
		end
	end

	panel.background = display.newRect( 0, 0, panel.width, panel.height )
	panel.background:setFillColor( 0, 0.25, 0.5 )
	panel:insert( panel.background )

	local burgerButton = widget.newButton(
		{
			width = 1113,
			height = 876,
			defaultFile = "burger.png",
			onEvent = chooseBurgerEvent
		}
	)
	burgerButton.x = display.contentCenterX-200
	burgerButton.y = display.contentCenterY-300
	burgerButton.xScale = .05
	burgerButton.yScale = .05
	panel:insert(burgerButton)


	-- This closes the panel and spawns the chosen item
	local function chooseSpaghettiEvent(event)
		if (event.phase == "ended") then 
			-------- Create Burger object
			spaghetti = Spaghetti:new({xPos=x, yPos=y});
			spaghetti:spawn(sceneGroup); 
			panel:hide()
		end
	end
	
	local spaghettiButton = widget.newButton(
		{
			width = 1500,
			height = 700,
			defaultFile = "spaghet.png",
			onEvent = chooseSpaghettiEvent
		}
	)
	spaghettiButton.x = display.contentCenterX-135
	spaghettiButton.y = display.contentCenterY-300
	spaghettiButton.xScale = .05
	spaghettiButton.yScale = .05
	panel:insert(spaghettiButton)

	---------------------------------------------------------------------------------
	panel.title = display.newText( "menu", 0, 0, native.systemFontBold, 18 )
	panel.title:setFillColor( 1, 1, 1 )
	panel:insert( panel.title )

	--start button
	local function handleButtonEvent( event )
		if ( "ended" == event.phase ) then
			print( "Hide Panel button was pressed and released" )
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
	-- Create panel button
	local function handleButtonEvent( event )
	
		if ( "ended" == event.phase ) then
			print( "Create Panel button pressed and released" )
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
	panelButton.x = 275
	panelButton.y = 20
	sceneGroup:insert( panelButton) --ADD DROPDOWN MENU
	
	sceneGroup:insert(panel)
    --sceneGroup:insert( petObj )
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		local healthBarValue=pet.Hunger
        local happyBarValue=pet.Happiness
        local cleanBarValue=pet.Cleanliness
        
    
        local healthBar = display.newRect(100, 100, healthBarValue, 50)
        healthBar:setFillColor(1, 0, 0, 0.5)
        healthBar.anchorX = 0

        local happyBar= display.newRect(100, 40, happyBarValue, 50)
        happyBar:setFillColor(0, 1, 0, 0.5)
        happyBar.anchorX = 0

        local cleanBar= display.newRect(100, -20, cleanBarValue, 50)
        cleanBar:setFillColor(0, 0, 1, 0.5)
        cleanBar.anchorX = 0


        local petTimer = timer.performWithDelay(
            1000,
            function()
                pet.Hunger=petObj.Hunger-3
                pet.Happiness=petObj.Happiness-2
                pet.Cleanliness=petObj.Cleanliness-1
                
                healthBarValue=petObj.Hunger
                happyBarValue=petObj.Happiness
                cleanBarValue=petObj.Cleanliness
                
                healthBar.width=healthBar.width-2
                happyBar.width=happyBar.width-3
                cleanBar.width=cleanBar.width-1
                print("Hunger " .. healthBarValue)
                print("Happy " .. happyBarValue)
                print("Clean ".. cleanBarValue)

                
            end,
            0
        )

        print (healthBarValue)
        print (happyBarValue)
        print (cleanBarValue)
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		----------------------------------------------------------------------------------------
		-- --test Menu button
		-- local function handleMenuButtonEvent( event )
		
		-- 	if ( "ended" == event.phase ) then
		-- 		print( "Menu testing Button was pressed and released" )
		-- 		--composer.gotoScene( "view2" )
		-- 		composer.gotoScene( "view1" )
		-- 	end
		-- end

		-- --local startButton = display.newImageRect("start.png", 100, 100)
		-- local menuButton = widget.newButton(
		-- 	{
		-- 		width = 100,
		-- 		height = 200,
		-- 		defaultFile = "start.png",
		-- 		onEvent = handleMenuButtonEvent
		-- 	}
		-- )
        
		-- sceneGroup:insert( menuButton) --ADD DROPDOWN MENU
		
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
