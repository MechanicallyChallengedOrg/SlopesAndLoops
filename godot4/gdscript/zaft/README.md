# Mechanically Challenged Slops and Loops

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
