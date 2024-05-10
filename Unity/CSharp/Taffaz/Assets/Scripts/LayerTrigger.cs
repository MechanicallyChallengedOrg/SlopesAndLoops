using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Collider2D))]
public class LayerTrigger : MonoBehaviour
{
    [SerializeField, Layer] int layerToSwapTo;

    private void OnTriggerEnter2D(Collider2D other)
    {
        //if it is the player entering
        if (other.CompareTag("Player"))
        {
            other.gameObject.layer = layerToSwapTo;
        }
    }
}
