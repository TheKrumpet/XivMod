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
	elseif (command == "show")   then Buffs.Toggle(true);
	elseif (command == "hide")   then Buffs.Toggle(false);
	elseif (command == "lock")   then Buffs.Lock(true);
	elseif (command == "unlock") then Buffs.Lock(false);
	end
end