class_name Mixtape
extends Node2D

var mixtape_id: int
var mixtape = {}
var track_id = 0

# Desired behavior:

# still want to adjust the start time back ~5 sec for user benefit, ran into trouble with min/max/clamp

# when recording is started, record current track & track time
func _start_recording(track, start_time) -> void:
	mixtape[track_id] = {"track": track, "start_time": start_time}
	print(mixtape_id, mixtape)	
	
# if recording gets paused, record current track & end time, increment the mixtape track id value
func _pause_recording(end_time) -> void:
	var latest_track = mixtape.keys()[-1]
	mixtape[latest_track].end_time = end_time
	track_id += 1
	print(mixtape_id, mixtape)

# if recording gets stopped, record current track & end time, add mixtape to completed mixtapes
func _stop_recording(end_time) -> void:
	var latest_track = mixtape.keys()[-1]
	mixtape[latest_track].end_time = end_time
	print("Mixtape stopped: ", mixtape)
	# create new completed mixtape

# when track changes during recording, record time of the previous track when track changed & new track & new track start time

# I don't think this is right yet, it is recording the same time for the end of the previous track as the start of the new track, but other freqs might be on a later track. we're not capturing the time we arrive at the new track within that track's context? hard to debug this without knowing we're skipping shorter highlights
func _on_track_change(end_time, track, time):
	print("Detected track change")
	var latest_track = mixtape.keys()[-1]
	mixtape[latest_track].end_time = end_time
	track_id += 1
	mixtape[track_id] = {"track": track, "start_time": time}
	print(mixtape_id, mixtape)

# when cassette runs out of tape, stop recording automatically and eject

# mixtape playback (another node, using the mixtape dict created?) plays each track from the given start to end time

# should this node clear itself once the mixtape is saved?
