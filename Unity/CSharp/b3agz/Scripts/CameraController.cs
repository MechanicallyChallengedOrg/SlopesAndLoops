using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour {

    [SerializeField] private Transform _player;
    [SerializeField] private float _followSpeed = 5f;

    private void LateUpdate() {
        
        Vector3 nextPosition = new Vector3 (_player.position.x, _player.position.y, transform.position.z);
        transform.position = Vector3.MoveTowards(transform.position, nextPosition, Time.deltaTime * _followSpeed);

    }

}
