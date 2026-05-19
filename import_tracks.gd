@tool
extends EditorScript

func _run():
	var track_data = FileAccess.open("res://data/track_data.tsv", FileAccess.READ)
	track_data.get_line() # skips the header row

	while not track_data.eof_reached():
		var line = track_data.get_line().strip_edges()

		if line == "": continue

		var cols = line.split("	")
		var id = cols[0]
		var speakers = cols[1].split(",")
		var frequency = cols[2].split(",")

		var track = Track.new()
		track.id = id
		track.speakers = speakers
		track.frequency = frequency
		track.audio = load("res://audio/%s.mp3" % id)

		ResourceSaver.save(track, "res://resources/tracks/%s.tres" % id)
		print("Saved Track: ", id)

	print("Done!")
