XivMod_Config = {
	Buffs = {
		Enabled = false,
		Locked = false,
		BuffFrameOffset = { point = "CENTER", x = 0, y = 0 },
		DebuffFrameOffset = { point = "CENTER", x = 0, y = 0 },
		TargetBuffFrameOffset  = { point = "CENTER", x = 0, y = 0 },
		TargetDebuffFrameOffset  = { point = "CENTER", x = 0, y = 0 },
	}
};

function XivModConfig_Updated()
	Buffs.ConfigChanged();
end

function XivModConfigScreen_OnLoad(screen)
	screen:SetScript("OnEvent", function(self, event, eventArgs)
		if (event == "ADDON_LOADED" and eventArgs == "XIVMod") then
			XivModConfig_Updated();
		end
	end);

	screen:RegisterEvent("ADDON_LOADED");
end
