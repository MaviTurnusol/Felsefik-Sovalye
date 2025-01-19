extends Area2D

@export var health_comp : Node2D
var father

func damage(attack, attacker):
	set_deferred("monitorable", false)
	if father.has_method("knockback"):
		father.knockback(attacker)
	if health_comp:
		health_comp.damage(attack)
		var damageNum = load("res://damage_number.tscn").instantiate()
		damageNum.global_position = Vector2(global_position.x, global_position.y - 80)
		damageNum.number = attack
		get_tree().root.add_child(damageNum)
		if father:
			if father.material.shader == load("res://Chars/darktar/hitflash.tres"):
				father.material.set_shader_parameter("enabled", true)
				await get_tree().create_timer(0.1).timeout
				father.material.set_shader_parameter("enabled", false)
	if father == UnlimitedRulebook.player:
		await get_tree().create_timer(0.25).timeout
	else:
		await get_tree().create_timer(0.1).timeout
	monitorable = true
