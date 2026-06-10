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
        
        var speakers = _clean_col(1, cols)
        var freq = cols[2]
        var id = cols[0]
        var audio = load("res://track_audio/%s.mp3" % id)
        if audio == null:
            print("AUDIO NOT FOUND FOR: ", id)

        var track = Track.new()
        track.id = id
        track.speakers = speakers
        track.frequency = freq
        track.audio = audio

        tracks_array.append(track)

        ResourceSaver.save(track, "res://resources/tracks/%s.tres" % id)
        #print("Saved Track: ", track.id, track.speakers)

    track_data.close()

    # add the new tracks to a library resource
    var library = TrackLibrary.new()
    library.tracks = tracks_array
    ResourceSaver.save(library, "res://resources/library.tres")
    
    # create frequencies resource (unique frequencies)
    var unique_freqs: Array[String] = []
    
    for track in tracks_array:
        if track.frequency not in unique_freqs:
            unique_freqs.append(track.frequency)
                
    var freqs_to_save = Frequencies.new()
    freqs_to_save.frequency_names = unique_freqs
    ResourceSaver.save(freqs_to_save, "res://resources/frequencies.tres")
    
    for freq in unique_freqs:
        var frequency_to_save = Frequency.new()
        frequency_to_save.frequency_name = freq
        for track in tracks_array:
            if track.frequency == freq:
                frequency_to_save.tracks.append(track)
        ResourceSaver.save(frequency_to_save, "res://resources/frequencies/frequency_%s.tres" % freq)

func _clean_col(col, cols):
    var clean_items: Array = []
    var items = cols[col].split(",")
    
    for item in items:
        var clean_item = item.strip_edges()
        clean_items.append(clean_item)
        
    return clean_items
