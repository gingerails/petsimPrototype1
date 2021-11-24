local physics = require("physics");

local Item = {tag="shape", xPos=0, yPos=0};

function Item:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end
-----------------------------------------------------------------------------
-- spawn()
-- Item:spawn ()
-- will determine the shape type: ‘circle,’ color, and physics body type
-- (dynamic), as specified in main.lua
-----------------------------------------------------------------------------

function Item:spawn(grp)
    self.shape=display.newImage("burger.png", self.x, self.y);
    self.shape.pp = self;  -- parent object
    self.shape.tag = self.tag; -- “shape”
    self.shape.xScale = .05   --Scale the pet down some
    self.shape.yScale = .05
    self.shape.x = 50
    self.shape.y = 500
    --self.shape:addEventListener
    print("made item")
    self.shape.touch = function (s, event) s.pp:touch(event) end
    self.shape:addEventListener("touch", touch )

    self:sound();
    if grp then grp:insert(self.shape) end    --Adds to display/sceneGroup?
end

-----------------------------------------------------------------------------
-- touch()
-- Shape:touch()will allow the user to remove the shape if it is touched and play sound.
-----------------------------------------------------------------------------
-- function Item:touch(event)
--     if ( event.phase == "began" ) then
--         print( "Touch event began on: " .. self.tag )
--         self:sound();
--         self.shape.x = 200
--         self.shape.y = 300
--     end
    
-- end

function Item:touch( event )
    if event.phase == "began" then
    
        display.getCurrentStage():setFocus( event.target )
        self.markX = self.shape.x    -- store x location of object
        self.markY = self.shape.y    -- store y location of object
    
    elseif event.phase == "moved" then
    
        local x = (event.x - event.xStart) + self.markX
        local y = (event.y - event.yStart) + self.markY
    
        self.shape.x, self.shape.y = x, y
    
    elseif event.phase == "ended"  or event.phase == "cancelled" then
    
        display.getCurrentStage():setFocus(nil)
    
    end
    
    return true
    
end


-----------------------------------------------------------------------------
-- sound()
-- Item:sound() will play rectSound.wav you can download it from dropbox folder
-----------------------------------------------------------------------------

function Item:sound ()	
	local touchSound = audio.loadSound( "clickappear2.mp3" )
    audio.play( touchSound )
end





return Item