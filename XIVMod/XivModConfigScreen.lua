XivMod_Config = {
	Buffs = {
		Enabled = false,
		Locked = false,
		BuffFrameOffset = { point = "CENTER", x = 0, y = 0 },
		DebuffFrameOffset = { point = "CENTER", x = 0, y = 0 }
	}
};

function BuffsEnable_Toggle()
	local checked = BuffsEnable:GetChecked();
	
	Buffs.Toggle(checked);

end

function BuffFramesLocked_Toggle()
	local locked = LockBuffFrames:GetChecked();
	
	LockFrames_Toggle(locked);
end


function XivModConfig_InitialiseFromConfig()
	Buffs.Toggle(true);

	if (not XivMod_Config.Buffs.Enabled) then
		Buffs.Toggle(false);
	end

	if (XivMod_Config.Buffs.Locked) then
		Buffs.Lock(true);
	end
end

function XivModConfigScreen_OnShow()
	BuffsEnable:SetChecked(XivMod_Config.Buffs.Enabled);
	LockBuffFrames:SetChecked(XivMod_Config.Buffs.Locked);
end

function XivModConfigScreen_OnLoad(screen)
	screen:SetScript("OnEvent", function(self, event, eventArgs)
		if (event == "ADDON_LOADED" and eventArgs == "XIVMod") then
			XivModConfig_InitialiseFromConfig();
		end
	end);

	screen:RegisterEvent("ADDON_LOADED");
end
