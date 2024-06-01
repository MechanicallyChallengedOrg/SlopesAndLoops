using UnityEngine;

public class CameraFollower : MonoBehaviour
{
    public Transform Target;
    public float t;
    public float Z;

    private void Update()
    {
        var pos = Vector3.Lerp(Target.position, transform.position, t);
        pos.z = Z;
        transform.position = pos;
    }
}