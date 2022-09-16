local frames = {};

function BuffFrames_Toggle(enabled)
	Config.Buffs.Enabled = enabled;

	if (enabled) then
		BuffFrame:Hide();

		if (frames[1]) then
			frames[1]:Show();
		else
			frames[1] = XivBuffFrame_Create("player", "HELPFUL");
		end
		
		if (frames[2]) then
			frames[2]:Show();
		else
			frames[2] = XivBuffFrame_Create("player", "HARMFUL");
		end
	else
		BuffFrame:Show();
		
		for index, frame in ipairs(frames) do
			frame:Hide();
		end
	end
end

function LockFrames_Toggle(locked)
	for index, frame in ipairs(frames) do
		if (locked) then
			XivBuffFrame_Lock(frame);
		else
			XivBuffFrame_Unlock(frame);
		end
	end
end