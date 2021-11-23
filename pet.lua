--local physics = require("physics");

local Pet = {tag="pet", HP=100, xPos=0, yPos=0};

function Pet:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end

function Pet:spawn(grp)
  ----------------------------------------------------
  -- Spawn sprite: grp is the sceneGroup
  -- This section holds all the animation/frame data
  local opt =
  {
    frames = {
      { x = 0, y = 48, width = 463, height = 432}, -- idle frame
      { x = 478, y = 54,  width = 463, height = 432}, -- eating frame
      { x = 943, y = 8, width = 557, height = 481}, -- petting frame 1
      { x = 11, y = 525, width = 579, height = 481}, -- petting frame 2
      { x = 592, y = 584, width = 442, height = 419}, -- walking frame 1
      { x = 1046, y = 586, width = 447, height = 419}, -- walking frame 2
    }
  }

  -- This section sets up our animation object
  -- Set up a sprite sheet with our image
  local sheet = graphics.newImageSheet( "PetSpriteSheet.png", opt);--RYU IS HERE

 -- Make a sequence table
  local seqData = {
    {name = "idle", frames={1}, time=900, loopCount = 0},--Idle phase, 0 loop count for infinite playbacks
    {name = "eating", frames={1, 2}, time = 900, loopCount = 0},-- Eating 
    {name = "petting", frames={3, 4}, time = 900, loopCount = 0},-- Petting
    {name = "walking", frames={5, 6}, time = 900, loopCount = 9}-- Walking
  }
 
 self.shape=display.newSprite (sheet, seqData);
 self.shape.pp = self;  -- parent object
 self.shape.tag = self.tag; -- “pet”

 ------------Set up animation and placement of sprite
  -- Values for our anim
  self.shape.anchorX = 0.0--Anchor x
  self.shape.anchorY = 1.0--Anchor y
  --Both anchors are for the shadows
  self.shape.x = display.contentCenterX-100     -- Semi-centers the pet
  self.shape.y = display.contentCenterY+150
  self.shape.xScale = .45   --Scale the pet down some
  self.shape.yScale = .45

  self.shape:setSequence("petting")--animation sequence set to idle while nothing else happens.
  -- default: will play the first seq listed in seqData
  self.shape:play();
  if grp then grp:insert(self.shape) end    --Adds to display/sceneGroup?

end


function Pet:changeSequence(arg)
  self.shape:setSequence("walking")
  self.shape:play();
end


function Pet:HealthDrain()
  pet.HP = pet.HP - 1
end

function Pet:back ()
  transition.to(self.shape, {x=self.shape.x, y=150,  
  time=self.fB, rotation=self.bR, 
  onComplete=function (obj) self:forward() end} );
end

function Pet:side ()   
   transition.to(self.shape, {x=self.shape.x, 
   time=self.fS, rotation=self.sR, 
   onComplete=function (obj) self:back() end } );
end

function Pet:forward ()   
   transition.to(self.shape, {x=self.shape.x, y=800, 
   time=self.fT, rotation=self.fR, 
   onComplete= function (obj) self:side() end } );
end

function Pet:move ()	
	self:forward();
end


return Pet