--[[ 
This script let's you use mouse gestures for Windows 7 and above. 
To execute a gesture move the mouse pointer while holding the special button:
* up to maximise active window 		(Alt+Space -> x)
* down to minimise active window	(Alt+Space -> n)
* left to move window to the left	(Winkey+Left)
* right to move window to the right	(Winkey+Right)
* don't move to reset the window	(Alt+Space -> w)

Change button_number to your mouse button number
1=M1,2=M2,3=MMB and so on. For G-buttons use their numbers 1:1. 

Change thresholds for x and y to set the distance needed to do a gesture.
--]]

button_number = 20;
threshold_x = 5000;
threshold_y = 8000;


-- inits
pos_x_start, pos_y_start = 0, 0;
pos_x_end, pos_y_end = 0, 0;

show_console_output = 1;
pos_string = "";
diff_string = "";


function OnEvent(event, arg, family)
	if event == "MOUSE_BUTTON_PRESSED" and arg == button_number then
		Sleep(30);
		pos_x_start, pos_y_start = GetMousePosition();
		Sleep(20);
        -- Console output text
		pos_string = "x: " .. pos_x_start .. " y: " .. pos_y_start;
	end

	if  event == "MOUSE_BUTTON_RELEASED" and arg == button_number then
		Sleep(30);
		pos_x_end, pos_y_end = GetMousePosition();
		Sleep(20);
		diff_x = pos_x_end - pos_x_start;
		diff_y = pos_y_start - pos_y_end;
        -- Console output text
        pos_string = "x: " .. pos_x_end .. " y: " .. pos_y_end;
		diff_string = "x: " .. diff_x .. " y: " .. diff_y;

		-- Maximise
		if diff_y > threshold_y then
			PressKey("lalt");
			Sleep(20);
			PressKey("spacebar");
			Sleep(20);
			ReleaseKey("spacebar");
			ReleaseKey("lalt");
			Sleep(20);
			PressAndReleaseKey("x");
			if show_console_output == 1 then
                OutputLogMessage("[MAXIMISE]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
            end
		end
		
		-- Reset
		if math.abs(diff_y) < threshold_y and math.abs(diff_x) < threshold_x  then
			PressKey("lalt");
			Sleep(20);
			PressKey("spacebar");
			Sleep(20);
			ReleaseKey("spacebar");
			ReleaseKey("lalt");
			Sleep(20);
			PressAndReleaseKey("w");
            if show_console_output == 1 then
			    OutputLogMessage("[RESET]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
            end
		end

		-- Minimise
		if diff_y < -threshold_y then
			PressKey("lalt");
			Sleep(20);
			PressKey("spacebar");
			Sleep(20);
			ReleaseKey("spacebar");
			ReleaseKey("lalt");
			Sleep(20);
			PressAndReleaseKey("n");
			PressAndReleaseKey("enter"); -- workaround for Chrome
            if show_console_output == 1 then
                OutputLogMessage("[MINIMISE]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
            end
		end

		-- move to left
		if diff_x < -threshold_x then
			PressKey("lgui");
			Sleep(20);
			PressKey("left");
			Sleep(20);
			ReleaseKey("left");
			ReleaseKey("lgui");
            if show_console_output == 1 then
                OutputLogMessage("[MOVE LEFT]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
            end
		end

		-- move to right
		if diff_x > threshold_x then
			PressKey("lgui");
			Sleep(20);
			PressKey("right");
			Sleep(20);
			ReleaseKey("right");
			ReleaseKey("lgui");
            if show_console_output == 1 then
                OutputLogMessage("[MOVE RIGHT]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
            end
		end		
	end
--OutputLogMessage("event = %s, arg = %s, family=%s\nPosition = %s, Movement= %s \n", event, arg, family,pos_string,diff_string); --debug
end
