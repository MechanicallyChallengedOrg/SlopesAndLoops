using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private JumpBehaviour _jump;
    [SerializeField] private GroundChecker _groundChecker;
    [SerializeField] private Looper _looper;

    public Transform VisualBody;
    public bool FlyingRotation;

    public KeyCode Left;
    public KeyCode Right;
    public KeyCode JumpKey;

    private void Start()
    {
        if(VisualBody != default && VisualBody.parent == transform)
        {
            VisualBody.SetParent(default);
        }
    }

    private void Update()
    {
        UpdateInput();
    }

    private void FixedUpdate()
    {
        UpdateVisual();
    }

    private void UpdateInput()
    {
        TryMove();
        TryJump();
    }

    private void TryMove()
    {
        var v = 0f;
        if(Input.GetKey(Left))
        {
            v-=1;
        }

        if(Input.GetKey(Right))
        {
            v+=1;
        }

        if(v != 0f)
        {
            _looper.Move(v);
        }
        else
        {
            _looper.Stop();
        }

        if(VisualBody != default && (FlyingRotation || _groundChecker.IsGrounded))
        {
            if(v > 0)
            {
                var scale = VisualBody.localScale;
                scale.x = Mathf.Abs(scale.x);
                VisualBody.localScale = scale;
            }
            else if(v < 0)
            {
                var scale = VisualBody.localScale;
                scale.x = -Mathf.Abs(scale.x);
                VisualBody.localScale = scale;
            }
        }

    }

    private void TryJump()
    {
        if(Input.GetKey(JumpKey))
        {
            _jump.TryJump();
        }
    }

    private void UpdateVisual()
    {
        if(VisualBody != default)
        {
            VisualBody.transform.position = transform.position;
        }
    }

}
