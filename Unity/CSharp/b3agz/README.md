# Mechanically Challenged Slopes and Loops

## Overview
This project was an exercise in biting off more than you can chew. But there is (I hope) the foundations of a working slopes and loops character controller. The controller handles slopes and loops, including sliding back down slopes when the player does not have enough momentum. That's pretty much all, however. No jump or additional game mechanics.

The system used is based on the way the original Sonic the Hedgehog games worked, which is explained in great detail over at [Sonic Retro](https://info.sonicretro.org/SPG:Basics).

Special thanks to GTExperience, Zaftnotameni, and db9Dreamer who were constant companions in stream chat and full of helpful observations and advice while I attempted this challenge.

## How to Play

A/D to move left and right. Thassit.

## How to Use

You should be able to drop the files within the "b3agz" folder of this repo into your project, open the demo scene, and test it out. No special setting up of the project or adding of external dependencies should be necessary.

The character controller treats any colliders (including trigger colliders) on the layer that is assigned as the ground layer in the controller script as... well... ground. It also does not use colliders itself. In theory you should be able to put this on any GameObject, drag in a CharacterStats ScriptableObject (one is included in the project) and set the ground layer and you're good to go.

### Character Stats

The details of how the character moves are determined by the CharacterStats ScriptableObject put in the _stats field of the controller. Each field has a tooltip explaining what it does.

### Debug Tools

There are two bools in the character controller, `DisableSlopes` and `StickToSurfaces`. When `DisableSlopes` is set to true, the character's momentum is not affected by slopes, meaning it will carry speed the same regardless of the angle of terrain underfoot. When `StickToSurfaces` is set to true, the character will stick to the surface they are running on regardless of how fast they are going.

There is also a script called `DebugInfo`. Putting this in the scene and giving it a reference to the character controller and a TextMeshProUGUI element will print some live debug information, such as speed, ground angle, etc.

## Loops

There is a loop set up in the demo which shows how the loop should be arranged. Essentially, the loop is made of a number of components:

* The Top: Can be one solid piece, multiple sprites, tiles, etc. This part does not change.
* The Left Segment: Enabled or disabled as needed.
* The Right Segment: Enabled or disabled as needed.
* Left/Right Triggers: Colliders that cover the left/right entrances to the loop.
* Centre Trigger: Collider in the upper centre part of the loop.

The trigger colliders must have `LoopTrigger.cs` on them and be tagged as "LoopSwitch". The left and right colliders must cover the sides of the loop in such as a way that the player cannot enter the loop without passing through them.

Once the triggers are in place, put `LoopController.cs` on the loop parent and drag it into the `_event` field of each of the trigger colliders. Scroll the functions in LoopController and set them accordingly (Left Trigger = OnLeftTrigger(), etc.). Finally, drag the left and right segment colliders (not the trigger colliders) into the appropriate fields on the LoopController.

### How Loops Work

When the player passes through a trigger collider, it disables the corresponding collider. The left trigger disables the left segment, the right trigger disables the right segment. This ensures that the player can enter the loop regardless of which way they approach.

Once the player makes it to the top of the loop, the centre trigger reverses the segment collider activation. If the right segment is currently active, it becomes inactive and the left segment becomes active. This ensures the side of the loop that the player is now running down is solid, while the side they want to exit through is not.

## Problems

As mentioned above, I bit off more than I could chew with this one. The character controller works for the most part, but it is far from perfect and missing a lot of character controller basics. I believe it meets the bare minimum requirements for the Mechanically Challenged...uh... challenge.