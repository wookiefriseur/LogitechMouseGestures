--[[
Author:		Mat
Version:	1.1 
Date: 		2015-12-17

This script let's you use simple mouse gestures for Windows 7 and above.
The gestures use before and after comparisons of mouse pointer positions.

To execute a gesture move the mouse pointer while holding the special button:
* up to maximise active window 		(Alt+Space -> x)
* down to minimise active window	(Alt+Space -> n)
* left to move window to the left	(Winkey+Left)
* right to move window to the right	(Winkey+Right)
* if enabled: don't move to reset the window	(Alt+Space -> w)

Mouse buttons:
1=M1,2=M2,3=MMB and so on. For G-buttons use their respective numbers 1:1. 
--]]

button_number = 20; -- Change to your mouse button number
threshold_x = 5000; -- Change thresholds for x and y to set
threshold_y = 8000; -- the min distance needed for a gesture
show_console_output = false;

-- enable / disable gestures
rst_on = false;		-- reset window
max_on = true;		-- maximise window
min_on = true;		-- minimise window
left_on = true;		-- move to left
right_on = true;	-- move to right

-- inits
pos_x_start, pos_y_start = 0, 0;
pos_x_end, pos_y_end = 0, 0;
pos_string = "";
diff_string = "";

-- Event listener
function OnEvent(event, arg, family)
	if event == "MOUSE_BUTTON_PRESSED" and arg == button_number then
		Sleep(30);
		pos_x_start, pos_y_start = GetMousePosition();
		Sleep(20);
        -- Console output text
		pos_string = "x: " .. pos_x_start .. " y: " .. pos_y_start;
	end

	if event == "MOUSE_BUTTON_RELEASED" and arg == button_number then
		Sleep(30);
		pos_x_end, pos_y_end = GetMousePosition();
		Sleep(20);
		diff_x = pos_x_end - pos_x_start;
		diff_y = pos_y_start - pos_y_end;
        -- Console output text
        pos_string = "x: " .. pos_x_end .. " y: " .. pos_y_end;
		diff_string = "x: " .. diff_x .. " y: " .. diff_y;

		-- Gestures
		if rst_on and math.abs(diff_y) < threshold_y and math.abs(diff_x) < threshold_x  then gestureReset() end
		if max_on and diff_y > threshold_y then gestureMaximise() end
		if min_on and diff_y < -threshold_y then gestureMinimise() end
		if left_on and diff_x < -threshold_x then gestureMoveleft() end
		if right_on and diff_x > threshold_x then gestureMoveright() end		
	end
--OutputLogMessage("event = %s, arg = %s, family=%s\nPosition = %s, Movement= %s \n", event, arg, family,pos_string,diff_string); --debug
end

-- Gesture actions
function gestureMaximise()
	pressTwoKeys("lalt","spacebar",20);
	PressAndReleaseKey("x");
	if show_console_output then
     	OutputLogMessage("[MAXIMISE]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
     end
end

function gestureReset()
	pressTwoKeys("lalt","spacebar",20);
	PressAndReleaseKey("w");
     if show_console_output then
		OutputLogMessage("[RESET]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureMinimise()
	pressTwoKeys("lalt","spacebar",20);
	PressAndReleaseKey("n");
	PressAndReleaseKey("enter"); -- workaround for Chrome
     if show_console_output then
     	OutputLogMessage("[MINIMISE]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureMoveleft()
	pressTwoKeys("lgui","left",20);
    	if show_console_output then
     	OutputLogMessage("[MOVE LEFT]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gestureMoveright()
	pressTwoKeys("lgui","right",20);
     if show_console_output then
     	OutputLogMessage("[MOVE RIGHT]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

-- Helper functions
function pressTwoKeys(key1,key2,ms)
	PressKey(key1);
	Sleep(ms);
	PressKey(key2);
	Sleep(ms);
	ReleaseKey(key2);
	ReleaseKey(key1);
end
