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

SlashCmdList.XIVMOD = function(command)
	if     (command == "")       then OpenOptions();
	elseif (command == "show")   then BuffFrames_Toggle(true);
	elseif (command == "hide")   then BuffFrames_Toggle(true);
	elseif (command == "lock")   then LockFrames_Toggle(true);
	elseif (command == "unlock") then LockFrames_Toggle(false);
	end
end