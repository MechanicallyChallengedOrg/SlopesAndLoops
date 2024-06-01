using UnityEngine;

public class Looper : MonoBehaviour
{

    [SerializeField] private Rigidbody2D _body;

    public float AngularSpeed;
    public float MaxAngularVelocity;
    public float MoveLinearDrag;
    public float MoveAngularDrag;
    public float StopLinearDrag;
    public float StopAngularDrag;

    public void Move(float direction)
    {
        direction = direction < 0 ? -1f : 1f;
        var speedBonus = AngularSpeed * -direction;
        var speed = Mathf.Clamp(_body.angularVelocity + speedBonus, -MaxAngularVelocity, MaxAngularVelocity);
        _body.angularVelocity = speed;
        _body.drag = MoveLinearDrag;
        _body.angularDrag = MoveAngularDrag;
    }

    public void Stop()
    {
        _body.drag = StopLinearDrag;
        _body.angularDrag = StopAngularDrag;
    }
}