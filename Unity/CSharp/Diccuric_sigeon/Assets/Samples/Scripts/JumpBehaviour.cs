using UnityEngine;

public class JumpBehaviour : MonoBehaviour
{
    [SerializeField] private Rigidbody2D _body;
    [SerializeField] private GroundChecker _groundChecker;
    public float JumpForce;
    public float JumpColdown;
    private float _lastJumpTime = float.MinValue;

    public void TryJump()
    {
        if(_groundChecker.IsGrounded && Time.time - JumpColdown > _lastJumpTime)
        {
            Jump();
        }
    }

    private void Jump()
    {
        _body.AddForce(-_groundChecker.GroundDirection * JumpForce);
        _lastJumpTime = Time.time;
    }
}