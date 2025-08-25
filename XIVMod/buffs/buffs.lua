local enabledFrames = { 
	BUFF_FRAME_TYPE.PlayerBuff, 
	BUFF_FRAME_TYPE.PlayerDebuff,
	BUFF_FRAME_TYPE.TargetBuff,
	BUFF_FRAME_TYPE.TargetDebuff
};
local frames = {};

local function Buffs_Toggle(enabled)
	if (enabled) then
		-- BuffFrame:Hide();
		DebuffFrame:Hide();

		Table_ForEach(frames, function (name, frame)
			frame:Enable(XivMod_Config.Buffs.Frames[name]);
		end);
	else
		-- BuffFrame:Show();
		DebuffFrame:Show();

		Array_ForEach(frames, function (frame) 
			frame:Hide(); 
		end);
	end

	XivMod_Config.Buffs.Enabled = enabled;
end

local function Buffs_Lock(locked)
	if (locked) then
		Table_ForEach(frames, function(name, frame) 
			frame:Lock();
			XivMod_Config.Buffs.Frames[name] = frame:GetFrameOffset();
		end);
	else
		Array_ForEach(frames, function(frame) 
			frame:Unlock(); 
		end);
	end

	XivMod_Config.Buffs.Locked = locked;
end

local function Buffs_OnConfigChanged()
	Array_ForEach(enabledFrames, function (frameType)
		frames[frameType] = BuffFrame_Create(frameType);
	end);

	Buffs_Toggle(XivMod_Config.Buffs.Enabled);
	Buffs_Lock(XivMod_Config.Buffs.Locked);
end

Buffs = {
	Toggle = Buffs_Toggle,
	Lock = Buffs_Lock,
	ConfigChanged = Buffs_OnConfigChanged
}