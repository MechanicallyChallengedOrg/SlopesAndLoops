using UnityEngine;

namespace b3agz {

    [CreateAssetMenu(fileName = "CharacterStats", menuName = "b3agz/CharacterStats")]
    public class CharacterStats : ScriptableObject {

        /// <summary>
        /// Half the total width of the character.
        /// </summary>
        [Tooltip("Half the total width of the character.")]
        [field: SerializeField] public float WidthRadius { get; private set; } = 0.2f;

        /// <summary>
        /// Half the total height of the character.
        /// </summary>
        [Tooltip("Half the total height of the character.")]
        [field: SerializeField] public float HeightRadius { get; private set; } = 0.4f;

        /// <summary>
        /// The distance beyond the ground check sensors we look for the ground. Essentially, the larger this
        /// value, the more the character will "stick" to slopes when running downhill.
        /// </summary>
        [Tooltip("The distance beyond the ground check sensors we look for the ground. Essentially, the larger this value, the more the character will \"stick\" to slopes when running downhill.")]
        [field: SerializeField] public float GroundCheckDistance { get; private set; } = 0.14f;

        /// <summary>
        /// The amount of downward force applied each frame when character is not attached to ground.
        /// </summary>
        [Tooltip("The amount of downward force applied each frame when character is not attached to ground.")]
        [field: SerializeField] public float Gravity { get; private set; } = 0.21875f;

        /// <summary>
        /// The maximum speed we allow our character to move at.
        /// </summary>
        [Tooltip("The maximum speed we allow our character to move at.")]
        [field: SerializeField] public float TopSpeed { get; private set; } = 6f;

        /// <summary>
        /// How quickly our character accelerates.
        /// </summary>
        [Tooltip("How quickly our character accelerates.")]
        [field: SerializeField] public float AccelerationSpeed { get; private set; } = 0.046875f;

        /// <summary>
        /// How much force to apply when character is moving in one direction and player presses the opposite direction.
        /// </summary>
        [Tooltip("How much force to apply when character is moving in one direction and player presses the opposite direction.")]
        [field: SerializeField] public float DecelerationSpeed { get; private set; } = 0.5f;

        /// <summary>
        /// Applied to horizontal velocity any time no horizontal input is detected.
        /// </summary>
        [Tooltip("Applied to horizontal velocity any time no horizontal input is detected.")]
        [field: SerializeField] public float FrictionSpeed { get; private set; } = 0.046875f;

        /// <summary>
        /// An overall speed modifier value, affects all movement including gravity.
        /// </summary>
        [Tooltip("An overall speed modifier value, affects all movement including gravity.")]
        [field: SerializeField] public float SpeedModifier { get; private set; } = 10f;


        [field: SerializeField] public float SlopeFactor { get; private set; } = 0.125f;

        [field: SerializeField] public float JumpForce { get; private set; } = 6.5f;

        [field: SerializeField] public float StickySpeed { get; private set; } = 0.1f;
    }
}