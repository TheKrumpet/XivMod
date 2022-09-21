local frames = {
	buffFrame = nil,
	debuffFrame = nil
}

local function Buffs_Toggle(enabled)
	if (enabled) then
		BuffFrame:Hide();

		frames.buffFrame:Enable(XivMod_Config.Buffs.BuffFrameOffset);
		frames.debuffFrame:Enable(XivMod_Config.Buffs.DebuffFrameOffset);
	else
		BuffFrame:Show();

		frames.buffFrame:Hide();
		frames.debuffFrame:Hide();
	end

	XivMod_Config.Buffs.Enabled = enabled;
end

local function Buffs_Lock(locked)
	if (locked) then
		frames.buffFrame:Lock();
		frames.debuffFrame:Lock();

		XivMod_Config.Buffs.BuffFrameOffset = frames.buffFrame:GetFrameOffset();
		XivMod_Config.Buffs.DebuffFrameOffset = frames.debuffFrame:GetFrameOffset();
	else
		frames.buffFrame:Unlock();
		frames.debuffFrame:Unlock()
	end

	XivMod_Config.Buffs.Locked = locked;
end

local function Buffs_OnConfigChanged()
	if (not frames.buffFrame) then
		frames.buffFrame = XivBuffFrame_Create("player", "HELPFUL");
	end

	if (not frames.debuffFrame) then
		frames.debuffFrame = XivBuffFrame_Create("player", "HARMFUL");
	end

	Buffs_Toggle(XivMod_Config.Buffs.Enabled);
	Buffs_Lock(XivMod_Config.Buffs.Locked);
end

Buffs = {
	Toggle = Buffs_Toggle,
	Lock = Buffs_Lock,
	ConfigChanged = Buffs_OnConfigChanged
}