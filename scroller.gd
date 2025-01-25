extends Node2D

var stuckCast
var upCast
var rightCast
var leftCast
var isStuck = false
var cantPortalUp = false
var cantPortalDown = false
var cantPortalLeft = false
var cantPortalRight = false
var scrolling = false
var speed = 0.0

var goingPos = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	UnlimitedRulebook.scroller = self
	await get_tree().create_timer(2).timeout
	scrolling = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isStuck:
		UnlimitedRulebook.player.position.y -= 10
	if UnlimitedRulebook.player:
		if UnlimitedRulebook.player.get_node("stuckCast"):
			stuckCast = UnlimitedRulebook.player.get_node("stuckCast")
		if UnlimitedRulebook.player.get_node("upCast"):
			upCast = UnlimitedRulebook.player.get_node("upCast")
		if UnlimitedRulebook.player.get_node("rightCast"):
			rightCast = UnlimitedRulebook.player.get_node("rightCast")
		if UnlimitedRulebook.player.get_node("leftCast"):
			leftCast = UnlimitedRulebook.player.get_node("leftCast")
	if stuckCast.is_colliding():
		cantPortalUp = true
	else:
		cantPortalUp = false
	if upCast.is_colliding():
		cantPortalDown = true
		$portalDown.monitoring = false
	else:
		cantPortalDown = false
		$portalDown.monitoring = true
	if leftCast.is_colliding():
		cantPortalRight = true
		$portalRight.monitoring = false
	else:
		cantPortalRight = false
		$portalRight.monitoring = true
	if rightCast.is_colliding():
		cantPortalLeft = true
		$portalLeft.monitoring = false
	else:
		cantPortalLeft = false
		$portalLeft.monitoring = true
	if scrolling:
		speed = lerp(speed, 72*delta, 0.01)
	position.x += speed
	

func _on_portal_right_body_entered(body):
	if body.is_in_group("player"):
		body.position.x -= 680

func _on_portal_left_body_entered(body):
	if body.is_in_group("player"):
		body.position.x += 680


func _on_portal_up_body_entered(body):
	if body.is_in_group("player"):
		if !cantPortalUp:
			body.global_position.y = 380


func _on_portal_down_body_entered(body):
	if body.is_in_group("player"):
		if !cantPortalDown:
			body.global_position.y = 0


func _on_stuck_area_body_entered(body):
	if body is TileMap:
		isStuck = true

func _on_stuck_area_body_exited(body):
	if body is TileMap:
		isStuck = false
