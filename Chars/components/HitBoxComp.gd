extends Area2D

@export var health_comp : Node2D
var father
var active = true

func damage(attack, attacker):
	if !active:
		return
	set_deferred("monitorable", false)
	if father.is_in_group("monster"):
		UnlimitedRulebook.frameFreeze(0.05, 0.5)
	if father.has_method("knockback"):
		father.knockback(attacker)
	if health_comp:
		var realDamage = clamp(attack, attack, health_comp.health)
		if UnlimitedRulebook.player:
			if attacker.father == UnlimitedRulebook.player:
				if attacker.father.form == 1:
					if father.state != father.States.DEAD:
						attacker.father.get_node("HealthComp").health += realDamage/10
		if health_comp.health > 0:
			var damageNum = load("res://damage_number.tscn").instantiate()
			damageNum.global_position = Vector2(global_position.x, global_position.y - 80)
			damageNum.number = attack
			get_tree().root.add_child(damageNum)
		health_comp.damage(attack)
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
