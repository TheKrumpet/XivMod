function BuffsEnable_Toggle(self)
	local checked = self:GetChecked();
	Buffs.Toggle(checked);
end

function BuffFramesLocked_Toggle(self)
	local locked = self:GetChecked();
	Buffs.Lock(locked);
end

function XivBuffsConfig_OnShow()
	BuffsEnable:SetChecked(XivMod_Config.Buffs.Enabled);
	LockBuffFrames:SetChecked(XivMod_Config.Buffs.Locked);
end
