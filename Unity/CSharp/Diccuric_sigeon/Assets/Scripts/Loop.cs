using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Loop : MonoBehaviour
{
    public UnityEvent<Collider2D> EnterEvent;
    public UnityEvent<Collider2D> ExitEvent;
    public UnityEvent<Collider2D> Swapped;

    public Collider2D[] Parts;
    
    public List<LoopState> InLoop;

    public Collider2D LeftEnter;
    public Collider2D RightEnter;

    private void OnTriggerEnter2D(Collider2D collider)
    {
        var direction = collider.transform.position.x < transform.position.x ? LoopDirection.Left : LoopDirection.Right;
        Enter(collider, direction);
    }

    private void OnTriggerExit2D(Collider2D collider)
    {
        FullExit(collider);   
    }

    private void FullExit(Collider2D collider)
    {
        for(var i = 0; i < InLoop.Count; i++)
        {
            if(InLoop[i].Collider == collider)
            {
                InLoop.RemoveAt(i);
                Unignore(collider, this);
                break;
            }
        }

        ExitEvent.Invoke(collider);
    }

    public void Swap(Collider2D collider)
    {
        for(var i = 0; i < InLoop.Count; i++)
        {
            if(InLoop[i].Collider == collider)
            {
                var state = InLoop[i];
                Ignore(collider, state.Direction);
                state.Direction = state.Direction == LoopDirection.Left ? LoopDirection.Right : LoopDirection.Left;
                InLoop[i] = state;
                Swapped?.Invoke(collider);
                return;
            }
        }
    }

    public void Enter(Collider2D collider, LoopDirection direction)
    {
        foreach(var inLoop in InLoop)
        {
            if(inLoop.Collider == collider)
            {
                return;
            }
        }

        var state = new LoopState()
        {
            Collider = collider,
            Direction = direction,
        };

        InLoop.Add(state);

        if(direction == LoopDirection.Left)
        {
            Physics2D.IgnoreCollision(collider, LeftEnter, true);
        }
        else
        {
            Physics2D.IgnoreCollision(collider, RightEnter, true);
        }

        EnterEvent.Invoke(collider);
    }
    
    private void Ignore(Collider2D collider, LoopDirection direction)
    {
        if(direction == LoopDirection.Left)
        {
            Physics2D.IgnoreCollision(collider, LeftEnter, false);
            Physics2D.IgnoreCollision(collider, RightEnter, true);
        }
        else
        {
            if(direction == LoopDirection.Right)
            {
                Physics2D.IgnoreCollision(collider, LeftEnter, true);
                Physics2D.IgnoreCollision(collider, RightEnter, false);
            }
        }
    }

    private void Unignore(Collider2D collider, Loop loop)
    {
        foreach(var part in loop.Parts)
        {
            Physics2D.IgnoreCollision(collider, part, false);
        }
    }

    public void IgnoreLoop(Collider2D collider)
    {
        foreach(var part in Parts)
        {
            Physics2D.IgnoreCollision(collider, part, true);
        }
    }

    public void UnignoreLoop(Collider2D collider)
    {
        foreach(var part in Parts)
        {
            Physics2D.IgnoreCollision(collider, part, false);
        }
    }

    [System.Serializable]
    public struct LoopState
    {
        public Collider2D Collider;
        public LoopDirection Direction;
    }
}
