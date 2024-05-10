# Mechanically Challenged Slopes and Loop
#### By Taffaz

## Basic Instructions For Playing
Left Arrow 	/ A : Move Left
Right Arrow / D : Move Right
## Project Overview

### Housekeeping
3 Layers have been created: LAYER_BG, LAYER_FG, LAYER_TRANSITION
These are used for the loops to allow collisions to be ignored.
The Physics2D settings have been tweaked so LAYER_BG and LAYER_FG don't collide.
The player must be on one of these three layers
LAYER_TRANSITION is used when you need the player to collide with LAYER_BG and LAYER_FG

3 Sorting Layers have been created: SORTING_BG, SORTING_PLAYER and SORTING_FG
These are used in the sprite renderers (inc. Sprite Shape Renderers) to give the illuision the player is running behind one of the loop sections
### Player Prefab: 
Player must have the Player Tag and be on one of the layers
Simple RigidBody2D with a circle collider and a capsule sprite.
### Slope Prefab:
Slopes must have the Terrain Tag
There is a slope prefab that can be used to start a new slope

Contains a Sprite shape controller that allows the slope to be crafted using bezier curves. The sprites automatically adjust to the shape of the curve. This is a fairly powerful system and the setup here only uses a small amount of it so there is area to expore here.

Slopes have an EdgeCollider2d, this hasn't caused any issues for me but this can be swapped out with a PolygonCollider2d if there are issues.
### Loop Prefab
Loops consist of multiple LoopSection prefabs and is just a container.
### LoopSection Prefab
Same setup as the Slope prefab but the curve is setup in a way that 4 of them together, rotated accordingly makes a full loop

They can also be used independently or in other configurations such as at the end of the sample level with a half loop to change direction.
### LayerTrigger Prefab
Simple prefab with a LayerTrigger component and trigger collider. See LayerTrigger component overview for more details.
### Player Physics Material
Used to set friction and bounciness to 0 on the player
### Sprites and Sprite Shape Profiles
There are some basic sprites for grass, dirt and stone with accompanying sprite shape profiles. These sprite shape profiles are assigned to the SpriteShapeControllers in the inspector to determine which sprite they use.
## Component Overview

### PlayerController
This provides the settings for the player movements as well as well as controls the player behaviour on slopes and loops.

The main difference between a vanilla 2d controller and this is to do with how the player reacts varying slopes.
When the player is grounded, gravityNormal is set to the normal of the contact point on the Terrain.
This means gravity sticks the player to the slope and the loop allowing players to run upside down.

###### Serialized Fields
    float gravity: 				Strength of gravity along the gravity normal
    float maxSpeed: 			Limits the speed of the player
    float maxAngleChange: 		Controls the speed the player adjusts to the slope change, too high a value and the player can seem jerky
    float baseAcceleration: 	Controls the rate the player speeds up
    float airSpeedMultiplier: 	Reduces the players movement agency whilst in the air
	float groundAirTransition:	The time in seconds before gravity resets when isGrounded is false.
								Too long and gravity pulls player in the air forward. Too short and small bumps in the slope and loop can detach the player.
	
###### Private Fields
	
	Vector2 	moveDirection: 	Set by the HandleInput() method based on player input
	Rigidbody2D rb: 			Standard Unity RigidBody2D for physics
	float 		angle: 			Set in HandleGrounded and the Collision events and then used in AdjustRotation() to adjust the Rigidbody2D rotation
	bool 		isGrounded: 	Set in collision events. Used in HandleGrounded to determine if gravity and angle should be reset and in AdjustSpeed() for slope effect.
	Vector2 	gravityNormal: 	Provides the current direction of gravity. 
								Set in collision events to normal of terrain collided with as well as in AdjustGravity() to drop from top of loop if too slow.
								Used in AdjustGravity to apply gravity in a way that sticks players to the slope and AdjustSpeed() for slope effects
	float 		groundedTimer:	Simple float timer to give a delay after player leaves the ground and gravity and angle get reset.
								This helps with the little imperfections in the slopes causing the player to momentarily leave the ground.
	
### LayerTrigger
Reusable component that does the simple job of switching the player layer
Used within the loops to swap the player between LAYER_FG, LAYER_TRANSITION and LAYER_BG. 
Along with the physics settings that prevent collisions between FG and BG this enables the player to run the full loop

int layerToSwapTo: Used to select which layer the player should transition to when it hits the trigger collider. The SerializeField, Layer tag allows you to select the Layer in the inspector
##### Possible Upgrade: 
Make the trigger able to determine which side it entered from so you can run the loop in reverse. 
This is currently done with an additional trigger positioned in a way that achieves the same goal.
### LayerAttribute & LayerAttributeEditor
These two scripts allow the developer to select a layer in LayerTrigger rather than use an integer to reduce chance of error
Neither of these are necessary and the Layer attribute can be removed from "layerToSwapTo" and then an integer used in the inspector 
### CameraController
Not Required for anything to work but it is a very basic controller that keeps the player in the centre of the frame

