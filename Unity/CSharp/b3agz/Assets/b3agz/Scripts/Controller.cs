using b3agz.Classes;
using System.Collections;
using System.Collections.Generic;
using UnityEditor.Experimental.GraphView;
using UnityEngine;

namespace b3agz {

    public class Controller : MonoBehaviour {

        #region Settings

        [Header("Settings")]

        [Tooltip("When checked, slopes will not affect character's momentum.")]
        public bool DisableSlopes;

        [Tooltip("When checked, player will not fall from vertical/upside down surfaces.")]
        public bool StickToSurfaces;

        [Tooltip("The CharStats ScriptableObject that defines values like the speed and gravity of this character.")]
        [SerializeField] private CharacterStats _stats;

        [Tooltip("The layer(s) that the character controller treats as ground.")]
        [SerializeField] private LayerMask _groundLayer;

        [Tooltip("The object holding this characters visual element (likely a Sprite).")]
        [SerializeField] private Transform _spriteObject;

        #endregion

        #region Under The Hood Variables

        /// <summary>
        /// The unmodified speed of the character on the ground, ignoring slopes.
        /// </summary>
        public float GroundSpeed { get; private set; } = 0f;

        /// <summary>
        /// The angle of the ground under the player's feet.
        /// </summary>
        public float GroundAngle => _rotationHandler.AngleInRads; //{ get; private set; } = 0f;

        public GroundMode Mode => _rotationHandler.Mode;

        /// <summary>
        /// If the player is currently attached to the ground.
        /// </summary>
        public bool Grounded => _attachedToGround;

        /// <summary>
        /// The horizontal and vertical speed of the character.
        /// </summary>
        public Vector2 Speed { get; private set; } = Vector2.zero;

        /// <summary>
        /// The position we intend to put the character in the next frame.
        /// </summary>
        private Vector2 _nextPosition = Vector2.zero;

        private float _frameRateMod => Time.deltaTime * _stats.SpeedModifier;
        private bool _attachedToGround = false;
        private InputDirection _inputDirection;
        private bool _jumpTrigger;

        private CharacterRotationHandler _rotationHandler = new();

        public Vector2 Position => (Vector2)transform.position;
        public Vector2 Up => _rotationHandler.GetUp();

        #endregion

        private void Update() {

            HandleInput();
            CalculateGroundSpeed();
            ApplyGravity();

            _nextPosition = Position + Speed;
            PushCheck();
            GroundCheck();
            transform.position = _nextPosition;
            UpdateSprite();
        }

        /// <summary>
        /// Calculates the current ground speed based on the player's input and the angle of the ground
        /// under foot.
        /// </summary>
        private void CalculateGroundSpeed() {

            Vector2 speed = Speed;

            // If disable slopes is checked, don't apply additional forces to make the player slide back
            // down slopes.
            if (!DisableSlopes) {
                GroundSpeed -= _stats.SlopeFactor * Mathf.Sin(GroundAngle);
            }

            // Player is trying to move right.
            if (_inputDirection == InputDirection.Left) {

                // If adjust speed based on the direction we're trying to go relative to our current momentum.
                if (GroundSpeed > 0) {
                    GroundSpeed -= _stats.DecelerationSpeed;
                } else if (GroundSpeed > -_stats.TopSpeed) {
                    GroundSpeed -= _stats.AccelerationSpeed;
                    if (GroundSpeed <= -_stats.TopSpeed) {
                        GroundSpeed = -_stats.TopSpeed;
                    }
                }

            // Repeat for opposite direciton.
            } else if (_inputDirection == InputDirection.Right) {

                if (GroundSpeed < 0) {

                    GroundSpeed += _stats.DecelerationSpeed;
                    if (GroundSpeed >= 0) {
                        GroundSpeed = 0.005f;
                    }

                } else if (GroundSpeed < _stats.TopSpeed) {
                    GroundSpeed += _stats.AccelerationSpeed;
                    if (GroundSpeed >= _stats.TopSpeed) {
                        GroundSpeed = _stats.TopSpeed;
                    }
                }

            // Else player is not attempting to move, shift GroundSpeed towards zero at a rate according to
            // frictionSpeed.
            } else {
                GroundSpeed = Mathf.MoveTowards(GroundSpeed, 0, _stats.FrictionSpeed);
            }

            // If we are not in floor mode and speed falls to within the specified range, switch floor mode.
            // This section is ignored if the StickToSurfaces flag is checked.
            if (!StickToSurfaces && Mode == GroundMode.Ceiling && (GroundSpeed > -_stats.StickySpeed && GroundSpeed < _stats.StickySpeed)) {
                GroundSpeed = 0;
                _attachedToGround = false;
                _rotationHandler.UpdateAngle(Vector2.up);
            }

            speed.x = GroundSpeed * Mathf.Cos(GroundAngle) * _frameRateMod;
            speed.y = GroundSpeed * Mathf.Sin(GroundAngle) * _frameRateMod;

            Speed = speed;

        }

        /// <summary>
        /// Applies gravity if character is not currently attached to the ground.
        /// </summary>
        private void ApplyGravity() {

            if (_attachedToGround) return;

            Vector2 speed = Speed;
            speed.y -= _stats.Gravity * _frameRateMod;
            Speed = speed;
            
        }

        /// <summary>
        /// Sets _inputDirection based on the player inputs defined in this function.
        /// </summary>
        private void HandleInput() {
            if (Input.GetKey(KeyCode.A)) {
                _inputDirection = InputDirection.Left;
            } else if (Input.GetKey(KeyCode.D)) {
                _inputDirection = InputDirection.Right;
            } else {
                _inputDirection = InputDirection.None;
            }
        }

