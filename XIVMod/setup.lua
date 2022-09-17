-- Config
XivModConfigScreen.name = "XIV Mod";
InterfaceOptions_AddCategory(XivModConfigScreen);

function OpenOptions()
	InterfaceOptionsFrame_OpenToCategory(XivModConfigScreen);
	InterfaceOptionsFrame_OpenToCategory(XivModConfigScreen);
end

-- Slash Commands
SLASH_XIVMOD1 = "/xivmod";
SLASH_XIVMOD2 = "/xiv";

SlashCmdList.XIVMOD = function(command)
	if     (command == "")       then OpenOptions();
	elseif (command == "show")   then BuffFrames_Toggle(true);
	elseif (command == "hide")   then BuffFrames_Toggle(false);
	elseif (command == "lock")   then LockFrames_Toggle(true);
	elseif (command == "unlock") then LockFrames_Toggle(false);
	end
end