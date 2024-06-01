using UnityEngine;

public class LoopSwap : MonoBehaviour
{
    public Loop Loop;

    private void OnTriggerEnter2D(Collider2D collider)
    {
        Loop.Swap(collider);
    }
}
