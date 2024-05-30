using UnityEngine;

public class GroundChecker : MonoBehaviour
{
    public LayerMask GroundLayers;
    private Collider2D Ground;

    public Vector3 GroundDirection;

    public bool IsGrounded{get; set; }

    private void OnCollisionStay2D(Collision2D collision)
    {
        var groundLayer = collision.collider.gameObject.layer;
        
        if((GroundLayers & (1 << groundLayer)) != 0  && collision.transform != transform)
        {
            Ground = collision.collider;
            GroundDirection = -collision.contacts[0].normal;
            IsGrounded = true;
        }
    }

    private void OnCollisionExit2D(Collision2D collision)
    {
        if(collision.collider == Ground)
        {
            Ground = default;
            IsGrounded = false;
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawLine(transform.position, transform.position + GroundDirection * 2f);
    }
}