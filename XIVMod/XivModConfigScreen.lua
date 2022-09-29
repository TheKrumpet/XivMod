XivMod_Config = {
	Buffs = {
		Enabled = false,
		Locked = false,
		Frames = {}
	}
};


function XivModConfig_Version()
	if (not XivMod_Config.Buffs.Frames) then
		XivMod_Config.Buffs.Frames = {}
	end
end

function XivModConfig_Updated()
	Buffs.ConfigChanged();
end

function XivModConfigScreen_OnLoad(screen)
	screen:SetScript("OnEvent", function(self, event, eventArgs)
		if (event == "ADDON_LOADED" and eventArgs == "XIVMod") then
			XivModConfig_Version();
			XivModConfig_Updated();
		end
	end);

	screen:RegisterEvent("ADDON_LOADED");
end
