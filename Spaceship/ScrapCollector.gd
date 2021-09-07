extends Area2D

signal scrap_collected(amount)

func _on_ScrapCollector_body_entered(body: Node2D):
	body.queue_free()
	emit_signal("scrap_collected", 1)
