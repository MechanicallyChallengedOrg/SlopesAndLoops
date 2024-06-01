using UnityEngine;

public class RotateByGround : MonoBehaviour
{
    public GroundChecker GroundChecker;

    public Transform Target;
    public Vector3 DefaultRotation;
    public float Offset;
    public float RotationSpeed;

    private void FixedUpdate()
    {
        if(GroundChecker.IsGrounded)
        {
            Rotate(GroundChecker.GroundDirection);
        }
        else
        {
            var from = Target.rotation;
            var to = Quaternion.Euler(DefaultRotation);
            var r = Quaternion.Lerp(from, to, RotationSpeed);
            Target.rotation = r;
        }
    }

    private void Rotate(Vector2 normal)
    {
        var direction = Quaternion.Euler(0f, 0f, Offset) * normal;
        var rotation = Quaternion.FromToRotation(Vector3.right, direction);
        Target.rotation = rotation;
    }
}
