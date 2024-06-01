using UnityEngine;
using UnityEngine.UIElements;

namespace b3agz {

    /// <summary>
    /// Stores sensor raycast information in a way that makes it more convenient to use.
    /// </summary>
    public class SensorRay {

        /// <summary>
        /// The start point of this SensorRay.
        /// </summary>
        public Vector2 Start { get; set; }

        /// <summary>
        /// The end point of this SensorRay.
        /// </summary>
        public Vector2 End { get; set; }

        /// <summary>
        /// The distance between the start and end point of this SensorRay.
        /// </summary>
        public float Length { get; set; }


        /// <summary>
        /// The direction that this SensorRay is travelling.
        /// </summary>
        public Vector2 Direction { get; }

        /// <summary>
        /// The colour of this when drawn as a debug line in the editor.
        /// </summary>
        public Color Colour { get; set; } = Color.red;

        /// <summary>
        /// Creates a new SensorRay with the given start and end points.
        /// </summary>
        /// <param name="start">The starting position of the ray.</param>
        /// <param name="end">The end position of the ray.</param>
        public SensorRay(Vector2 start, Vector2 end) {

            Start = start;
            End = end;
            Length = Vector3.Distance(start, end);
            Direction = (End - Start).normalized;

        }

        /// <summary>
        /// Creates a new SensorRay with the given start and end points and assigns a colour for the gizmo lines.
        /// </summary>
        /// <param name="start">The starting position of the ray.</param>
        /// <param name="end">The end position of the ray.</param>
        /// <param name="colour">The colour to draw the gizmo lines as.</param>
        public SensorRay(Vector2 start, Vector2 end, Color colour) {

            Start = start;
            End = end;
            Length = Vector3.Distance(start, end);
            Direction = (End - Start).normalized;
            Colour = colour;

        }

        public RaycastHit2D Cast() {
            RaycastHit2D hit = Physics2D.Raycast(Start, Direction, Length);
            DebugLine();
            return hit;
        }

        public RaycastHit2D Cast (LayerMask groundLayer) {
            RaycastHit2D hit = Physics2D.Raycast(Start, Direction, Length, groundLayer);
            DebugLine();
            return hit;
        }

        /// <summary>
        /// Draws a debug line in the editor showing the path of this SensorRay.
        /// </summary>
        public void DebugLine() {
#if UNITY_EDITOR
            Debug.DrawLine(Start, End, Colour);
#endif
        }

    }
}