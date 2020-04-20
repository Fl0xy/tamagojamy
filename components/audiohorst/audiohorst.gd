extends Node

var sounds_start = []
var sounds_noise = []
var sounds_end = []

var audio_index = -1

func _ready():
	init_sounds()
	call_deferred("init_minigame") 

###################### init shit ####################
func init_minigame():
	owner.get_node("minigame").connect("game_finished", self, "playsound_end")
	owner.get_node("minigame").connect("game_show", self, "playsound_start")
	
func init_sounds():
	find_sounds_start()
	find_sounds_noise()
	find_sounds_end()

############### play shit #####################
func playsound_start():
	if sounds_start.size() > 0:
		audio_index = randi()%(sounds_start.size())
		if !sounds_start[audio_index].is_connected("finished", self, "playsound_start_noise"):
			sounds_start[audio_index].connect("finished", self, "playsound_noise_start")
		sounds_start[audio_index].play()

func playsound_noise_start():
	sounds_noise[audio_index].play()
	
func playsound_noise_stop():
	if sounds_noise.size() > 0 && audio_index >= 0:
		sounds_noise[audio_index].stop()

func playsound_end(yes):
	if yes:
		########### won ###########
		if audio_index < 0:
			sounds_end[randi()%(sounds_end.size())].play()
		else:
			playsound_noise_stop()
			sounds_end[audio_index].play()
			audio_index -1
	else:
		########### lost ###########
		playsound_noise_stop()
		audio_index -1


############### finder shit ###############
func find_sounds_start():
	for i in range(5):
		if has_node("sound" + String(i) + "s"):
			sounds_start.append(get_node("sound" + String(i) + "s"))
		else:
			break
			
func find_sounds_noise():
	for i in range(5):
		if has_node("sound" + String(i) + "n"):
			sounds_noise.append(get_node("sound" + String(i) + "n"))
		else:
			break
			
func find_sounds_end():
	for i in range(5):
		if has_node("sound" + String(i) + "e"):
			sounds_end.append(get_node("sound" + String(i) + "e"))
		else:
			break
