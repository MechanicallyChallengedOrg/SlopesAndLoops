using UnityEngine;
using UnityEngine.Events;
using System.Collections;

namespace b3agz {

    /// <summary>
    /// An interface (not that kind of interface) component to link a component to another component.
    /// The Trigger() function of this script is called and any events set inside the inspector will
    /// be invoked as a result.
    /// </summary>
    public class LoopTrigger : MonoBehaviour {

        /// <summary>
        /// Stores the event to be invoked when this trigger is... uh... triggered.
        /// </summary>
        [Tooltip("Stores the events to be invoked when this trigger is... uh... triggered.")]
        [SerializeField] private UnityEvent _event;

        /// <summary>
        /// Invokes the event stored in _event.
        /// </summary>
        public void Trigger() {

            if (_loopCheckCooldown) return;
            _event.Invoke();
            StartCoroutine(StartLoopCheckCooldown());

        }

        private bool _loopCheckCooldown = false;
        private IEnumerator StartLoopCheckCooldown() {
            _loopCheckCooldown = true;
            yield return new WaitForSeconds(1f);
            _loopCheckCooldown = false;
        }
    }
}
