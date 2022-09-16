Config = {
	Buffs = {
		Enabled = false
	}
}

function BuffsEnable_Toggle()
	local checked = BuffsEnable:GetChecked();
	
	BuffFrames_Toggle(checked);
end

function BuffFramesLocked_Toggle()
	local locked = LockBuffFrames:GetChecked();
	
	LockFrames_Toggle(locked);
end

function DebugEffects_OnClick()
	DevTools_Dump(GetPlayerEffects());
end

function XivModConfig_OnLoad()
	BuffsEnable:SetChecked(Config.Buffs.Enabled);
end