        private void GroundCheck() {

            // Cast our rays.
            RaycastHit2D A = LeftDown.Cast(_groundLayer);
            RaycastHit2D B = RightDown.Cast(_groundLayer);

            // Create a placeholder Normal and next Position. By default we are upright and at the position
            // our feet would be in if we are not obstructed by solid objects. We also assume we are grounded
            // until decided otherwise.
            Vector3 groundNormal = Vector3.MoveTowards(transform.up, Vector3.up, Time.deltaTime * 15f); // Vector3.up;
            Vector3 groundPosition = _nextPosition - (_rotationHandler.GetUp() * _stats.HeightRadius);

            // If both raycasts hit a collider...
            if (B.collider != null && A.collider != null) {

                // Set ground position to the shortest of the two casts, defaulting to left (A) if lengths are equal.
                groundPosition = A.distance <= B.distance ? A.point : B.point;

                // Calculate average normal between the two casts to ensure a smooth transition between angles.
                groundNormal = (A.normal + B.normal) / 2f;
                _attachedToGround = true;

                // Else if only one of the colliders hits something.
            } else if (A.collider != null || B.collider != null) {

                // Check which cast hit something and set the groundPosition and groundNormal to that raycast.
                groundPosition = A.collider != null ? A.point : B.point;
                groundNormal = A.collider != null ? A.normal : B.normal;
                _attachedToGround = true;

            // Else if we didn't detect any ground, we're no longer attached to the ground.
            } else {
                _attachedToGround = false;
            }

            // Update all the values.
            _rotationHandler.UpdateAngle(groundNormal);

            // Set the character's up based on the current mode.
            transform.up = _rotationHandler.GetUp();

            // Modify the nextPosition based on the colliders we detected.
            _nextPosition = _rotationHandler.ModifyGroundPosition(_nextPosition, groundPosition, _stats.HeightRadius);

        }

        /// <summary>
        /// Checks to see if the there is a solid object in the direction we are trying to move. If there is a
        /// solid object in the path of the character but *below* the raycast checks, the character will step
        /// up onto that surface.
        /// </summary>
        private void PushCheck() {

            if (Speed.x > 0f) {
                RaycastHit2D hit = RightPush.Cast();
                if (hit.collider != null) {

                    if (hit.transform.CompareTag("Loop Switch")) {
                        if (hit.collider.gameObject.TryGetComponent<LoopTrigger>(out var trigger)) {
                            trigger.Trigger();
                        } else {
                            Debug.LogWarning("Encountered a loop trigger with no LoopTrigger component attached.");
                        }


                    } else if (hit.collider.gameObject.layer == 6) {
                        _nextPosition = _rotationHandler.ModifyRightPosition(_nextPosition, hit.point, _stats.WidthRadius);
                        GroundSpeed = 0;
                    }
                }
            }

            if (Speed.x < 0f) {
                RaycastHit2D hit = LeftPush.Cast();
                if (hit.collider != null) {
                    if (hit.transform.CompareTag("Loop Switch")) {

                        if (hit.collider.gameObject.TryGetComponent<LoopTrigger>(out var trigger)) {
                            trigger.Trigger();
                        } else {
                            Debug.LogWarning("Encountered a loop trigger with no LoopTrigger component attached.");
                        }

                    } else if (hit.collider.gameObject.layer == 6) {
                        _nextPosition = _rotationHandler.ModifyLeftPosition(_nextPosition, hit.point, _stats.WidthRadius);
                        GroundSpeed = 0;
                    }
                }
            }
        }

        /// <summary>
        /// Updates the characters visual object (if attached) to match the rotation of the current ground angle.
        /// </summary>
        private void UpdateSprite() {

            // If no object is stored, return.
            if (_spriteObject == null) return;
            _spriteObject.rotation = Quaternion.Euler(0f, 0f, _rotationHandler.AngleInDegs);

        }

        #region Sensor Rays

        private SensorRay LeftDown => new(
            _nextPosition - (Vector2)transform.right * (_stats.WidthRadius - 0.05f),
            _nextPosition - ((Vector2)transform.right * (_stats.WidthRadius - 0.05f)) - (_rotationHandler.GetUp() * (_stats.HeightRadius + _stats.GroundCheckDistance)),
            Color.green
            );

        private SensorRay RightDown => new(
            _nextPosition + (Vector2)transform.right * (_stats.WidthRadius - 0.05f),
            _nextPosition + ((Vector2)transform.right * (_stats.WidthRadius - 0.05f)) - (_rotationHandler.GetUp() * (_stats.HeightRadius + _stats.GroundCheckDistance)),
            Color.cyan
            );

        private SensorRay LeftUp => new(
            _nextPosition - (Vector2)transform.right * _stats.WidthRadius,
            _nextPosition - ((Vector2)transform.right * _stats.WidthRadius) + (_rotationHandler.GetUp() * _stats.HeightRadius),
            Color.blue
            );

        private SensorRay RightUp => new(
            _nextPosition - (Vector2)transform.right * _stats.WidthRadius,
            _nextPosition + ((Vector2)transform.right * _stats.WidthRadius) + (_rotationHandler.GetUp() * _stats.HeightRadius),
            Color.yellow
            );

        private SensorRay LeftPush => new(
            _nextPosition,
            _nextPosition - (Vector2)transform.right * _stats.WidthRadius,
            Color.magenta);

        private SensorRay RightPush => new(
            _nextPosition,
            _nextPosition + (Vector2)transform.right * _stats.WidthRadius,
            Color.red
            );

        #endregion


    }

}
