using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEditor.Progress;

[RequireComponent(typeof(Rigidbody2D))]
public class PlayerController : MonoBehaviour
{

    [SerializeField] float gravity = 100f;
    [SerializeField] float maxSpeed = 25f;
    [SerializeField] float maxAngleChange = 0.2f;
    [SerializeField] float baseAcceleration = 50f;
    [SerializeField] float airSpeedMultiplier = 0.5f;
    [SerializeField] float groundAirTransition = 0.25f;

    Vector2 moveDirection;
    float angle;
    Rigidbody2D rb;
    bool isGrounded;
    Vector2 gravityNormal = Vector2.up;
    float groundedTimer = 0f;

    private void Awake()
    {
        rb = GetComponent<Rigidbody2D>();
        moveDirection = Vector2.zero;
    }

    void Update()
    {
        HandleInput();

        HandleGrounded();
    }

    // Gives a short delay before the player rotation is reset and gravity is changed to down 
    private void HandleGrounded()
    {
        if (!isGrounded)
            groundedTimer += Time.deltaTime;

        if (groundedTimer > groundAirTransition)
        {
            angle = 0f;
            gravityNormal = Vector2.up;
            groundedTimer = 0f;
        }
    }

    private void FixedUpdate()
    {
        AdjustSpeed();
        ApplyGravity();
        AdjustRotation();
    }

    void HandleInput()
    {
        moveDirection = Vector2.zero;
        if (Input.GetKey(KeyCode.RightArrow) || Input.GetKey(KeyCode.A))
        {
            moveDirection.x += 1;
        }
        if (Input.GetKey(KeyCode.LeftArrow) || Input.GetKey(KeyCode.D))
        {
            moveDirection.x -= 1;
        }
    }

    void AdjustRotation()
    {
        rb.SetRotation(Mathf.LerpAngle(rb.rotation, angle, maxAngleChange));
    }

    void AdjustSpeed()
    {

        //Reduce effectiveness of air movement
        float speedMultiplier = !isGrounded ? airSpeedMultiplier : 1f;

        // Add base speed force and limit velocity to max
        rb.AddForce(rb.transform.right * moveDirection.x * baseAcceleration * speedMultiplier, ForceMode2D.Force);

        if(rb.velocity.magnitude > maxSpeed)
        {
            rb.velocity = rb.velocity.normalized * maxSpeed;
        }
    }

    void ApplyGravity()
    {
        // Check if player is upside down and not moving fast enough to stick to the loop
        if(Mathf.Abs(Vector2.Dot(Vector2.down, gravityNormal)) > 0f && rb.velocity.magnitude < 10f)
        {
            gravityNormal = Vector2.up;
        }

        rb.AddForce(-gravityNormal * gravity);
    }

    private Vector2 CalculateGravityNormal(ContactPoint2D[] contacts)
    {
        Vector2 gravityNormal = Vector2.zero;

        // Not required as most of the time there is only one contact
        // However in some situations there can be multiple so this just takes an average
        foreach (var contact in contacts)
        {
            gravityNormal += contact.normal;
        }

        gravityNormal = gravityNormal / contacts.Length;

        return gravityNormal;
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.transform.CompareTag("Terrain"))
        {
            gravityNormal = CalculateGravityNormal(collision.contacts);
            angle = Vector2.SignedAngle(Vector2.up, gravityNormal);
            isGrounded = true;
            groundedTimer = 0f;
        }

    }

    private void OnCollisionStay2D(Collision2D collision)
    {
        if (collision.transform.CompareTag("Terrain"))
        {
            gravityNormal = CalculateGravityNormal(collision.contacts);
            angle = Vector2.SignedAngle(Vector2.up, gravityNormal);
            isGrounded = true;
        }
    }

    private void OnCollisionExit2D(Collision2D collision)
    {
        if (collision.transform.CompareTag("Terrain"))
        {
            isGrounded = false;
        }
    }

    // Used for debugging purposes - not required but left in as it may prove useful to anyone trying to implement

    private void OnGUI()
    {
        GUILayout.BeginHorizontal();
        GUI.backgroundColor = Color.white;
        GUI.Label(new Rect(0, 0, 500, 40), $"IsGrounded: {isGrounded}");
        GUI.Label(new Rect(0, 10, 500, 40), $"Grounded Timer: {groundedTimer}");
        GUI.Label(new Rect(0, 20, 500, 40), $"Player Speed: {rb.velocity.magnitude}");
        GUI.Label(new Rect(0, 30, 500, 40), $"RB Up: {rb.GetRelativeVector(Vector2.up)}");
        GUI.Label(new Rect(0, 40, 500, 40), $"Facing: {Vector2.Perpendicular(gravityNormal)}");
        GUILayout.EndHorizontal();
    }

}