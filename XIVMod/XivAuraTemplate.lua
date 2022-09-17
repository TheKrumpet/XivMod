-- Constants
ONE_HOUR = 3600;
ONE_MINUTE = 60;

-- Aura
AURA_SIZE = { x = 26, y = 38 };

-- Aura Icon
AURA_ICON_SUBLAYER = -8;
AURA_ICON_CROP = { left = 0, right = 1, top = 0.01, bottom = 0.99 };
AURA_ICON_BUFF_MASK = [[Interface\AddOns\XIVMod\assets\BuffMask]];
AURA_ICON_DEBUFF_MASK = [[Interface\AddOns\XIVMod\assets\DebuffMask]];

-- Aura Frame
AURA_FRAME_SUBLAYER = -7;
AURA_FRAME_BUFF_TEXTURE = [[Interface\AddOns\XIVMod\assets\BuffFrame]];
AURA_FRAME_DEBUFF_TEXTURE = [[Interface\AddOns\XIVMod\assets\DebuffFrame]];

DISPEL_TYPE_COLOURS = {
	None = { r = 0.0, g = 0.0, b = 0.0 },
	Curse = { r = 1.0, g = 0.0, b = 1.0 },
	Disease = { r = 0.5, g = 0.5, b = 0.0 },
	Magic = { r = 0.0, g = 0.0, b = 1.0 },
	Poison = { r = 0.0, g = 1.0, b = 0.0 }
};

-- Countdown
COUNTDOWN_FONT = "ConsoleFontSmall";
COUNTDOWN_OFFSET = { x = 0.1, y = 0 };
COUNTDOWN_SCALE = 1.0;
COUNTDOWN_COLOUR_PLAYER = { r = 0.7, g = 1.0, b = 0.7 };
COUNTDOWN_COLOUR_OTHER = { r = 1.0, g = 1.0, b = 1.0 };

-- Stacks
STACKS_FONT = "NumberFontNormal";
STACKS_OFFSET = { x = -1, y = 1 };

function XivAura_OnLoad(aura)
	aura:SetSize(AURA_SIZE.x, AURA_SIZE.y);

	aura.texture = aura:CreateTexture(nil, "ARTWORK", nil, AURA_ICON_SUBLAYER);
	aura.texture:SetPoint("TOP");
	aura.texture:SetSize(AURA_SIZE.x, AURA_SIZE.x);
	aura.texture:Show();

	aura.textureFrame = aura:CreateTexture(nil, "ARTWORK", nil, AURA_FRAME_SUBLAYER);
	aura.textureFrame:SetPoint("TOP");
	aura.textureFrame:SetSize(AURA_SIZE.x, AURA_SIZE.x);
	aura.textureFrame:Show();
		
	aura.countdown = aura:CreateFontString(nil, "ARTWORK", COUNTDOWN_FONT);
	aura.countdown:SetPoint("BOTTOM", COUNTDOWN_OFFSET.x, COUNTDOWN_OFFSET.y);
	aura.countdown:SetScale(COUNTDOWN_SCALE);

	aura.stack = aura:CreateFontString(nil, "ARTWORK", STACKS_FONT);
	aura.stack:SetJustifyH("RIGHT");
	aura.stack:SetJustifyV("TOP");
	aura.stack:SetPoint("TOPRIGHT", STACKS_OFFSET.x, STACKS_OFFSET.y);

	aura:RegisterForClicks("RightButtonUp");

	aura.unit = aura:GetParent():GetAttribute("unit");
	aura.filter = aura:GetParent():GetAttribute("filter");
end

function XivAura_OnUpdate(aura)
	local targetText = nil;
	-- Don't update auras if they don't expire.
	if (aura.expires) then
		targetText = GetCountdownUntilExpires(aura.expires);
	end

	if (aura.countdown:GetText() ~= targetText) then
		aura.countdown:SetText(targetText);
	end
end

function XivAura_OnAuraChanged(aura, icon, caster)
	aura.texture:SetTexture(icon);
	aura.texture:SetMask(nil);
	aura.texture:SetTexCoord(AURA_ICON_CROP.left, AURA_ICON_CROP.right, AURA_ICON_CROP.top, AURA_ICON_CROP.bottom);

	if (aura.filter == "HELPFUL") then
		aura.texture:SetMask(AURA_ICON_BUFF_MASK);
		aura.textureFrame:SetTexture(AURA_FRAME_BUFF_TEXTURE);
	else
		aura.texture:SetMask(AURA_ICON_DEBUFF_MASK);
		aura.textureFrame:SetTexture(AURA_FRAME_DEBUFF_TEXTURE);

		if (dispelType == nil) then
			dispelType = "None";
		end
		
		local dispelTypeColour = DISPEL_TYPE_COLOURS[dispelType];
		aura.textureFrame:SetVertexColor(dispelTypeColour.r, dispelTypeColour.g, dispelTypeColour.b);
	end

	if (caster == "player") then
		aura.countdown:SetTextColor(COUNTDOWN_COLOUR_PLAYER.r, COUNTDOWN_COLOUR_PLAYER.g, COUNTDOWN_COLOUR_PLAYER.b);
	else
		aura.countdown:SetTextColor(COUNTDOWN_COLOUR_OTHER.r, COUNTDOWN_COLOUR_OTHER.g, COUNTDOWN_COLOUR_OTHER.b);
	end
end

function XivAura_Render(aura)
	local name, icon, stacks, dispelType, _, expirationTime, caster, _, _, spellId = UnitAura(aura.unit, aura:GetID(), aura.filter);

	if (aura.spellId ~= spellId) then
		XivAura_OnAuraChanged(aura, icon, caster);
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

function XivAura_ShowTooltip(aura)
	GameTooltip:SetOwner(aura, "ANCHOR_TOP");
	GameTooltip:SetFrameLevel(aura:GetFrameLevel() + 2);
	if aura:GetAttribute("target-slot") == 16 or aura:GetAttribute("target-slot") == 17 or aura:GetAttribute("target-slot") == 18 then
		GameTooltip:SetInventoryItem(aura.unit, aura:GetID());
	else
		GameTooltip:SetUnitAura(aura.unit, aura:GetID(), aura.filter);
	end
end

function XivAura_HideTooltip()
	GameTooltip:Hide();
end