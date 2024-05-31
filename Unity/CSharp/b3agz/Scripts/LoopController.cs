using UnityEngine;

/// <summary>
/// Handles the different states of the loop depending on the players position within that loop.
/// </summary>
public class LoopController : MonoBehaviour {

    /// <summary>
    /// The physical collider that represents the left-hand slope of the loop.
    /// </summary>
    [Tooltip("The physical collider that represents the left-hand slope of the loop.")]
    [SerializeField] private Collider2D _leftSegmentCollider;

    /// <summary>
    /// The physical collider that represents the right-hand slope of the loop.
    /// </summary>
    [Tooltip("The physical collider that represents the right-hand slope of the loop.")]
    [SerializeField] private Collider2D _rightSegmentCollider;


    /// <summary>
    /// Enables the right-hand segment collider and disables the left-hand segment collider.
    /// </summary>
    public void OnLeftTrigger() {

        _leftSegmentCollider.enabled = false;
        _rightSegmentCollider.enabled = true;

    }

    /// <summary>
    /// Enables the left-hand segment collider and disables the right-hand segment collider.
    /// </summary>
    public void OnRightTrigger() {

        _leftSegmentCollider.enabled = true;
        _rightSegmentCollider.enabled = false;

    }

    /// <summary>
    /// Flips the current left/right segment collider configuration.
    /// </summary>
    public void OnCentreTrigger() {

        _leftSegmentCollider.enabled = !_leftSegmentCollider.enabled;
        _rightSegmentCollider.enabled = !_rightSegmentCollider.enabled;

    }

}
