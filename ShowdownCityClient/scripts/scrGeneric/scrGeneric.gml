function surface_create_clear(_width, _height)	{
	var _surfaceIndex = surface_create(_width, _height);
	surface_set_target(_surfaceIndex);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
	return _surfaceIndex;
}
function file_read_return(_filepath)	{
	var _ReturnString = "";
	var _FileInstance = file_text_open_read(_filepath);
	while !(file_text_eof(_FileInstance))	{
		_ReturnString += file_text_readln(_FileInstance);
	}
	file_text_close(_FileInstance);
	return _ReturnString;
}
function draw_surface_center(_surface, _x, _y, _angle, _scale, _blend, _alpha) {
	if !surface_exists(_surface)	{
	    return -1;
	}

	var _surfaceWidth = surface_get_width(_surface) * _scale;
	var _surfaceHeight = surface_get_height(_surface) * _scale;
	var _trigX = dcos(_angle);
	var _trigY = dsin(_angle);

	var _posX = (_x - _trigX * (_surfaceWidth / 2) - _trigY * (_surfaceHeight / 2));
	var _posY = (_y - _trigX * (_surfaceHeight / 2) + _trigY * (_surfaceWidth / 2));
	draw_surface_ext(_surface, _posX, _posY, _scale, _scale, _angle, _blend, _alpha);
}
function draw_text_parameters_shadow(_halign, _valign, _x, _y, _string, _alpha, _colour, _shadow_x, _shadow_y, _scale, _angle)	{
	var _oldAlpha = draw_get_alpha();
	draw_set_halign(_halign);
	draw_set_valign(_valign);
	draw_set_alpha(_alpha);
	draw_set_colour(merge_colour(_colour, c_black, 0.5));
	draw_text_transformed(_x + _shadow_x, _y + _shadow_y, _string, _scale, _scale, _angle);
	draw_set_colour(_colour);
	draw_text_transformed(_x - _shadow_x, _y - _shadow_y, _string, _scale, _scale, _angle);
	draw_set_alpha(_oldAlpha);
}
function round_n(argument0, argument1) {
	return round(argument0/argument1)*argument1;
}
function hex_to_dec(_hex)	{
    var _dec = 0;
    var dig = "0123456789ABCDEF";
    var len = string_length(_hex);
    for (var pos=1; pos<=len; pos+=1) {
        _dec = _dec << 4 | (string_pos(string_char_at(_hex, pos), dig) - 1);
    }
 
    return _dec;
}
function hex_to_colour(_hexstring)	{
	_hexstring = string_replace_all(_hexstring, "#", "");
	var _hexR = string_copy(_hexstring, 1, 2);
	var _hexG = string_copy(_hexstring, 3, 2);
	var _hexB = string_copy(_hexstring, 5, 2);
	return hex_to_dec(_hexB + _hexG + _hexR);
}
function print()	{
	if string_copy(string(argument[0]), 1, 1) != "!"	{
		switch (object_index)	{
		case NetClient:
			if (!global.NetSettingDebugClient)	{
				return undefined;
			}
			break;

		case NetServer:
			if (!global.NetSettingDebugServer)	{
				return undefined;
			}
			break;
		}
	}
	var _Coordinates = "(" + string(x) + ", " + string(y) + ")";
	var _Index = string(object_get_name(object_index));
	var _Output = "";
	for (var i = 0; i < (argument_count); i ++) {
	    _Output += string(argument[i]);
    
	    if (i < (argument_count - 1))
	        _Output += ", ";
	}
	var _finalMessage = _Index + " - " + _Coordinates + " - " + _Output;
	show_debug_message(_finalMessage);
	return _Output;
}
function print_verbose()	{
	if (!global.NetSettingDebugVerbose)	{
		exit;
	}

	if string_copy(string(argument[0]), 1, 1) != "!"	{
		switch (object_index)	{
		case NetClient:
			if (!global.NetSettingDebugClient)	{
				return undefined;
			}
			break;

		case NetServer:
			if (!global.NetSettingDebugServer)	{
				return undefined;
			}
			break;
		}
	}
	var _Coordinates = "(" + string(x) + ", " + string(y) + ")";
	var _Index = string(object_get_name(object_index));
	var _Output = "";
	for (var i = 0; i < (argument_count); i ++) {
	    _Output += string(argument[i]);
    
	    if (i < (argument_count - 1))
	        _Output += ", ";
	}
	var _finalMessage = _Index + " - " + _Coordinates + " - " + _Output;
	show_debug_message(_finalMessage);
	return _Output;
}
function approach() {
	var current = argument[0]; // Current value
	var target = argument[1]; // Target value
	var amount = argument[2]; // Amount to approach each step

	// approach the value but don't go over
	if (current < target) {
	    return min(current+amount, target); 
	} else {
	    return max(current-amount, target);
	}
}
function wave(from, to, duration, offset)	{
	a4 = (to - from) * 0.5;
	return from + a4 + sin((((current_time * 0.001) + duration * offset) / duration) * (pi*2)) * a4;
}
function print_callstack()	{
	var _ArrayCallback = debug_get_callstack();
	print(" -- Begin Callstack --");
	for (var i = 0; i < array_length(_ArrayCallback); i ++)	{
		print(_ArrayCallback[i]);
	}
	print(" -- End Callstack --");
}
function draw_nineslice(left, top, right, bottom, sprite, tint, opacity)	{
	if (!sprite_exists(sprite)) return false;
	var sprite_size = sprite_get_height(sprite);
	if (sprite_get_width(sprite) != sprite_size)	{
	    show_debug_message(sprite_get_name(sprite) + " cannot be NINEBOXed because it is not a perfect square.");
	    return false;
	}
	if not (sprite_size mod 3 == 0)	{
	    show_debug_message(sprite_get_name(sprite) + " cannot be NINEBOXed because its pixel size is not divisible by three.");
	    return false;
	}

	var slice_size = sprite_size / 3;

	// Draw Fill
	var scale_x = ((right - slice_size) - (left + slice_size)) / slice_size;
	var scale_y = ((bottom - slice_size) - (top + slice_size)) / slice_size;
	draw_sprite_part_ext(sprite, 0, slice_size, slice_size, slice_size, slice_size, left + slice_size, top + slice_size, scale_x, scale_y, tint, opacity);

	// Draw Vertical Edges
	draw_sprite_part_ext(sprite, 0, 0, slice_size, slice_size, slice_size, left, top + slice_size, 1, scale_y, tint, opacity);
	draw_sprite_part_ext(sprite, 0, slice_size * 2, slice_size, slice_size, slice_size, right - slice_size, top + slice_size, 1, scale_y, tint, opacity);
	// Draw Horizontal Edges

	draw_sprite_part_ext(sprite, 0, slice_size, 0, slice_size, slice_size, left + slice_size, top, scale_x, 1, tint, opacity);
	draw_sprite_part_ext(sprite, 0, slice_size, slice_size * 2, slice_size, slice_size, left + slice_size, bottom - slice_size, scale_x, 1, tint, opacity);

	// Draw the Corners
	draw_sprite_part_ext(sprite, 0, 0, 0, slice_size, slice_size, left, top, 1, 1, tint, opacity);
	draw_sprite_part_ext(sprite, 0, slice_size * 2, 0, slice_size, slice_size, right - slice_size, top, 1, 1, tint, opacity);
	draw_sprite_part_ext(sprite, 0, 0, slice_size * 2, slice_size, slice_size, left, bottom - slice_size, 1, 1, tint, opacity);
	draw_sprite_part_ext(sprite, 0, slice_size * 2, slice_size * 2, slice_size, slice_size, right - slice_size, bottom - slice_size, 1, 1, tint, opacity);
	return slice_size;
}
function sound()	{
	var _soundIndex = argument[0];
	var _soundPitch = 1.0;
	var _soundGain = 1.0;

	if (argument_count > 1)
	    _soundPitch = argument[1];
	if (argument_count > 2)
	    _soundGain = argument[2];
    
	var _idSound = audio_play_sound(_soundIndex, 1, 0);

	audio_sound_pitch(_idSound, _soundPitch);
	audio_sound_gain(_idSound, _soundGain, 0);
	return _idSound;
}
function midi_read() {
	// Select raw if you want all events, unfiltered

	/*
	Example output:

	[
		(ds_list consisting of notes:) [
			(note): [
				(start time:) 0,
				(note number:) 60,
				(velocity:) 10,
				(end time:) 100
			]
		] ,
		(ds_list consisting of events): [
			(event:) [
				(event time:) 100,
				(event name:) "end of track",
				(event data:) "N/A"
			]
		]
	]
	*/

	/*
	Example output (with raw on):
	Use website such as "https://www.mobilefish.com/tutorials/midi/midi_quickguide_specification.html" to look up midi events

	[
		(ds_list consisting of notes:) [
			(note): [
				(start time:) 0,
				(note number:) 60,
				(velocity:) 10,
				(end time:) 100
			]
		] ,
		(ds_list consisting of raw events): [
			(event:) [
				(event time:) 100,
				(event status byte:) "FF",
				(event byte 1; substatus:) "F2",
				(event data:) "N/A"
			],
			(event:) [
				(event time:) 25,
				(event status byte:) "B0",
				(event byte 1; substatus:) "40",
				(event data:) "63"
			]
		]
	]
	*/

	var _errstring = "Failed to read midi file: ";

	var _raw = 0;
	if (argument_count > 1) {
		_raw = argument[1];
	}

	if (argument[0] != "") {
		var bin = file_bin_open(argument[0], 0);
		var size = file_bin_size(bin);
		var hexdata = "";
		while(file_bin_position(bin) < size) {
			hexdata += dec_to_hex(file_bin_read_byte(bin));
		}
		file_bin_close(bin);
	} else {
		show_error(_errstring+"nonexistant file", false);
		return 0;
	}

	if (string_copy(hexdata, 0, 8) != "4D546864") {
		show_error(_errstring+"faulty header", false);
		return 0;
	}

	eventlist = ds_list_create();
	notelist = ds_list_create();

	var action = "";
	var notes = ds_list_create();
	for(var i = 0; i < 150; i++) {
		notes[| i] = ds_list_create();
	}

	var offset = 23;

	var trackamount = hex_to_dec(string_copy(hexdata, offset, 2));

	offset += 6;

	while(trackamount > 0) {
		offset += 16;
		trackamount--;
		total = 0;
	
		while(true) {
			var i = 2;
		
			var dtime = [];
			while(true) {
				dtime[array_length(dtime)] = hex_to_bin(string_copy(hexdata, offset+(i-2), 2));
			
				if (string_copy(dtime[array_length(dtime)-1], 0, 1) == "0") {
					var j = 0;
					var ntime = "";
					repeat(i/2) {
						ntime += "0";
					}
					repeat(i/2) {
						ntime += string_copy(dtime[j], 2, 7);
						j++;
					}
					dtime = hex_to_dec(bin_to_hex(ntime));
					offset += i;
					break;
				}
				i += 2;
			}

			var status = string_copy(hexdata, offset, 1);
			var fstatus = string_copy(hexdata, offset, 2);

			total += dtime;
		
			if (status == "C" or status == "D" or status == "8" or status == "9" or status == "E" or status == "B" or status == "A") {
				offset += 2;
				action = status;
			} else if (status == "F") {
				offset += 2;
				action = "";
				var substatus = string_copy(hexdata, offset, 2);
				offset += 2;
				if (substatus == "2F") {
					if (_raw) {
						ds_list_add(eventlist, [total, fstatus, substatus, "N/A"]);
					} else {
						ds_list_add(eventlist, [total, "end of track", "N/A"]);
					}
					offset += 2;
					break;
				}
				var l = string_copy(hexdata, offset, 2);
				offset += 2;
				if (_raw) {
					ds_list_add(eventlist, [total, fstatus, substatus, string_copy(hexdata, offset, hex_to_dec(l)*2)]);
				} else {
					if (substatus == "01") {
						ds_list_add(eventlist, [total, "text event", hex_to_text(string_copy(hexdata, offset, hex_to_dec(l)*2))]);
					}
					if (substatus == "04") {
						ds_list_add(eventlist, [total, "track name", hex_to_text(string_copy(hexdata, offset, hex_to_dec(l)*2))]);
					}
					if (substatus == "05") {
						ds_list_add(eventlist, [total, "lyric", hex_to_text(string_copy(hexdata, offset, hex_to_dec(l)*2))]);
					}
					if (substatus == "06") {
						ds_list_add(eventlist, [total, "marker", hex_to_text(string_copy(hexdata, offset, hex_to_dec(l)*2))]);
					}
					if (substatus == "02") {
						ds_list_add(eventlist, [total, "copyright notice", hex_to_text(string_copy(hexdata, offset, hex_to_dec(l)*2))]);
					}
					if (substatus == "51") {
						var timesig = (60000000 / hex_to_dec(string_copy(hexdata, offset, 6)));
						ds_list_add(eventlist, [total, "bpm change", timesig]);
					}
				}
				offset += hex_to_dec(l)*2;
			}
		
			if (action == "C") {
				if (_raw) {
					ds_list_add(eventlist, [total, fstatus, "N/A", string_copy(hexdata, offset, 2)]);
				} else {
					ds_list_add(eventlist, [total, "instrument change", hex_to_dec(string_copy(hexdata, offset, 2))]);
				}
				offset += 2;
			} if (action == "D") {
				if (_raw) {
					ds_list_add(eventlist, [total, fstatus, "N/A", string_copy(hexdata, offset, 2)]);
				}
				offset += 2;
			} else if (action == "E" or action == "A" or action == "B") {
				if (_raw) {
					ds_list_add(eventlist, [total, fstatus, string_copy(hexdata, offset, 2), string_copy(hexdata, offset+2, 2)]);
				}
				offset += 4;
			} else if (action == "9") {
				var note = hex_to_dec(string_copy(hexdata, offset, 2));
				offset += 2;
				var velocity = hex_to_dec(string_copy(hexdata, offset, 2));
				offset += 2;
				if (velocity > 0) {
					ds_list_add(notelist, [total, note, velocity, 0]);
					ds_list_add(notes[| note], ds_list_size(notelist)-1);
				} else {
					action = "8+";
				}
			} 
			if (action == "8" or action == "8+") {
				if (action != "8+") {
					var note = hex_to_dec(string_copy(hexdata, offset, 2));
					offset += 4;
				} else {
					action = "9";
				}
				array_set(notelist[| ds_list_find_value(notes[| note], ds_list_size(notes[| note]) - 1)], 3, total)
				ds_list_delete(notes[| note], ds_list_size(notes[| note]) - 1);
			}
		}
	}
	return [notelist, eventlist];
}
function midi_read_return(_file)	{
	var _MidiArray = midi_read(_file, false);
	var _MidiInformationNotes = _MidiArray[0];
	var _MidiInformationEvents = _MidiArray[1];
	var _MidiTempo = -1;

	// Determine Tempo
	for (var i = 0; i < ds_list_size(_MidiInformationEvents); i ++)	{
			var _MidiEventIndex = _MidiInformationEvents[| i];
			if (_MidiEventIndex[1] == "bpm change")	{
				_MidiTempo = _MidiEventIndex[2];
			}
	}
	if (_MidiTempo == -1)	{
		show_error("Could not find BPM.", true);
	}
	
	// Compile Notes
	var _MidiListNotes = ds_list_create();
	for (var _MidiNoteIndex = 0; _MidiNoteIndex < (ds_list_size(_MidiInformationNotes)); _MidiNoteIndex ++)	{
		var _MidiListNoteInstance = _MidiInformationNotes[| _MidiNoteIndex];
		var _MidiNoteInstance = {
			MidiNoteTickStart: _MidiListNoteInstance[0],
			MidiNoteValue: _MidiListNoteInstance[1],
			MidiNoteVelocity: _MidiListNoteInstance[2],
			MidiNoteTickEnd: _MidiListNoteInstance[3]
		}
		ds_list_add(_MidiListNotes, _MidiNoteInstance);
	}
	ds_list_destroy(_MidiInformationNotes);
	
	// Compile Object
	var _MidiObjectInstance = {
		MidiTempo: _MidiTempo,
		MidiNotes: _MidiListNotes
	}
	
	// Return
	return _MidiObjectInstance;
}
function dec_to_hex(argument0) {
	{
	    var dec, hex, h, byte, hi, lo;
	    dec = argument0;
	    if (dec) hex = "" else hex="00";
	    h = "0123456789ABCDEF";
	    while (dec) {
	        byte = dec & 255;
	        hi = string_char_at(h, byte div 16 + 1);
	        lo = string_char_at(h, byte mod 16 + 1);
	        hex = hi + lo + hex;
	        dec = dec >> 8;
	    }
	    return hex;
	}
}
function hex_to_bin(_hex) {
	{
	    var hex, bin, n, h, l, p;
	    hex = string_upper(_hex);
	    bin = "";
	    n = "0000101100111101000";
	    h = "0125B6C937FEDA48";
	    l = string_length(hex);
	    for (p=1; p<=l; p+=1) {
	        bin += string_copy(n, string_pos(string_char_at(hex, p), h), 4);
	    }
	    return bin;
	}
}
function bin_to_hex(_bin) {
	{
	    var bin, hex, n, h, l, p;
	    bin = _bin;
	    hex = "";
	    n = "0000101100111101000";
	    h = "0125B6C937FEDA48";
	    l = string_length(bin);
	    bin = string_repeat("0", 3-(l-1) mod 4) + bin;
	    for (p=1; p<=l; p+=4) {
	        hex += string_char_at(h, string_pos(string_copy(bin, p, 4), n));
	    }
	    return hex;
	}
}
function ds_list_print(_list) {
	var list = _list;
	var str = "";
	for(var i=0;i<ds_list_size(list);i+=1){
		str += string(ds_list_find_value(list,i))+",";
	}
	print(str);
	return str;
}
function fs(_seconds)	{
	return floor(game_get_speed(gamespeed_fps) * _seconds);
}
function angle_rotate(_initial, _target, _amount)	{
	var _AngleDifference = angle_difference(_initial, _target);
	return (_initial - min(abs(_AngleDifference), _amount) * sign(_AngleDifference));
}
function angle_rotate_smooth(_initial, _target)	{
	var _AngleDifference = angle_difference(_initial, _target);
	return (_initial - ((abs(_AngleDifference) / (10 / global.DeltaTimeFactor)) * sign(_AngleDifference)));
}
function place_meeting_ray()	{
	var _InX = argument[0];
	var _InY = argument[1];
	var _InObject = parSolid;
	var _InPrecise = true;
	if (argument_count > 2)	{
		_InObject = argument[2];
		if (argument_count > 3)	{
			_InPrecise = argument[3];
		}
	}
	
	var _CollisionPoint = place_meeting(_InX, _InY, _InObject);
	var _CollisionLine = (collision_line(x, y, _InX, _InY, _InObject, _InPrecise, true) != noone);
	return (_CollisionPoint or _CollisionLine);
}	
function draw_rectangle_width(argument0, argument1, argument2, argument3, argument4) {
	var x1, x2, y1, y2, w;     
	x1 = argument0;     
	y1 = argument1;     
	x2 = argument2;     
	y2 = argument3;     
	w = argument4;     
	draw_line_width(x1 - w/2, y1, x2 + w/2, y1, w);     
	draw_line_width(x2, y1 + w/2, x2, y2 - w/2, w);     
	draw_line_width(x1 - w/2, y2, x2 + w/2, y2, w);     
	draw_line_width(x1, y1 + w/2, x1, y2 - w/2, w);   
}
function draw_triangle_width(x1, y1, x2, y2, x3, y3, w)	{
	draw_line_width(x1, y1, x2, y2, w);
	draw_line_width(x2, y2, x3, y3, w);
	draw_line_width(x3, y3, x1, y1, w);
}
function sound_at()	{
	var _InSoundIndex = argument[0];
	var _InSoundX = argument[1];
	var _InSoundY = argument[2];
	var _InSoundDistance = argument[3];
	return audio_play_sound(_InSoundIndex, 1, false);
}
function array_random(_array)	{
	return _array[irandom(array_length(_array) - 1)];
}
function in_range(_val, _min, _max)	{
	return ((_min < _val) and (_val < _max));
}
function instance_return_array(_object)	{
	var _ArrayOutput = [];
	for (var i = 0; i < instance_number(_object); i ++)	{
		_ArrayOutput[i] = instance_find(_object, i);
	}
	return _ArrayOutput;
}
function draw_path_width(_path, _width)	{
	for (var i = 0; i < (path_get_number(_path) - 1); i ++)	{
		draw_line_width(path_get_point_x(_path, i), path_get_point_y(_path, i), path_get_point_x(_path, i + 1), path_get_point_y(_path, i + 1), _width);
	}
}
function draw_healthbar_nineslice(_x1, _y1, _x2, _y2, _amount, _colour, _sprite_back, _sprite_front, _alpha)	{
	_amount = clamp(_amount, 0.0, 1.0);
	draw_nineslice(_x1, _y1, _x2, _y2, _sprite_back, c_white, _alpha);
	if (_amount > 0)	{
		var _BarWidth = abs(_x2 - _x1);
		draw_nineslice(_x1, _y1, _x1 + (_BarWidth * _amount), _y2, _sprite_front, _colour, _alpha);
	}
}
function collision_line_point(x1, y1, x2, y2, _object, _precise, _not_me)	{
	var rr, rx, ry;
	rr = collision_line(x1, y1, x2, y2, _object, _precise, _not_me);
	rx = x2;
	ry = y2;
	if (rr != noone) {
	    var p0 = 0;
	    var p1 = 1;
	    repeat (ceil(log2(point_distance(x1, y1, x2, y2))) + 1) {
	        var np = p0 + (p1 - p0) * 0.5;
	        var nx = x1 + (x2 - x1) * np;
	        var ny = y1 + (y2 - y1) * np;
	        var px = x1 + (x2 - x1) * p0;
	        var py = y1 + (y2 - y1) * p0;
	        var nr = collision_line(px, py, nx, ny, _object, _precise, _not_me);
	        if (nr != noone) {
	            rr = nr;
	            rx = nx;
	            ry = ny;
	            p1 = np;
	        } else p0 = np;
	    }
	}
	var r;
	r[0] = rr;
	r[1] = rx;
	r[2] = ry;
	return r;
}
function screenshot() {
	if !directory_exists(working_directory + "Screenshots")	{
		directory_create("Screenshots");
	}
    var i,fname;
    i = 0;
    // If there is a file with the current name and number,
    // advance counter and keep looking:
    do {
        fname = working_directory+"Screenshots/Screenshot_" + string(i)+ ".png";
        i += 1;
    } until (!file_exists(fname))
    // Once we've got a unused number we'll save the screenshot under it:
    screen_save(fname);
    return file_exists(fname);
}
function collision_line_point_closest(_self_x, _self_y, _x1, _y1, _x2, _y2, _array, _precise, _notme)	{
	var _ArrayReturn = [noone, 0, 0];
	var _InstanceDistance = undefined;
	for (var _ObjectIteration = 0; _ObjectIteration < (array_length(_array)); _ObjectIteration ++)	{
		var _CollisionReturn = (collision_line_point(_x1, _y1, _x2, _y2, _array[_ObjectIteration], _precise, _notme));
		if (instance_exists(_CollisionReturn[0]))	{
			if (_InstanceDistance == undefined)	{
				_ArrayReturn = _CollisionReturn;
				_InstanceDistance = (point_distance(_self_x, _self_y, _CollisionReturn[1], _CollisionReturn[2]));
			}	else	{
				var _CheckDistance = (point_distance(_self_x, _self_y, _CollisionReturn[1], _CollisionReturn[2]));
				if (_CheckDistance < _InstanceDistance)	{
					_ArrayReturn = _CollisionReturn;
					_InstanceDistance = (point_distance(_self_x, _self_y, _CollisionReturn[1], _CollisionReturn[2]));
				}
			}
		}
	}
	
	return _ArrayReturn;
}
function toggle(_bool)	{
	if (_bool)	{
		return "TRUE";
	}	else	{
		return "FALSE";
	}
}
function uuid_generate() {
	var d = current_time + epoch() * 10000, uuid = array_create(32), i = 0, r;
	for (i=0;i<array_length(uuid);++i) {
	    r = floor((d + random(1) * 16)) mod 16;
	    if (i == 16)
	        uuid[i] = dec_to_hex(r & $3|$8);
	    else
	        uuid[i] = dec_to_hex(r);
	}
	uuid[12] = "4";
	var _Result = uuid_array_implode(uuid);
	print("Generated UUID", _Result);
	return _Result;
}
function uuid_array_implode(argument0) {
	var s = "", i=0, sl = array_length(argument0), a = argument0, sep = "-";
	repeat 8 s += a[i++];
	s += sep;
	repeat 4 s += a[i++];
	s += sep;
	repeat 4 s += a[i++];
	s += sep;
	repeat 4 s += a[i++];
	s += sep;
	repeat 12 s += a[i++];
	return s;
}
function iff(argument0, argument1, argument2) {
	if argument0 return argument1 return argument2
}
function epoch() {
	return round(date_second_span(date_create_datetime(2016,1,1,0,0,1), date_current_datetime()));
}
function game_child(_number)	{
/// Dual-start

// Number Of Extra Players To Start
var NumberOfChildren=_number - 1;

// parameter_string(0)="C:\Users\Katarina\AppData\Roaming\GameMaker-Studio\Runner.exe"
var RunnerPath=parameter_string(0);

// Loop all other info until .win is found
var OtherParameters="";
var WinFile="";
var ParameterAfterWinFile="";
var HeadProgram=true;
var State=0;
for (var i=1; i<parameter_count(); i+=1)
{
    switch (State)
    {
        case 0:
            // Search for .win
            if string_pos(".win",parameter_string(i))
            {
                WinFile=parameter_string(i);
                State=1;
            }    
            else
            {
                // Not win just some info to add in queue
                if OtherParameters=""
                {
                    OtherParameters=parameter_string(i);
                }
                else
                {
                    OtherParameters=OtherParameters + " " + parameter_string(i);
                }
            }        
            break;
        case 1:
            ParameterAfterWinFile=parameter_string(i);
            HeadProgram=false;
            break;
    }
}

if HeadProgram
{
    for (var i=0; i<NumberOfChildren; i+=1)
    {
        execute_shell_simple(RunnerPath,OtherParameters + " \"" + WinFile + "\" P" + string(i+2));
    }
    window_set_position(window_get_x() - window_get_width() div 2 - 8, window_get_y())
    window_set_caption("P1")    
}
else
{
    window_set_position(window_get_x() + window_get_width() div 2 + 8, window_get_y())
    window_set_caption(ParameterAfterWinFile)    
}
}
function totro(minsyl, maxsyl, n) {
	/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
	*/

	//From the orginal Totro doc:
	// List of possible vowels, followed by list of possible consonants.
	// In both lists, duplicates increase the likelihood of that selection.
	// The second parameter indicates if the syllable can occur
	// at the beginning, middle, or ending of a name, and is the sum of
	// the following:
	//  1=can be at ending,
	//  2=can be at beginning
	//  4=can be in middle
	// Thus, the value 7 means "can be anywhere", 6 means "beginning or middle".
	// 5 means "only middle or end", and 4 means "only in the middle".
	// This is a binary encoding, as (middle) (beginning) (end).
	// Occasionally, 'Y' will be duplicated as a vowel and a consonant.
	// That's so rare that we won't worry about it, in fact it's interesting.
	// There MUST be a possible vowel and possible consonant for any
	// possible position; if you want to have "no vowel at the end", use
	// ('',1) and make sure no other vowel includes "can be at end".

	var vowels,consonants, i;

	/** VOWELS**/
	//I HATE GameMaker's arrays...
	//If you don't get this, it fills up 12 entrys of a,e,i,o and u and 
	//7 in this second coloum till 80. 81 is a 4 in coloum two
	for (i=0;i<80;i++) {
	  if (i<12)
	    vowels[i,0] = "a";
	  else if (i<24)
	    vowels[i,0] = "e";
	  else if (i<36)
	    vowels[i,0] = "i";
	  else if (i<48)
	    vowels[i,0] = "o";
	  else if (i<60)
	    vowels[i,0] = "u";
    
	  vowels[i,1] = 7;
	}
	vowels[60,0] = "ae";
	vowels[61,0] = "ai";
	vowels[62,0] = "ao";
	vowels[63,0] = "au";
	vowels[64,0] = "aa";
	vowels[65,0] = "ea";
	vowels[66,0] = "eo";
	vowels[67,0] = "eu";
	vowels[68,0] = "ee";
	vowels[69,0] = "ia";
	vowels[70,0] = "io";
	vowels[71,0] = "iu";
	vowels[72,0] = "ii";
	vowels[73,0] = "oa";
	vowels[74,0] = "oe";
	vowels[75,0] = "oi";
	vowels[76,0] = "ou";
	vowels[77,0] = "oo";
	vowels[78,0] = "eau";
	vowels[79,0] = "y";
	vowels[80,0] = "'"; vowels[80,1] = 4;

	/** CONSONANTS**/
	//It doesn't get better here folks..........
	consonants[0,0] = "b"; consonants[0,1] = 7;
	consonants[1,0] = "c"; consonants[1,1] = 7;
	consonants[2,0] = "d"; consonants[2,1] = 7;
	consonants[3,0] = "f"; consonants[3,1] = 7;
	consonants[4,0] = "g"; consonants[4,1] = 7;
	consonants[5,0] = "h"; consonants[5,1] = 7;
	consonants[6,0] = "j"; consonants[6,1] = 7;
	consonants[7,0] = "k"; consonants[7,1] = 7;
	consonants[8,0] = "l"; consonants[8,1] = 7;
	consonants[9,0] = "m"; consonants[9,1] = 7;
	consonants[10,0] = "n"; consonants[10,1] = 7;
	consonants[11,0] = "p"; consonants[11,1] = 7;
	consonants[12,0] = "qu"; consonants[12,1] = 6;
	consonants[13,0] = "r"; consonants[13,1] = 7;
	consonants[14,0] = "s"; consonants[14,1] = 7;
	consonants[15,0] = "t"; consonants[15,1] = 7;
	consonants[16,0] = "v"; consonants[16,1] = 7;
	consonants[17,0] = "w"; consonants[17,1] = 7;
	consonants[18,0] = "x"; consonants[18,1] = 7;
	consonants[19,0] = "y"; consonants[19,1] = 7;
	consonants[20,0] = "z"; consonants[20,1] = 7;
	// Blends, sorted by second character:
	consonants[22,0] = "sc"; consonants[22,1] = 7;
	consonants[23,0] = "ch"; consonants[23,1] = 7;
	consonants[24,0] = "gh"; consonants[24,1] = 7;
	consonants[25,0] = "ph"; consonants[25,1] = 7;
	consonants[26,0] = "sh"; consonants[26,1] = 7;
	consonants[27,0] = "th"; consonants[27,1] = 7;
	consonants[28,0] = "wh"; consonants[28,1] = 6;
	consonants[29,0] = "ck"; consonants[29,1] = 5;
	consonants[30,0] = "nk"; consonants[30,1] = 5;
	consonants[31,0] = "rk"; consonants[31,1] = 5;
	consonants[32,0] = "sk"; consonants[32,1] = 7;
	consonants[33,0] = "wk"; consonants[33,1] = 0;
	consonants[34,0] = "cl"; consonants[34,1] = 6;
	consonants[35,0] = "fl"; consonants[35,1] = 6;
	consonants[36,0] = "gl"; consonants[36,1] = 6;
	consonants[37,0] = "kl"; consonants[37,1] = 6;
	consonants[38,0] = "ll"; consonants[38,1] = 6;
	consonants[39,0] = "pl"; consonants[39,1] = 6;
	consonants[40,0] = "sl"; consonants[40,1] = 6;
	consonants[41,0] = "br"; consonants[41,1] = 6;
	consonants[42,0] = "cr"; consonants[42,1] = 6;
	consonants[43,0] = "dr"; consonants[43,1] = 6;
	consonants[44,0] = "fr"; consonants[44,1] = 6;
	consonants[45,0] = "gr"; consonants[45,1] = 6;
	consonants[46,0] = "kr"; consonants[46,1] = 6;
	consonants[47,0] = "pr"; consonants[47,1] = 6;
	consonants[48,0] = "sr"; consonants[48,1] = 6;
	consonants[49,0] = "tr"; consonants[49,1] = 6;
	consonants[50,0] = "ss"; consonants[50,1] = 5;
	consonants[51,0] = "st"; consonants[51,1] = 7;
	consonants[52,0] = "str"; consonants[52,1] = 6;
	// Repeat some entries to make them more common.
	consonants[53,0] = "b"; consonants[53,1] = 7;
	consonants[54,0] = "c"; consonants[54,1] = 7;
	consonants[55,0] = "d"; consonants[55,1] = 7;
	consonants[56,0] = "f"; consonants[56,1] = 7;
	consonants[57,0] = "g"; consonants[57,1] = 7;
	consonants[58,0] = "h"; consonants[58,1] = 7;
	consonants[59,0] = "j"; consonants[59,1] = 7;
	consonants[60,0] = "k"; consonants[60,1] = 7;
	consonants[61,0] = "l"; consonants[61,1] = 7;
	consonants[62,0] = "m"; consonants[62,1] = 7;
	consonants[63,0] = "n"; consonants[63,1] = 7;
	consonants[64,0] = "p"; consonants[64,1] = 7;
	consonants[65,0] = "r"; consonants[65,1] = 7;
	consonants[66,0] = "s"; consonants[66,1] = 7;
	consonants[67,0] = "t"; consonants[67,1] = 7;
	consonants[68,0] = "v"; consonants[68,1] = 7;
	consonants[69,0] = "w"; consonants[69,1] = 7;
	consonants[70,0] = "b"; consonants[70,1] = 7;
	consonants[71,0] = "c"; consonants[71,1] = 7;
	consonants[72,0] = "d"; consonants[72,1] = 7;
	consonants[73,0] = "f"; consonants[73,1] = 7;
	consonants[74,0] = "g"; consonants[74,1] = 7;
	consonants[75,0] = "h"; consonants[75,1] = 7;
	consonants[76,0] = "j"; consonants[76,1] = 7;
	consonants[77,0] = "k"; consonants[77,1] = 7;
	consonants[78,0] = "l"; consonants[78,1] = 7;
	consonants[79,0] = "m"; consonants[79,1] = 7;
	consonants[80,0] = "n"; consonants[80,1] = 7;
	consonants[81,0] = "p"; consonants[81,1] = 7;
	consonants[82,0] = "r"; consonants[82,1] = 7;
	consonants[83,0] = "s"; consonants[83,1] = 7;
	consonants[84,0] = "t"; consonants[84,1] = 7;
	consonants[85,0] = "v"; consonants[85,1] = 7;
	consonants[86,0] = "w"; consonants[86,1] = 7;
	consonants[87,0] = "br"; consonants[87,1] = 6;
	consonants[88,0] = "dr"; consonants[88,1] = 6;
	consonants[89,0] = "fr"; consonants[89,1] = 6;
	consonants[90,0] = "gr"; consonants[90,1] = 6;
	//I forgot 21.... :/
	consonants[21,0] = "kr"; consonants[21,1] = 6;
	//Have fun editing that...

	// Create a random name in each for loop and add them to an array- oh no not arrays again!

	var names,j;
	for (j=0;j<n;j++) {
	    var data_0,data_1,rnd;
	    var genname = "";         // this accumulates the generated name.
	    var leng = random_range(minsyl, maxsyl); // Compute number of syllables in the name
	    var isvowel = irandom_range(0, 1); // randomly start with vowel or consonant
	    for (i = 1; i <= leng; i++) { // syllable #. Start is 1 (not 0)
	        while (true) {
	            if (isvowel) {
	                rnd = irandom_range(0, array_height_2d(vowels) - 1);
	                data_0 = vowels[rnd,0];
	                data_1 = vowels[rnd,1];
	            } else {
	                rnd = irandom_range(0, array_height_2d(consonants) - 1);
	                data_0 = consonants[rnd,0];
	                data_1 = consonants[rnd,1];
	            }
	            if (i == 1) { // first syllable.
	                if (data_1 & 2) {
	                    break;
	                }
	            } else if (i == leng) { // last syllable.
	                if (data_1 & 1) {
	                    break;
	                }
	            } else { // middle syllable.
	                if (data_1 & 4) {
	                    break;
	                }
	            }
	        }
	        genname += data_0;
	        isvowel = 1 - isvowel; // Alternate between vowels and consonants.
	    }
	    // Initial caps:
	    genname = string_upper(string_char_at(genname,1))+string_copy(genname, 2, string_length(genname)-1);
	    names[j] = genname;
	}
	return names;
}
function vertex_add_point(_vbuffer, _x, _y, _z, _nx, _ny, _nz, _utex, _vtex, _colour, _alpha)	{
	vertex_position_3d(_vbuffer, _x, _y, _z);
	vertex_normal(_vbuffer, _nx, _ny, _nz);
	vertex_texcoord(_vbuffer, _utex, _vtex);
	vertex_color(_vbuffer, _colour, _alpha);
}
function vertex_add_line(_vbuffer, _x1, _y1, _z1, _x2, _y2, _z2, _colour1, _colour2, _alpha)	{
	vertex_add_point(_vbuffer, _x1, _y1, _z1, 0, 0, 1, 0, 0, _colour1, _alpha);
	vertex_add_point(_vbuffer, _x2, _y2, _z2, 0, 0, 1, 0, 0, _colour2, _alpha);
}
function vertex_add_line_width(_vbuffer, _x1, _y1, _z1, _x2, _y2, _z2, _colour1, _colour2, _alpha, _width, _precision)	{
	for (var _x = (_width * -1); _x < (_width + _precision); _x += _precision)	{
		for (var _y = (_width * -1); _y < (_width + _precision); _y += _precision)	{
			for (var _z = (_width * -1); _z < (_width + _precision); _z += _precision)	{
				vertex_add_line(_vbuffer, _x1 + _x, _y1 + _y, _z1 + _z, _x2 + _x, _y2 + _y, _z1 + _z, _colour1, _colour2, _alpha);
			}
		}
	}
}
function draw_sprite_billboard(_sprite, _frame, _x, _y, _z, _xscale, _yscale, _angle, _blend, _alpha)	{
	shader_set(shdBillboard);
	matrix_set(matrix_world, matrix_build(_x, _y, _z, 0, 0, 0, 1, 1, 1));
	draw_sprite_ext(_sprite, _frame, 0, 0, _xscale, _yscale, _angle, _blend, _alpha);
	matrix_set(matrix_world, matrix_build_identity());
	shader_reset();
}
function draw_text_billboard(_x, _y, _z, _string)	{
	billboard_prepare(_x, _y, _z);
	draw_text(0, 0, _string);
	billboard_end();
}
function billboard_prepare(_x, _y, _z)	{
	var _m = matrix_transpose(matrix_get(matrix_view));
	_m[12] = _x; _m[13] = _y; _m[14] = _z;
	matrix_set(matrix_world, _m);
}
function billboard_end()	{
	matrix_stack_pop();
	matrix_set(matrix_world, matrix_stack_top());
}
function matrix_transpose(_matrix)	{
	var _m0 = _matrix;
	var _m1 = _matrix;
	for (var _i = 0; _i < 3; _i++) {
	   for (var _j = 0; _j < 3; _j++) {
	      _m1[_j*4+_i] = _m0[_i*4+_j]; 
	   }	
	}
	return _m1;
}
function wrap(_value, _min, _max)	{
	if (_value >= _max) return _value-_max;
	if (_value < _min) return _value+_max;
	return _value;
}
function model_load (_filename) {
	model = vertex_create_buffer();
	vertex_begin(model, global.ModelVertexFormat);
	var file = file_text_open_read("Models/" + _filename);

	var version = file_text_read_real(file);

	if (version != 100){
		show_message("Wrong version of the model file!");
		vertex_delete_buffer(model);
		file_text_close(file);
		return -1;
	}

	var n = file_text_read_real(file);
	file_text_readln(file);

	var line = array_create(10, 0);

	for (var i = 0; i < n; i++){
		for (var j = 0; j < 11; j++){
			line[j] = file_text_read_real(file);
		}
		var type = line[0];
		switch (type){
			case 0:
				// ignore this (primitive start)
				break;
			case 1:
				// ignore this (primitive end)
				break;
			case 2:	// vertex position
				var xx = line[1];
				var yy = line[2];
				var zz = line[3];
				model_point_add(model, xx, yy, zz, 0, 0, 0, c_white, 1, 0, 0);
				break;
			case 3:	// vertex position, color
				var xx = line[1];
				var yy = line[2];
				var zz = line[3];
				var color = line[4];
				var alpha = line[5];
				model_point_add(model, xx, yy, zz, 0, 0, 0, color, alpha, 0, 0);
				break;
			case 4:	// vertex position, texture
				var xx = line[1];
				var yy = line[2];
				var zz = line[3];
				var xtex = line[4];
				var ytex = line[5];
				model_point_add(model, xx, yy, zz, 0, 0, 0, c_white, 1, xtex, ytex);
				break;
			case 5:	// vertex position, texture, color
				var xx = line[1];
				var yy = line[2];
				var zz = line[3];
				var xtex = line[4];
				var ytex = line[5];
				var color = line[6];
				var alpha = line[7];
				model_point_add(model, xx, yy, zz, 0, 0, 0, color, alpha, xtex, ytex);
				break;
			case 6:	// vertex position, normal
				var xx = line[1];
				var yy = line[2];
				var zz = line[3];
				var nx = line[4];
				var ny = line[5];
				var nz = line[6];
				model_point_add(model, xx, yy, zz, nx, ny, nz, c_white, 1, 0, 0);
				break;
			case 7:	// vertex position, normal, color
				var xx = line[1];
				var yy = line[2];
				var zz = line[3];
				var nx = line[4];
				var ny = line[5];
				var nz = line[6];
				var color = line[7];
				var alpha = line[8];
				model_point_add(model, xx, yy, zz, nx, ny, nz, color, alpha, 0, 0);
				break;
			case 8:	// vertex position, normal, texture
				var xx = line[1];
				var yy = line[2];
				var zz = line[3];
				var nx = line[4];
				var ny = line[5];
				var nz = line[6];
				var xtex = line[7];
				var ytex = line[8];
				model_point_add(model, xx, yy, zz, nx, ny, nz, xtex, ytex, 0, 0);
				break;
			case 9:	// vertex position, normal, texture, color
				var xx = line[1];
				var yy = line[2];
				var zz = line[3];
				var nx = line[4];
				var ny = line[5];
				var nz = line[6];
				var xtex = line[7];
				var ytex = line[8];
				var color = line[9];
				var alpha = line[10];
				model_point_add(model, xx, yy, zz, nx, ny, nz, color, alpha, xtex, ytex);
				break;
			case 10: // block
				break;
			case 11: // cylinder
				break;
			case 12: // cone
				break;
			case 13: // ellipsoid
				break;
			case 14: // wall
				break;
			case 15: // floor
				break;
		}
	}

	file_text_close(file);
	vertex_end(model);

	return model;
}
function obj_load(_filename)	{
	// Open the file
	var filename = argument0;
	var obj_file = file_text_open_read("Models/" + _filename);

	// Create the vertex buffer
	var model = vertex_create_buffer();
	vertex_begin(model, global.ModelVertexFormat);

	// Create the lists of position/normal/texture data
	var vertex_x = ds_list_create();
	var vertex_y = ds_list_create();
	var vertex_z = ds_list_create();

	var vertex_nx = ds_list_create();
	var vertex_ny = ds_list_create();
	var vertex_nz = ds_list_create();

	var vertex_xtex = ds_list_create();
	var vertex_ytex = ds_list_create();

	// Read each line in the file
	while(not file_text_eof(obj_file)){
		var line = file_text_read_string(obj_file);
		file_text_readln(obj_file);
		// Split each line around the space character
		var terms, index;
		index = 0;
		terms = array_create(string_count(line, " ") + 1, "");
		for (var i = 1; i <= string_length(line); i++){
			if (string_char_at(line, i) == " "){
				index++;
				terms[index] = "";
			} else {
				terms[index] += string_char_at(line, i);
			}
		}
		switch(terms[0]){
			// Add the vertex x, y an z position to their respective lists
			case "v":
				ds_list_add(vertex_x, real(terms[1]));
				ds_list_add(vertex_y, real(terms[2]));
				ds_list_add(vertex_z, real(terms[3]));
				break;
			// Add the vertex x and y texture position (or "u" and "v") to their respective lists
			case "vt":
				ds_list_add(vertex_xtex, real(terms[1]));
				ds_list_add(vertex_ytex, real(terms[2]));
				break;
			// Add the vertex normal's x, y and z components to their respective lists
			case "vn":
				ds_list_add(vertex_nx, real(terms[1]));
				ds_list_add(vertex_ny, real(terms[2]));
				ds_list_add(vertex_nz, real(terms[3]));
				break;
			case "f":
				// Split each term around the slash character
				for (var n = 1; n<= 3; n++){
					var data, index;
					index = 0;
					data = array_create(string_count(terms[n], "/") + 1, "");
					for (var i = 1; i <= string_length(terms[n]); i++){
						if (string_char_at(terms[n], i) == "/"){
							index++;
							data[index] = "";
						} else {
							data[index] += string_char_at(terms[n], i);
						}
					}
					// Look up the x, y, z, normal x, y, z and texture x, y in the already-created lists
					var xx = ds_list_find_value(vertex_x, real(data[0]) - 1);
					var yy = ds_list_find_value(vertex_y, real(data[0]) - 1);
					var zz = ds_list_find_value(vertex_z, real(data[0]) - 1);
					var xtex = ds_list_find_value(vertex_xtex, real(data[1]) - 1);
					var ytex = ds_list_find_value(vertex_ytex, real(data[1]) - 1);
					var nx = ds_list_find_value(vertex_nx, real(data[2]) - 1);
					var ny = ds_list_find_value(vertex_ny, real(data[2]) - 1);
					var nz = ds_list_find_value(vertex_nz, real(data[2]) - 1);
				
					// Optional: swap the y and z positions (useful if you used the default Blender export settings)
					var t = yy;
					yy = zz;
					zz = t;
					// If you do that you'll also need to swap the normals
					var t = ny;
					ny = nz;
					nz = t;
				
					// Add the data to the vertex buffers
					vertex_position_3d(model, xx, yy, zz);
					vertex_normal(model, nx, ny, nz);
					vertex_color(model, c_white, 1);
					vertex_texcoord(model, xtex, ytex);
				}
				break;
			default:
				// There are a few other things you can find in an obj file that I haven't covered here (but may in the future)
				break;
		}
	}

	// End the vertex buffer, destroy the lists, close the text file and return the vertex buffer
	vertex_end(model);
	ds_list_destroy(vertex_x);
	ds_list_destroy(vertex_y);
	ds_list_destroy(vertex_z);
	ds_list_destroy(vertex_nx);
	ds_list_destroy(vertex_ny);
	ds_list_destroy(vertex_nz);
	ds_list_destroy(vertex_xtex);
	ds_list_destroy(vertex_ytex);
	file_text_close(obj_file);
	return model;
}
function model_point_add(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10) {
	vertex_position_3d(argument0, argument1, argument2, argument3);
	vertex_normal(argument0, argument4, argument5, argument6);
	vertex_color(argument0, argument7, argument8);
	vertex_texcoord(argument0, argument9, argument10);
}
function string_wordwrap_width(_string, _width, _break, _split) {
    var pos_space, pos_current, text_current, text_output;
    pos_space = -1;
    pos_current = 1;
    text_current = _string;
    if (is_real(_break)) _break = "#";
    text_output = "";
    while (string_length(text_current) >= pos_current) {
        if (string_width(string_copy(text_current,1,pos_current)) > _width) {
            //if there is a space in this line then we can break there
            if (pos_space != -1) {
                text_output += string_copy(text_current,1,pos_space) + string(_break);
                //remove the text we just looked at from the current text string
                text_current = string_copy(text_current,pos_space+1,string_length(text_current)-(pos_space));
                pos_current = 1;
                pos_space = -1;
            } else if (_split) {
                //if not, we can force line breaks
                text_output += string_copy(text_current,1,pos_current-1) + string(_break);
                //remove the text we just looked at from the current text string
                text_current = string_copy(text_current,pos_current,string_length(text_current)-(pos_current-1));
                pos_current = 1;
                pos_space = -1;
            }
        }
        if (string_char_at(text_current,pos_current) == " ") pos_space = pos_current;
        pos_current += 1;
    }
    if (string_length(text_current) > 0) text_output += text_current;
    return text_output;
}
function lengthdir_z(_len, _angle)	{
	return _len * dtan(_angle);
}
function generic_macros()	{
	#macro x_center mean(bbox_left, bbox_right)
	#macro y_center mean(bbox_top, bbox_bottom)
}