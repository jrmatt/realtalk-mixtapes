@tool
extends EditorScript

func _run():
	var track_data = FileAccess.open("res://data/track_data.tsv", FileAccess.READ)
	track_data.get_line() # skips the header row

	var tracks_array: Array[Track] = []

	# iterate through tracks data and save a new track resource per track
	while not track_data.eof_reached():
		var line = track_data.get_line().strip_edges()

		if line == "": continue

		var cols = line.split("\t")
		var id = cols[0]
		var speakers = cols[1].split(",")
		var frequencies = cols[2].split(",")
		var audio = load("res://track_audio/%s.mp3" % id)
		if audio == null:
			print("AUDIO NOT FOUND FOR: ", id)

		var track = Track.new()
		track.id = id
		track.speakers = speakers
		track.frequencies = frequencies
		track.audio = audio

		tracks_array.append(track)

		ResourceSaver.save(track, "res://resources/tracks/%s.tres" % id)
		print("Saved Track: ", id)

	track_data.close()

	# add the new tracks to a library resource
	var library = TrackLibrary.new()
	library.tracks = tracks_array
	ResourceSaver.save(library, "res://resources/library.tres")

	print("Done!")
