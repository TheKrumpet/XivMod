-- Aura
local AURA_ICON_OFFSET = -6;

-- Aura Icon
local AURA_ICON_SUBLAYER = -8;
local AURA_ICON_CROP = { left = 0, right = 1, top = 0.01, bottom = 0.99 };
local AURA_ICON_BUFF_MASK = [[Interface\AddOns\XIVMod\assets\BuffMask]];
local AURA_ICON_DEBUFF_MASK = [[Interface\AddOns\XIVMod\assets\DebuffMask]];

-- Aura Frame
local AURA_FRAME_SUBLAYER = -7;
local AURA_FRAME_BUFF_TEXTURE = [[Interface\AddOns\XIVMod\assets\BuffFrame]];
local AURA_FRAME_DEBUFF_TEXTURE = [[Interface\AddOns\XIVMod\assets\DebuffFrame]];

-- Cleanse
local AURA_CLEANSE_SUBLAYER = -7;
local AURA_CLEANSE_TEXTURE = [[Interface\AddOns\XIVMod\assets\CleanseMarker]];

local DISPEL_TYPE_COLOURS = {
	Curse = { r = 1.0, g = 0.3, b = 1.0 },
	Disease = { r = 0.9, g = 0.4, b = 0.0 },
	Magic = { r = 0.3, g = 0.7, b = 1.0 },
	Poison = { r = 0.0, g = 1.0, b = 0.0 }
};

-- Countdown
local COUNTDOWN_FONT = "ConsoleFontSmall";
local COUNTDOWN_OFFSET = { x = 1.05, y = 0 };
local COUNTDOWN_SCALE = 1.0;
local COUNTDOWN_COLOUR_PLAYER = { r = 0.7, g = 1.0, b = 0.7 };
local COUNTDOWN_COLOUR_OTHER = { r = 1.0, g = 1.0, b = 1.0 };

-- Stacks
local STACKS_FONT = "NumberFontNormal";
local STACKS_OFFSET = { x = -2.5, y = -5 };

local function XivAura_OnUpdate(aura)
	local targetText = nil;
	-- Don't update auras if they don't expire.
	if (aura.expires) then
		targetText = GetCountdownUntilExpires(aura.expires);
	end

	if (aura.countdown:GetText() ~= targetText) then
		aura.countdown:SetText(targetText);
	end
end

local function XivAura_OnAuraChanged(aura, icon, dispelType, caster)
	aura.texture:SetTexture(icon);
	aura.texture:SetMask(nil);
	aura.texture:SetTexCoord(AURA_ICON_CROP.left, AURA_ICON_CROP.right, AURA_ICON_CROP.top, AURA_ICON_CROP.bottom);

	if (aura.filter == "HELPFUL") then
		aura.texture:SetMask(AURA_ICON_BUFF_MASK);
		aura.textureFrame:SetTexture(AURA_FRAME_BUFF_TEXTURE);
	else
		aura.texture:SetMask(AURA_ICON_DEBUFF_MASK);
		aura.textureFrame:SetTexture(AURA_FRAME_DEBUFF_TEXTURE);

		if (dispelType == nil or dispelType == "") then
			aura.cleanse:Hide();
		else
			local dispelTypeColour = DISPEL_TYPE_COLOURS[dispelType];
			aura.cleanse:SetVertexColor(dispelTypeColour.r, dispelTypeColour.g, dispelTypeColour.b);
			aura.cleanse:Show();
		end
	end

	if (caster == "player") then
		aura.countdown:SetTextColor(COUNTDOWN_COLOUR_PLAYER.r, COUNTDOWN_COLOUR_PLAYER.g, COUNTDOWN_COLOUR_PLAYER.b);
	else
		aura.countdown:SetTextColor(COUNTDOWN_COLOUR_OTHER.r, COUNTDOWN_COLOUR_OTHER.g, COUNTDOWN_COLOUR_OTHER.b);
	end
end

local function XivAura_OnAurasChanged(aura)
	local name, icon, stacks, dispelType, _, expirationTime, caster, _, _, spellId = UnitAura(aura.unit, aura:GetID(), aura.filter);

	if (aura.spellId ~= spellId) then
		XivAura_OnAuraChanged(aura, icon, dispelType, caster);
		aura.spellId = spellId;
	end

	if (expirationTime == 0) then
		aura.expires = nil;
	else
		aura.expires = expirationTime;
	end

	if (stacks == 0) then
		aura.stack:SetText(nil);
	else
		aura.stack:SetText(stacks);
	end
end

local function XivAura_ShowTooltip(aura)
	GameTooltip:SetOwner(aura, "ANCHOR_TOP");
	GameTooltip:SetFrameLevel(aura:GetFrameLevel() + 2);
	if aura:GetAttribute("target-slot") == 16 or aura:GetAttribute("target-slot") == 17 or aura:GetAttribute("target-slot") == 18 then
		GameTooltip:SetInventoryItem(aura.unit, aura:GetID());
	else
		GameTooltip:SetUnitAura(aura.unit, aura:GetID(), aura.filter);
	end
end

local function XivAura_HideTooltip()
	GameTooltip:Hide();
end

function XivAura_OnLoad(aura)
	aura.texture = aura:CreateTexture(nil, "ARTWORK", nil, AURA_ICON_SUBLAYER);
	aura.texture:SetPoint("TOP", 0, AURA_ICON_OFFSET);
	aura.texture:SetSize(AURA_SIZE.x, AURA_SIZE.x);
	aura.texture:Show();

	aura.textureFrame = aura:CreateTexture(nil, "ARTWORK", nil, AURA_FRAME_SUBLAYER);
	aura.textureFrame:SetPoint("TOP", 0, AURA_ICON_OFFSET);
	aura.textureFrame:SetSize(AURA_SIZE.x, AURA_SIZE.x);
	aura.textureFrame:Show();

	aura.cleanse = aura:CreateTexture(nil, "ARTWORK", nil, AURA_CLEANSE_SUBLAYER);
	aura.cleanse:SetTexture(AURA_CLEANSE_TEXTURE);
	aura.cleanse:SetSize(AURA_SIZE.x, AURA_SIZE.x);
	aura.cleanse:SetPoint("TOP");
	aura.cleanse:Hide();
		
	aura.countdown = aura:CreateFontString(nil, "ARTWORK", COUNTDOWN_FONT);
	aura.countdown:SetPoint("BOTTOM", COUNTDOWN_OFFSET.x, COUNTDOWN_OFFSET.y);
	aura.countdown:SetScale(COUNTDOWN_SCALE);
	aura.countdown:SetJustifyH("CENTER");

	aura.stack = aura:CreateFontString(nil, "ARTWORK", STACKS_FONT);
	aura.stack:SetJustifyH("RIGHT");
	aura.stack:SetJustifyV("TOP");
	aura.stack:SetPoint("TOPRIGHT", STACKS_OFFSET.x, STACKS_OFFSET.y);

	aura:RegisterForClicks("RightButtonUp");

	aura.unit = aura:GetParent():GetAttribute("unit");
	aura.filter = aura:GetParent():GetAttribute("filter");

	aura:HookScript("OnUpdate", XivAura_OnUpdate);
	aura:HookScript("OnEnter", XivAura_ShowTooltip);
	aura:HookScript("OnLeave", XivAura_HideTooltip);

	aura.OnAurasChanged = XivAura_OnAurasChanged;
end