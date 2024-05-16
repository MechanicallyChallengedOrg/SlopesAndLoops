extends Node

func main() -> MainScene: return get_node("/root/Main")
func background() -> CanvasLayer: return get_node("/root/Main/Background")
func level() -> CanvasLayer: return get_node("/root/Main/Level")
func pickups() -> CanvasLayer: return get_node("/root/Main/Pickups")
func hud() -> CanvasLayer: return get_node("/root/Main/HUD")
func menu() -> CanvasLayer: return get_node("/root/Main/Menu")
func debug() -> CanvasLayer: return get_node("/root/Main/Debug")
func world() -> WorldEnvironment: return get_node("/root/Main/WorldEnvironment")
