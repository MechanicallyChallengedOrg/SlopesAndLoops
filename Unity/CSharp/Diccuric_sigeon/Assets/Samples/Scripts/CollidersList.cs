using UnityEngine;

public class CollidersList : MonoBehaviour
{
    public Collider2D[] Colliders;

    public void Ignore(Collider2D collider)
    {
        foreach(var c in Colliders)
        {
            //c.gameObject.SetActive(false);
            Physics2D.IgnoreCollision(collider, c, true);
        }
    }

    public void Unignore(Collider2D collider)
    {
        foreach(var c in Colliders)
        {
           // c.gameObject.SetActive(true);
            Physics2D.IgnoreCollision(collider, c, false);
        }
    }
}