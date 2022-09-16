DEV_MODE = true;

-- Config
XivModConfig.name = "XIV Mod";
InterfaceOptions_AddCategory(XivModConfig);

function OpenOptions()
	InterfaceOptionsFrame_OpenToCategory(XivModConfig);
	InterfaceOptionsFrame_OpenToCategory(XivModConfig);
end

-- Slash Commands
SLASH_XIVMOD1 = "/xivmod";
SLASH_XIVMOD2 = "/xiv";

SlashCmdList.XIVMOD = function()
	OpenOptions();
end

-- Dev
if (DEV_MODE) then
	OpenOptions();
end

frames = nil;