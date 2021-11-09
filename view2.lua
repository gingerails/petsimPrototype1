-----------------------------------------------------------------------------------------
-- This view is the pet main screen
-- view2.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
--DROPDOWN PANEL WIDGET, 
-- This could be used for bath/inventory/shop
-- Could also make this its own file class, but I'm not doing that right now.
---------------------------------------------------------------------------------
function widget.newPanel( options )
    local customOptions = options or {}
    local opt = {}
 
    opt.location = customOptions.location or "top"
 
    local default_width, default_height
    if ( opt.location == "top" or opt.location == "bottom" ) then
        default_width = display.contentWidth
        default_height = display.contentHeight * 0.33
    else
        default_width = display.contentWidth * 0.33
        default_height = display.contentHeight
    end
 
    opt.width = customOptions.width or default_width
    opt.height = customOptions.height or default_height
 
    opt.speed = customOptions.speed or 500
    opt.inEasing = customOptions.inEasing or easing.linear
    opt.outEasing = customOptions.outEasing or easing.linear
 
    if ( customOptions.onComplete and type(customOptions.onComplete) == "function" ) then
        opt.listener = customOptions.onComplete
    else 
        opt.listener = nil
    end
 
    local container = display.newContainer( opt.width, opt.height )
 
    if ( opt.location == "left" ) then
        container.anchorX = 1.0
        container.x = display.screenOriginX
        container.anchorY = 0.5
        container.y = display.contentCenterY
    elseif ( opt.location == "right" ) then
        container.anchorX = 0.0
        container.x = display.actualContentWidth
        container.anchorY = 0.5
        container.y = display.contentCenterY
    elseif ( opt.location == "top" ) then
        container.anchorX = 0.5
        container.x = display.contentCenterX
        container.anchorY = 1.0
        container.y = display.screenOriginY
    else
        container.anchorX = 0.5
        container.x = display.contentCenterX
        container.anchorY = 0.0
        container.y = display.actualContentHeight
    end
 
    function container:show()
        local options = {
            time = opt.speed,
            transition = opt.inEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "shown"
        end
        if ( opt.location == "top" ) then
            options.y = display.screenOriginY + opt.height
        elseif ( opt.location == "bottom" ) then
            options.y = display.actualContentHeight - opt.height
        elseif ( opt.location == "left" ) then
            options.x = display.screenOriginX + opt.width
        else
            options.x = display.actualContentWidth - opt.width
        end 
        transition.to( self, options )
    end
 
    function container:hide()
        local options = {
            time = opt.speed,
            transition = opt.outEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "hidden"
        end
        if ( opt.location == "top" ) then
            options.y = display.screenOriginY
        elseif ( opt.location == "bottom" ) then
            options.y = display.actualContentHeight
        elseif ( opt.location == "left" ) then
            options.x = display.screenOriginX
        else
            options.x = display.actualContentWidth
        end 
        transition.to( self, options )
    end
 
    return container
end

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

panel.background = display.newRect( 0, 0, panel.width, panel.height )
panel.background:setFillColor( 0, 0.25, 0.5 )
panel:insert( panel.background )
 
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
--local startButton = display.newImageRect("start.png", 100, 100)

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
-- Once again, probably should be in its own file.
---------------------------------------------------------------------------------
--
--
-- Here is the actual scene code.
--
--
---------------------------------------------------------------------------------
-- Create the scene
---------------------------------------------------------------------------------


function scene:create( event )
	local sceneGroup = self.view
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- create a white background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 2 )	-- white

    --lazy placeholder for cat
    local cat = display.newImageRect( "catLay.png", 382, 278) 
	cat.x = display.contentCenterX-70
	cat.y = display.contentCenterY+100
	cat.xScale = .5;
	cat.yScale = .5;
	
	
	-- all objects must be added to group (e.g. self.view)
	--sceneGroup:insert( panelButton)
	sceneGroup:insert( background )
    sceneGroup:insert( cat )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
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
