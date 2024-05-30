using UnityEngine;
using UnityEngine.Events;

public class TriggerEnterEvents2D : MonoBehaviour
{
    public UnityEvent<Collider2D> OnEnter;
    public UnityEvent<Collider2D> OnExit;
    
    private void OnTriggerEnter2D(Collider2D collider)
    {
        OnEnter?.Invoke(collider);
    }

    private void OnTriggerExit2D(Collider2D collider)
    {
        OnExit?.Invoke(collider);
    }
}
