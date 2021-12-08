local physics = require("physics");
local Pet = {tag="pet", Happiness = 100, Cleanliness = 100, Hunger = 100, xPos=0, yPos=0, isIdle = false, isMirrored = false, isSad = false, physics = {"dynamic", {}}};

function Pet:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end

local function petCollisionHandler(self, event) -- This function fires when the pet collides with a physics body
  print("detected a collision")
  if event.other.tag == "toy" then -- CODE THAT EXECUTES WHEN THE PET GETS A TOY
   transition.to(event.other, {x = 275, y = 100, time = 0})
    event.other.bodyType = "static" -- THIS LINE WONT SET TOY TO STATIC PHYSICS BODY FOR SOME REASON
    print (event.other.bodyType)
    print ("got the toy!")
    audio.play (event.other.toySound)
    isIdle = true
    Pet.Happiness = 100

  elseif event.other.tag == "food" then
    print ("got the food! Yum!")
    local foodSound = audio.loadSound( "animal_eat_herb.mp3" )
    audio.play( foodSound )
    Pet.Hunger = 100
    event.other:removeSelf()
    event.other = nil

  end
end

function Pet:spawn(grp)
  ----------------------------------------------------
  -- Spawn sprite: grp is the sceneGroup
  -- This section holds all the animation/frame data
  local opt =
  {
    frames = {
        -- HAPPY
        { x = 0, y = 64, width = 463, height = 432}, -- idle frame, 1
        { x = 478, y = 54,  width = 463, height = 432}, -- eating frame, 2
        { x = 943, y = 8, width = 557, height = 481}, -- petting frame 1, 3
        { x = 11, y = 525, width = 579, height = 481}, -- petting frame 2, 4
        { x = 592, y = 584, width = 442, height = 419}, -- walking frame 1, 5
        { x = 1046, y = 586, width = 447, height = 419}, -- walking frame 2, 6
        { x = 1497, y = 64, width = 480, height = 436}, -- blinking frame, 7
        { x = 1974, y = 64, width = 486, height = 436}, -- alt idle frame, 8
        -- SAD
        { x = 0, y = 1056, width = 463, height = 432}, -- idle frame, 9
        { x = 478, y = 1054,  width = 460, height = 432}, -- eating frame, 10
        { x = 952, y = 1055, width = 510, height = 433}, -- petting frame 1, 11
        { x = 0, y = 1573, width = 510, height = 433}, -- petting frame 2, 12
        { x = 572, y = 1578, width = 459, height = 433}, -- walking frame 1, 13
        { x = 1031, y = 1580, width = 459, height = 433}, -- walking frame 2, 14
        { x = 1499, y = 1066, width = 450, height = 433}, -- blinking frame, 15
        { x = 1975, y = 1054, width = 488, height = 436} -- alt idle frame, 16
    }
  }

  -- This section sets up our animation object
  -- Set up a sprite sheet with our image
  local sheet = graphics.newImageSheet( "PetSpriteSheet.png", opt);--RYU IS HERE

 -- Make a sequence table
  seqData = {
  {name = "idle", frames={1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 8, 8, 8, 8, 1, 1, 1, 1, 7}, time=1500, loopCount = 0},--Idle phase, 0 loop count for infinite playbacks
  {name = "eating", frames={1, 2}, time = 900, loopCount = 0},-- Eating 
  {name = "petting", frames={3, 4}, time = 900, loopCount = 0},-- Petting
  {name = "walking", frames={5, 6}, time = 900, loopCount = 9},-- Walking

  {name = "sadIdle", frames={9, 16, 15}, time=1500, loopCount = 0},-- sad Idle phase, 0 loop count for infinite playbacks
  {name = "sadEating", frames={9, 10}, time = 900, loopCount = 0},-- Eating 
  {name = "sadPetting", frames={11, 12}, time = 900, loopCount = 0},-- Petting
  {name = "sadWalking", frames={13, 14}, time = 900, loopCount = 9}-- Walking
  }
 
 self.sprite = display.newSprite (sheet, seqData);
 self.sprite.pp = self;  -- parent object
 self.sprite.tag = self.tag; -- “pet”

 ------------Set up animation and placement of sprite
  -- Values for our anim
  self.sprite.anchorX = 0.5--Anchor x
  self.sprite.anchorY = 0.5--Anchor y
  --Both anchors are for the shadows
  self.sprite.x = display.contentCenterX-100     -- Semi-centers the pet
  self.sprite.y = display.contentCenterY+150
  self.sprite.xScale = .25  --Scale the pet down some
  self.sprite.yScale = .25
  self.isMirrored = false
  --self.initShape(grp)
  -- self.sprite:addEventListener("touch", touch) -- THIS LINE WONT WOKR AAAAAAAA

  -- Create a hitbox/collider for our pet sprite to have some level of physics interaction
  self.collider = display.newRect(self.sprite.x, self.sprite.y, 90, 90)
  self.collider.alpha = 0.0
  petCollisionFilter = { categoryBits=4, maskBits=7 }
  physics.addBody(self.collider, "kinematic", {filter = petCollisionFilter})
  self.collider.isSensor = true
  self.collider.collision = petCollisionHandler -- Define the collision function for the pet's collider hitbox
  self.collider:addEventListener("collision") -- Ditto

  self.sprite.touch = function (s, event) s.pp:touch(event) end
  if grp then grp:insert(self.sprite) end
  self.sprite:addEventListener("touch", touch )

  self.sprite.collision = function (s, event) s.pp:collision(event) end
  self.sprite.preCollision = function (s, event) s.pp:collision(event) end
  self.sprite.postCollision = function (s, event) s.pp:collision(event) end
  self.sprite:addEventListener("collision")
  self.sprite:addEventListener("preCollision")
  self.sprite:addEventListener("postCollision")
