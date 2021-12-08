----------------------------------------------------------------------------------------
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
local Drink = require ( "drink")
local physics = require ("physics")
local loadsave = require("loadsave")
local scene = composer.newScene()
local soundToggleTable = { isSoundOn = true }
local scoreTable = { currentScore = 0 }
local highscoreTable = { highscore= 0 }
local defaultLocation = system.DocumentsDirectory

if(loadsave.loadTable("highscore.json")== nil ) then
	loadsave.saveTable(highscoreTable,"highscore.json")
	composer.setVariable("highscore", highscoreTable["highscore"])
end
pet.isIdle = true
pet.isPetMirrored = false
physics.start()
physics.setGravity (0,0); -- 0 G
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
	
	physics.start()
	-- all necessary imports
	local sceneGroup = self.view
	Pet = require('pet')
	local mainMusic = audio.loadSound("petapp.mp3");
	audio.play(mainMusic, {loops=-1});
	local function ToggleSoundEvent(event)
		if(event.phase ==  "ended") then 
			if (soundToggleTable["isSoundOn"]== true) then 
				soundToggleTable["isSoundOn"] = false
				audio.pause()
				loadsave.saveTable(soundToggleTable, "sound.json")
			else soundToggleTable["isSoundOn"] = true
				loadsave.saveTable(soundToggleTable, "sound.json")
				audio.resume()
			end
			
		end 
	end 
	
	
	local SoundButton = widget.newButton(
			{
				width = 240,
				height = 20,
				left = 40,
				top = 500,
				label = "Toggle Sound",
				font = native.systemFontBold,
				onEvent = ToggleSoundEvent
			}
		)
	-- create a background to fill screen
	local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight) 	background:setFillColor( 2 )	-- white
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background.xScale = 1.5;
	background.yScale = 1.3;
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
	panel.background = display.newRect( 0, 0, panel.width, panel.height )
	panel.background:setFillColor( 0, 0.25, 0.5 )
	panel:insert( panel.background )
 ---------------------------------------------------------------------------------
	-- CREATE FOOD ITEMS AND BUTTONS
 -- This closes the panel and spawns the chosen item
	local function chooseBurgerEvent(event)
		if (event.phase == "ended") then 
			-------- Create Burger object
			burger = Item:new({xPos=x, yPos=y});
			burger:spawn(sceneGroup); 
			burger.tag = "food"
			panel:hide()
		end
	end

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

	local function chooseDrinkEvent(event)
		if (event.phase == "ended") then 
			-------- Create Burger object
			drink = Drink:new({xPos=x, yPos=y});
			drink:spawn(sceneGroup); 
			panel:hide()
		end
	end

	local drinkButton = widget.newButton(
		{
			width = 515,
			height = 515,
			defaultFile = "gfuel.png",
			onEvent = chooseDrinkEvent
		}
	)
	drinkButton.x = display.contentCenterX-75
	drinkButton.y = display.contentCenterY-300
	drinkButton.xScale = .15
	drinkButton.yScale = .15
	panel:insert(drinkButton)


	-- This closes the panel and spawns the chosen item
	local function chooseSpaghettiEvent(event)
		if (event.phase == "ended") then 
			-------- Create Burger object
			spaghetti = Spaghetti:new({xPos=x, yPos=y});
			spaghetti:spawn(sceneGroup); 
			spaghetti.tag = "food"
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
			width = 80,
			height = 80,
			left = 70,
			top = 45,
			defaultFile = "Icon_Inventory.png",
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


	--Walls so that the ball does not fall
	local bottom = display.newRect(0, display.contentHeight-10, display.contentWidth, 20)
	bottom.anchorX = 0; bottom.anchorY = 0
	local left = display.newRect(0, 0, 5, display.contentHeight)
	left.anchorX = 0; left.anchorY = 0
	local right = display.newRect(display.contentWidth-5, 0, 20, display.contentHeight)
	right.anchorX = 0; right.anchorY = 0
    wallCollisionFilter = { categoryBits=8, maskBits=1 }
	physics.addBody(bottom, 'static', {filter = wallCollisionFilter})
	physics.addBody(left, 'static', {filter = wallCollisionFilter})
	physics.addBody(right, 'static', {filter = wallCollisionFilter})
	bottom.isVisible = false;
	left.isVisible = false;
	right.isVisible = false;
	sceneGroup:insert(bottom)
	sceneGroup:insert(left)
	sceneGroup:insert(right)


	--Zone with Physics for toy chasing
	-- toy chasing zone
	local zone = display.newRect (display.contentCenterX, display.contentCenterY +150, display.contentWidth-10, display.contentHeight-300);
	zone:toFront();
	zone:setFillColor(1,1,0,0.1); 
	zone.strokeWidth = 5;
	zone.isVisible = false;
	zoneCollisionFilter = { categoryBits=16, maskBits=5 }
	physics.addBody ( zone, "static", {filter = zoneCollisionFilter});
	zone.isSensor = true;

	-- Toy and Sprite Physics
	local toy = display.newCircle( 275, 100, 25 )
	toy.tag = "toy"
	toy.toySound = audio.loadSound( "toysound.wav" )
	local paint = { --This fills the circle with the toy.png as a "texture"
		type = "image",
		filename = "toy.png"
	}
	toy.fill = paint
	toy.fill.scaleX = 2.5
	toy.fill.scaleY = 3
	--Toy Physics
	toyCollisionFilter = { categoryBits=1, maskBits=28 }
	physics.addBody(toy, "static",{density=1.0, friction=0.3, bounce=0.3, filter = toyCollisionFilter})


	local petChaseToy = function ()
		return petObj:movePet(toy.x, toy.y)
	end 

	function zoneHandler(event)
		if (event.phase == "began") and (event.other.tag == "toy") then -- Chase the toy
			--Activate 
			petObj.isIdle = false
			tempTimer = timer.performWithDelay(100, petChaseToy, 0); -- Repeatedly chase the ball while its on the floor

		elseif (event.phase == "ended") then
			timer.cancel(tempTimer)
			petObj.isIdle = true
			transition.cancel();
		end
	end

	local function onToyTouch(event)
		local touchedObject = event.target
		if event.phase == "began" then
			print("toy touched by human")

			touchedObject.previousX = touchedObject.x
			touchedObject.previousY = touchedObject.y
			audio.play( event.target.toySound )
			audio.setVolume(0.2)
			event.target.bodyType = "static"
			
		elseif event.phase == "moved" then
			touchedObject.x = (event.x - event.xStart) + touchedObject.previousX
			touchedObject.y = (event.y - event.yStart) + touchedObject.previousY

		elseif event.phase == "ended" then
			event.target.bodyType = "dynamic"
		end
		return true
	end
	sceneGroup:insert(toy)
	sceneGroup:insert(zone)
	zone:addEventListener("collision", zoneHandler)
	toy:addEventListener("touch", onToyTouch)

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	petObj:changeSequence("idle") -- started idle sequence here instead of inside the pet object :)
	--get pet hunger, happiness, cleanliness. Show it with rectangles. Use time to make it shrink.
	if phase == "will" then
		local scoreText = display.newText("Score: ", display.contentCenterX,10, native.systemFontBold);
		scoreText:setFillColor(0,0,0,1);
		sceneGroup:insert(scoreText)
		local healthBarValue=pet.Hunger
        local happyBarValue=pet.Happiness
        local cleanBarValue=pet.Cleanliness
		
        local healthBar = display.newRect(30, 120, healthBarValue, 50)
		local healthBarLabel = display.newText("Hunger", 50,  120, native.systemFontBold)
		healthBarLabel:setFillColor(0,0,0)
        healthBar:setFillColor(1, 0, 0, 0.5)
        healthBar.anchorX = 0

        local happyBar= display.newRect(30, 60, happyBarValue, 50)
		local happyBarLabel= display.newText("Happiness", 50, 60, native.systemFontBold)
		happyBarLabel:setFillColor(0,0,0);
        happyBar:setFillColor(0, 1, 0, 0.5)
        happyBar.anchorX = 0

        local cleanBar= display.newRect(30, 0, cleanBarValue, 50)
		local cleanBarLabel = display.newText("Cleanliness",50, 0, native.systemFontBold)
		cleanBarLabel:setFillColor(0,0,0);
        cleanBar:setFillColor(0, 0, 1, 0.5)
        cleanBar.anchorX = 0
		sceneGroup:insert(happyBarLabel)
		sceneGroup:insert(healthBarLabel)
		sceneGroup:insert(cleanBarLabel)

        
		--------------------------------------------------------------
		---- Pet timer. changes sequences ?
		--------------------------------------------------------
        petTimer = timer.performWithDelay(
            1000,
            function()
				scoreTable["currentScore"] = tonumber(scoreTable["currentScore"]) + 1
				scoreText.text = "Score: " .. scoreTable["currentScore"]
				composer.setVariable("highscore",scoreTable["currentScore"]);
					print(scoreTable["currentScore"])
					pet.Hunger=petObj.Hunger-1 *tonumber(scoreTable["currentScore"] * 0.5)
					pet.Happiness=petObj.Happiness-2 * tonumber(scoreTable["currentScore"] * 0.7)
					pet.Cleanliness=petObj.Cleanliness-3 * tonumber(scoreTable["currentScore"] * 0.9)


				


					
                
                healthBarValue=petObj.Hunger
                happyBarValue=petObj.Happiness
                cleanBarValue=petObj.Cleanliness

                healthBar.width=healthBarValue
                happyBar.width=happyBarValue
                cleanBar.width=cleanBarValue
              --  print("Hunger " .. healthBarValue)
				--print(petObj.Hunger)
               -- print("Happy " .. happyBarValue)
				--print(petObj.Happiness)
               -- print("Clean ".. cleanBarValue)
				--print(petObj.Cleanliness)

				if (happyBarValue < 50 and cleanBarValue < 50 and healthBarValue< 50 ) then
					print("Sad")
					petObj.isSad = true
					petObj:changeSequence("sadIdle")

				end
				if (happyBarValue <= 0 and healthBarValue <= 0 and cleanBarValue <= 0) then

					composer.gotoScene( "death" )

				end
            end,
            0
        )
		sceneGroup:insert( healthBar)
		sceneGroup:insert( happyBar)
		sceneGroup:insert( cleanBar)

		-- THIS CODE will check if the pet is in an idle state, and if so, will move it randomly around the ground
		-- Make sure you set petObj.isIdle to false whenever the pet should be focused/interacting with something
        if (petObj.isIdle == true) then
			timer.performWithDelay(3000, function() petObj:movePet(math.random(50, display.contentWidth - 100), math.random(300, display.contentHeight - 50)) end, 0)
		end


		
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		----------------------------------------------------------------------------------------
		--test Menu button
		local function handleMenuButtonEvent( event )
		
			if ( "ended" == event.phase ) then
				print( "Menu testing Button was pressed and released" )
				--composer.gotoScene( "view2" )
				timer.pause( petTimer )
				composer.gotoScene( "view1" )
			end
		end

		--[[
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
		--]]

		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		timer.cancel(petTimer)
		-- Called when the scene is on screen and is about to move off screen
		local loadedTable = loadsave.loadTable("highscore.json")
		 if loadedTable["highscore"] < scoreTable["currentScore"] then
			 loadedTable["highscore"] = scoreTable["currentScore"]
			 composer.setVariable("highscore",scoreTable["currentScore"]);
			 
			 loadsave.saveTable(loadedTable, "highscore.json")
		 end
		audio.pause()
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	toy.removeSelf()
	--pet.removeSelf
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
