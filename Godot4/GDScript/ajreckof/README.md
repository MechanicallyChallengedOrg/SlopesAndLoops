# Slope Body 2D

This is my take on the mechanically challenged of May 2024.

## Installation
To install this plugin in your project, simply drop the `addons` folder into your project directory. Then, go to your project settings and activate the plugin.

## Getting Started
To try out the plugin, a sample project is included in this folder. It contains examples of a player, obstacles, and a level. Alternatively, you can continue reading this document, which highlights the key concepts necessary to understand the plugin.

## Slope Body 2D
This is the core class of the plugin, handling the movement and gravity of a player-controlled body. The class exposes various properties to fine-tune the movement to your needs. For more details, please refer to the class documentation.

**Note:** Currently, multiple instances of `SlopeBody2D` are not supported.

## Layering
To enable obstacles that intersect (such as loops), the concept of layers is introduced. Both bodies and obstacles can only exist on one layer at a time and can interact only with elements on the same layer. Additionally, layers change the z-index to keep intersections visually consistent.

## Layer Transition
To transition a `SlopeBody2D` from one layer to another, a `TransitionArea` class has been introduced. This class defines an area of transition, a direction, an entry layer, and an exit layer. Entering or leaving the area updates the layer based on the direction of the `SlopeBody2D` relative to the transition direction.

## Obstacles
For easy prototyping, obstacles can be created with a `Curve2D` and a specified thickness, handling visual collisions and layering as described above. Since the layer implementation relies on physical layers, you can create obstacles as simple static bodies and set up the physical layer yourself.

## Movement Modification
You can add more functionality to the movement by extending `SlopeBody2D` and defining a `_validate_velocity` function. This allows you to implement features such as jumping or sprinting. An example of this extension, including a jump feature, is provided in the `addons/examples` folder.

## Contribution
If you wish to contribute, feel free to submit pull requests or issues to the main repository. Any suggestions or help are highly welcomed.
