# Mechanically Challenged Slopes and Loops

Check it on [itch.io](https://zafteer.itch.io/)

## About

A demo/showcase of implementing loop and slope movement using Godot 4, by ZAFT.

I know there is a crazy amount of writing out there explaining exactly how that works in sonic.
But I made sure to avoid reading any of it, as well as not playing any sonic games as part of this.

It was more important/fun to me to give it its own flavor/spin.

## How to Use?

I highly recommend downloading the project in this folder and running it (requires Godot 4.3-dev6+) because
some of the demo scenes actually have explanations in them. The demos are also rigged to show telemetry
on the screen as you move around, which hopefully helps understand what is happening under the hood.

The :elephant: in the room is: gdscript is not exactly friendly about importing "libraries" because of its
global namespace for classes. So my recommended way is really to steal the structure of the player scene and copy/port
the code as it makes sense to your own project.

The solution _does_ use the standard Godot `CharacterBody` node with the `move_and_slide` functionality.

The main thing I expect you'll need to change porting this over to your project are some values in the config:

```gdscript
const MAX_SLOPE_ANGLE := deg_to_rad(80)
const SNAP_LENGTH := 1.5
const MAX_SLIDES := 8
```

`MAX_SLOPE_ANGLE` is pure preference (just keep it under 90 deg): How steep is a slope/ramp? Less than this number is a slope and the character tries to slide, more than this number is a wall and the character bonks against it.

However `SNAP_LENGTH` and `MAX_SLIDES` are highly dependend on:

- How jaggedy are your slopes? How much your angle change on the slopes? (smooth/gradual? 45 degree increments?)
  The demo here uses very abrupt angle changes because I think that's the worst case scenario.
- How big is your character (specially for `SNAP_LENGTH` since that's a pixel based value)?
  I cannot really predict/determine the values you will need for this, but keep in mind these seem to work
  well for the Godot default icon in 1:1 scale (128px) in a world proportional to it.
  But generally you want `SNAP_LENGTH` to be as small as you can get away with (but probably not under 1.0),
  and it probably needs to be bigger if your character and world are bigger.

Note: all three of these values are also in the Godot's `CharacterBody` node's docs. The code in this demo just passes them straight to it with no extra processing.

## Approach

### (Personal) History

I actually implemented this whole thing _without_ using `CharacterBody` at first. Long time ago I actually did this mechanic engineless - so the concepts/problems of doing it that way are very familiar to me.

However, I found it very unsuitable for this challenge: I was having trouble to explain in words and felt like I was fighting the engine. And most importantly: the overwhelming majority of people using Godot for a platformer do indeed use the default node for movement - I had to try using it too in this case.

So I went back to the drawing board and came up with an approach that uses as much as possible (as far as my limited understanding of the engine goes) the features from the default `CharacterBody` movement node.

Turns out this has improved a lot since I last used it (around Godot 3's release) and it almost does the entire thing by itself if you just tweak a few parameters here and there!

### The incredible `CharacterBody` - an _almost_ out-of-the-box solution

The stars of the show are: `up_direction` and `apply_floor_snap`.

Just by checking the floor normal as the character moves, and adjusting the `up_direction` accordingly, it was already almost done - not even any raycast needed or any extra checks. Really impressive out of the box functionality.

However, there were edge cases depending on velocity, inclination, abrupt angle changes in the slope,  even direction (looping clockwise vs counterclockwise) that caused the player to in some cases unpredictably pop out of the loop and just fall. As much as I tried to tweak values to make it work out, I couldn't eliminate all the cases where this was happening.

### Raycasts to the rescue

In the end I've decided to just add 3 raycasts (center, left and right) going down to add an extra safety net for the cases where the player was being popped out of the loop incorrectly. The information I got from these 3 checks seemed to catch (I'm yet to find an example where it doesn't, but I'm sure it exists) all the cases where the native `snap_length` wasn't being enough.

So the logic goes: if the `CharacterBody` builtin logic does not think it `is_on_floor` anymore, I check the values on the raycasts and if they disagree, I simple call `apply_floor_snap` and give the control back to the `CharacterBody`.

### The Ugly

Because this is relying on physics, there is the possibility of running into jitter - so I added some extra guards around it (mostly things like: snap to the closest 5 degree angle of rotation - for normals, and sprite rotation angles).

Even with that, in some cases it still occurs (though it reshakes itself very quickly back to stable), and I couldn't come up with a way to fix it (that doesn't involve creating a massive state machine).

I think making a comprehensive character movement state machine that would give me more confidence about overriding the physics in some cases would be the way to go to get it truly robust/stable. However I think that would start to get deep into the weeds of other topics instead of focusing on the single mechanic proposed here. So I'm drawing the line in the sand in terms of scope and calling it good enough for this purpose.

### Getting out of Doctor GODOTnic's Jail

The most interesting question (for me at least) in this mechanic is: how do you deal with the fact that a loop is... well... a loop! A naive implementation (even if you allow for the player to get _in_ the loop somehow), would leave the player stuck looping forever.

The main two options I considered to solve this are:

- A) The loop legs **must** cross each other: you can exit the loop by not colliding with the second leg if you are attached to the first.
- B) After completing a loop, for a very short moment, you no longer collide with loops, loop legs must **not** cross each other.
- C) Basically A + B

I've decided to go with B, because I wanted completely symmetric loops.

As a secondary safety mechanism: if the player jumps and lands on the slope of a loop, there's no collision.

## Project Structure

### `/assets`

The only asset you'll ever need: the Godot logo. But seriously, I avoided adding anything else because that wasn't the focus here.

### `/autoload`

Self explanatory name, mainly contains a singleton for config (autoloaded under `__config`)

### `/scenes`

Some scenes are there for the sake of the demo, the most important ones for functionality are:

- `res://scenes/player.tscn`: the player controller setup
- `res://scenes/levels/full.tscn`: a scenic level showing how the player can enter/exit slopes/loops

Keep in mind that just the character controller is **not** enough for this, since a loop can become a prison.
You might need to enable/disable colliders at the correct time to make it so the player can "escape" the loop.
The level mentioned above shows an example of that.

### `/scripts`

Some scripts are there for the sake of the demo, the most important ones for functionality are:

- `res://scripts/player/*`: all scripts on this folder are part of the main funcionality
- `res://scripts/levels/scenic-scene.gd`: the script backing the full scene that shows a player enter/exit a loop

### `/shaders`

Just for demo purposes, nothing is done with shaders as part of the functionality.
