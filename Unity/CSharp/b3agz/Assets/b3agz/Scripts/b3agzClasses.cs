using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace b3agz {

    namespace Classes {

        public class CharacterRotationHandler {

            /// <summary>
            /// The current Mode the character is in (Floor, RightWall, Ceiling, LeftWall).
            /// </summary>
            public GroundMode Mode { get; private set; }

            /// <summary>
            /// The current ground angle in radians.
            /// </summary>
            public float AngleInRads { get; private set; }

            /// <summary>
            /// The current angle in degrees (derived from AngleInRads).
            /// </summary>
            public float AngleInDegs => AngleInRads * Mathf.Rad2Deg;

            /// <summary>
            /// Updates the current angle based on the normal of the ground under the player.
            /// </summary>
            /// <param name="groundNormal">Vector2 representing ground normal underfoot.</param>
            public void UpdateAngle(Vector2 groundNormal) {

                // Get angle in radians from the normal passed in.
                float angleRad = Mathf.Atan2(-groundNormal.x, groundNormal.y);

                // If angle is less than zero, wrap it around.
                if (angleRad < 0) {
                    angleRad += 2 * Mathf.PI;
                }

                // Save the angle.
                AngleInRads = angleRad;

                // Update the current mode based on the new angle.
                UpdateMode();

            }

            /// <summary>
            /// Updates the current Mode based on the angle stored.
            /// </summary>
            public void UpdateMode() {

                if (AngleInRads > 0.785398f && AngleInRads <= 2.33874f) {
                    Mode = GroundMode.RightWall;
                } else if (AngleInRads > 2.33874f && AngleInRads <= 3.92699f) {
                    Mode = GroundMode.Ceiling;
                } else if (AngleInRads > 3.92699f && AngleInRads <= 5.48033f) {
                    Mode = GroundMode.LeftWall;
                } else {
                    Mode = GroundMode.Floor;
                }

            }

            /// <summary>
            /// Returns the "Up" vector based on the current Mode the character is in.
            /// </summary>
            /// <returns>Vector2 representing local up</returns>
            public Vector2 GetUp() {

                switch (Mode) {
                    case GroundMode.RightWall:
                        return Vector2.left;
                    case GroundMode.Ceiling:
                        return Vector2.down;
                    case GroundMode.LeftWall:
                        return Vector2.right;
                    case GroundMode.Floor:
                        return Vector2.up;
                    default:
                        throw new Exception($"{Mode} is not implemented or is invalid");
                }

            }

            /// <summary>
            /// Modifies a position Vector2 by by the amount specified using Mode determine which value to modify.
            /// </summary>
            /// <param name="position">The "next" position of the character</param>
            /// <param name="point">The point at which we are basing our modification on.</param>
            /// <param name="amount">The amount we are modifying by.</param>
            /// <returns>The modified Vector2</returns>
            public Vector2 ModifyGroundPosition (Vector2 position, Vector2 point, float amount) {

                switch (Mode) {
                    case GroundMode.RightWall:
                        return new Vector2(point.x - amount, position.y);
                    case GroundMode.Ceiling:
                        return new Vector2(position.x, point.y - amount);
                    case GroundMode.LeftWall:
                        return new Vector2(point.x + amount, position.y);
                    case GroundMode.Floor:
                        return new Vector2(position.x, point.y + amount);
                    default:
                        throw new Exception($"{Mode} is not implemented or is invalid");
                }

            }

            public Vector2 ModifyRightPosition(Vector2 position, Vector2 point, float amount) {

                switch (Mode) {
                    case GroundMode.RightWall:
                        return new Vector2(position.x, point.y + amount);
                    case GroundMode.Ceiling:
                        return new Vector2(point.x + amount, position.y);
                    case GroundMode.LeftWall:
                        return new Vector2(position.x, point.y - amount);
                    case GroundMode.Floor:
                        return new Vector2(point.x - amount, point.y);
                    default:
                        throw new Exception($"{Mode} is not implemented or is invalid");
                        
                }

            }

            public Vector2 ModifyLeftPosition(Vector2 position, Vector2 point, float amount) {

                switch (Mode) {
                    case GroundMode.RightWall:
                        return new Vector2(position.x, point.y - amount);
                    case GroundMode.Ceiling:
                        return new Vector2(point.x - amount, position.y);
                    case GroundMode.LeftWall:
                        return new Vector2(position.x, point.y + amount);
                    case GroundMode.Floor:
                        return new Vector2(point.x + amount, point.y);
                    default:
                        throw new Exception($"{Mode} is not implemented or is invalid");

                }

            }

        }

        /// <summary>
        /// Denotes which "mode" we are in, which in turn determines the orientation of the character controller.
        /// </summary>
        public enum GroundMode {

            Floor,
            RightWall,
            Ceiling,
            LeftWall

        }

        /// <summary>
        /// Denotes the direction the player is trying to move in.
        /// </summary>
        public enum InputDirection {

            None,
            Left,
            Right,

        }

    }

}