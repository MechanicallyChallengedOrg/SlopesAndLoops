using UnityEngine;

public class FlipByVelocity : MonoBehaviour
{
    public Transform Target;
    public Rigidbody2D Body;
    public bool Inverse;

    private void FixedUpdate()
    {
        if(Body.velocity.x > 0)
        {
            var scale = Target.localScale;
            scale.x = Inverse ? -Mathf.Abs(scale.x) : Mathf.Abs(scale.x);
            Target.localScale = scale;
        }
        else if(Body.velocity.x < 0)
        {
            var scale = Target.localScale;
            scale.x = Inverse ? Mathf.Abs(scale.x) : -Mathf.Abs(scale.x);
            Target.localScale = scale;
        }
        
    }
}