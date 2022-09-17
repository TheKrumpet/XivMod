Config = {
	Buffs = {
		Enabled = false,
		Locked = false
	}
}

function BuffsEnable_Toggle()
	local checked = BuffsEnable:GetChecked();
	
	BuffFrames_Toggle(checked);

	Config.Buffs.Enabled = checked;
end

function BuffFramesLocked_Toggle()
	local locked = LockBuffFrames:GetChecked();
	
	LockFrames_Toggle(locked);

	Config.Buffs.Locked = locked;
end

function DebugEffects_OnClick()
	DevTools_Dump(GetPlayerEffects());
end

function XivModConfig_OnLoad()
	BuffsEnable:SetChecked(Config.Buffs.Enabled);
	LockBuffFrames:SetChecked(Config.Buffs.Locked);
end
