/// @desc calculates x and y positions of a joint in relation to another joint. Tothether, these form a segment
/// @func seg_calculate(seg, x, y);
/// @arg seg	the index of the segment to calculate the position of
/// @arg x		the x position to calculate against
/// @arg y		the y position to calculate against
function seg_calculate() {

	var tony_sid = argument[0],
		tony_nsx = argument[1], 
		tony_nsy = argument[2];
	
	if (tony_sid < 0 || tony_sid > seg_amount) show_error("segment index out of range: seg[" + string(tony_sid) + "], seg_amount = " + string(seg_amount), true);
	
	var tony_dir = point_direction(seg_x[tony_sid], seg_y[tony_sid], tony_nsx, tony_nsy),
		tony_len = seg_len[tony_sid];
	
	if (tony_dir != tony_len) {
		var tony_ldx = lengthdir_x(tony_len, tony_dir),
			tony_ldy = lengthdir_y(tony_len, tony_dir);
	
		seg_x[@ tony_sid] = tony_nsx - tony_ldx;
		seg_y[@ tony_sid] = tony_nsy - tony_ldy;
	}


}
