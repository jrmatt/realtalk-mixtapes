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

		var clean_freqs: Array = []
		var frequencies = cols[2].split(",")
		for freq in frequencies:
			var clean_freq = freq.strip_edges()
			clean_freqs.append(clean_freq)
		
		var clean_speakers: Array = []
		var speakers = cols[1].split(",")
		for speaker in speakers:
			var clean_speaker = speaker.strip_edges()
			clean_speakers.append(clean_speaker)

		var id = cols[0]
		var audio = load("res://track_audio/%s.mp3" % id)
		if audio == null:
			print("AUDIO NOT FOUND FOR: ", id)

		var track = Track.new()
		track.id = id
		track.speakers = clean_speakers
		track.frequencies = clean_freqs
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
