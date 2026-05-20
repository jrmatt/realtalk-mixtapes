@tool
extends EditorScript

func _run():	
	var track_data = FileAccess.open("res://data/track_data.tsv", FileAccess.READ)
	track_data.get_line() # skips the header row
	
	var all_frequencies: Array = []
	
	while not track_data.eof_reached():
		var line = track_data.get_line().strip_edges()

		if line == "": continue

		var cols = line.split("\t")
		var frequencies = cols[2].split(",")
		
		for freq in frequencies:
			var clean_freq = freq.strip_edges()
			if clean_freq not in all_frequencies:
				all_frequencies.append(clean_freq)
								
	track_data.close()
				
	var unique_frequencies = Frequencies.new()
	unique_frequencies.frequencies = all_frequencies
	ResourceSaver.save(unique_frequencies, "res://resources/frequencies.tres")	