end


----------- Pet the pet!
function Pet:touch(event)
  
  if event.phase == "began" then
    previousSeq = self.sprite.sequence -- Store previous sequence, set the new one to be walking during transition
    if self.isSad == true then
      local petSound = audio.loadSound( "purr.mp3" )
      audio.play( petSound )
      self.sprite:setSequence("sadPetting")
      Pet.Cleanliness = 100

      self.sprite:play()
    else
      local petSound = audio.loadSound( "purr.mp3" )
      audio.play( petSound)
      self.sprite:setSequence("petting")
      Pet.Cleanliness = 100
      self.sprite:play()
    end
  elseif event.phase == "ended" then
    self.sprite:setSequence(previousSeq) -- Restore the sequence from before the transition
    self.sprite:play()
  end
  
end

function Pet:changeSequence(arg)
  self.sprite:setSequence(arg)
  self.sprite:play();
end



-- This function will transition the pet to wherever you want it to go, just pass it the X/Y co-ords
function Pet:movePet(xPos, yPos)
  function onPetMoveStart(movingObj) -- This listener func is called when the pet starts transitioning
    previousSeq = movingObj.sequence -- Store previous sequence, set the new one to be walking during transition
    if self.isSad == true then
      movingObj:setSequence("sadWalking")
      --print("whyousosadddd")
      movingObj:play()
    else
      movingObj:setSequence("walking")
      movingObj:play()
    end
  end
  
  function onPetMoveComplete(movingObj) -- This listener func is called when the pet finishes transitioning
    movingObj:setSequence(previousSeq) -- Restore the sequence from before the transition
    if movingObj.sequence == "petting" then
      movingObj:setSequence("idle")
    end
    movingObj:play()
  end

	petTrans = transition.to(self.sprite, {x = xPos, y = yPos, time = 1000, onStart = onPetMoveStart, onComplete = onPetMoveComplete}) -- Transition pet to co-ords
  transition.to(self.collider, {x = xPos, y = yPos, time = 1000})
	-- Mirror sprite code
  if (self.isMirrored == false) and (xPos < self.sprite.x) then -- Mirror the sprite if facing left
		self.sprite:scale( -1, 1 )
		self.isMirrored = true
	elseif (self.isMirrored == true) and (xPos > self.sprite.x) then -- ditto for changing direction
		self.sprite:scale( -1, 1 )
		self.isMirrored = false
	end
end

-- CURRENTLY UNUSED FUNCTION
-- Pet idle function, if idle is on (pet is doing nothing else) have it randomly walk around
function Pet:petIdle()
  print("pet is idling")
	if isIdle == true then
		randXPos = math.random(50, display.contentWidth - 100) -- Figure out random x position within the bounds of the floor
		randYPos = math.random(300, display.contentHeight - 50) -- ditto for y position
		Pet:movePet(randXPos, randYPos) -- Move the pet there
	end
end

-- Pet:initShape(grp)
-- Initializes entity's shape by creating necessary references,
-- adding it to given group, and setting up physics.
-- This is done to avoid repeating code in children's spawn methods.
-- function Pet:initShape(grp)
--   print("GOOOOOOOOOOOOOOOOOOOOTTHISFAR")
--   --if not self.sprite then return end
--  -- print("GOOOOOOOOOOOOOOOOOOOOTTHISFAR")
--   -- Set up references
--   self.sprite.pp = self
--   self.sprite.tag = self.tag

--   -- Add to DisplayGroup
--   if grp then grp:insert(self.sprite) end

--   -- Set up physics
--   local body, params = unpack(self.physics)
  
--   self.shape.collision = petCollisionHandler
--   print("GOOOOOOOOOOOOOOOOOOOOTTHISFAR")

--   -- Set up collision handler
--   --self.sprite.collision = function (s, event) s.pp:collision(event) end
--   --self.sprite.preCollision = function (s, event) s.pp:collision(event) end
--   --self.sprite.postCollision = function (s, event) s.pp:collision(event) end
--   --self.sprite:addEventListener("collision")
--   --self.sprite:addEventListener("preCollision")
--   --self.sprite:addEventListener("postCollision")
  
-- end

-- Pet:collision(event)
-- Collision handler for Entities
-- Acts for preCollision, collision, and postCollision.
-- Check event.name to ensure proper behavior
function Pet:collision(event)
    if event.name == "collision" then
      print("collision?")
    end
end

function Pet:back ()
  transition.to(self.sprite, {x=self.sprite.x, y=150,  
  time=self.fB, rotation=self.bR, 
  onComplete=function (obj) self:forward() end} );
end

function Pet:side ()
   transition.to(self.sprite, {x=self.sprite.x, 
   time=self.fS, rotation=self.sR, 
   onComplete=function (obj) self:back() end } );
end

function Pet:forward ()   
   transition.to(self.sprite, {x=self.sprite.x, y=800, 
   time=self.fT, rotation=self.fR, 
   onComplete= function (obj) self:side() end } );
end

function Pet:move ()	
	self:forward();
end


return Pet