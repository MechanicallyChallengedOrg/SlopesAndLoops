using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

namespace b3agz {

    public class DebugInfo : MonoBehaviour {

        [SerializeField] private Controller _connectedCharacter;
        [SerializeField] private TextMeshProUGUI _debugUI;

        private void Update() {
            
            // If we don't have a connected character, we don't need to do anything.
            if (_connectedCharacter == null) return;

            string debugText = "";
            debugText += $"Position: {_connectedCharacter.transform.position.x:F2}, {_connectedCharacter.transform.position.y:F2}\n";
            debugText += $"Speed: {_connectedCharacter.Speed.x:F2}, {_connectedCharacter.Speed.y:F2}\n";
            debugText += $"Ground Speed: {_connectedCharacter.GroundSpeed:F2}\n";
            debugText += $"Ground Angle: {(_connectedCharacter.GroundAngle * Mathf.Rad2Deg):F2} ({_connectedCharacter.GroundAngle} radians)\n";
            debugText += $"Attached to Ground: {(_connectedCharacter.Grounded ? "True" : "False")}\n";
            debugText += $"Current Mode: {_connectedCharacter.Mode}\n";
            debugText += $"Current Up: {_connectedCharacter.Up}\n";
            debugText += $"Disable Slopes: {(_connectedCharacter.DisableSlopes ? "True" : "False")}\n";
            debugText += $"Stick to Surfaces: {(_connectedCharacter.StickToSurfaces ? "True" : "False")}\n";

            _debugUI.text = debugText;

        }

    }

}
