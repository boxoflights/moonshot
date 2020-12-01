extends Node2D

var default_settings = {
	"master": 0.75,
	"music": 0.9,
	"sfx": 1.0,
}

var config

func _ready():
	config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK || err == 7:
		# Store a variable if and only if it hasn't been defined yet
		for name in default_settings.keys():
			if not config.has_section_key("settings", name):
				config.set_value("settings", name, default_settings[name])
		save_settings()

func get_setting(name):
	return config.get_value("settings", name)
	
func set_setting(name,value,autosave = false):
	config.set_value("settings", name, value)
	if(autosave):
		save_settings()
	
func save_settings():
	config.save("user://settings.cfg")
	

