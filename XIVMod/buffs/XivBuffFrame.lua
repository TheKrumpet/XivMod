local AURA_UPDATE_EVENTS = { };
local AURA_FRAME_OPTS = {}

AURA_FRAME_OPTS[BUFF_FRAME_TYPE.PlayerBuff] = {
	name = "Player Buffs",
	point = "BOTTOMLEFT",
	events = {},
	attrs = {
		wrapYOffset = AURA_OFFSETS.y,
		xOffset = AURA_OFFSETS.x,
		unit = "player",
		filter = "HELPFUL",
		template = "XivSecureAuraTemplate"
	}
}

AURA_FRAME_OPTS[BUFF_FRAME_TYPE.PlayerDebuff] = {
	name = "Player Debuffs",
	point = "BOTTOMRIGHT",
	events = {}, 
	attrs = {
		wrapYOffset = AURA_OFFSETS.y,
		xOffset = -AURA_OFFSETS.x,
		unit = "player",
		filter = "HARMFUL",
		template = "XivAuraTemplate"
	}
}

AURA_FRAME_OPTS[BUFF_FRAME_TYPE.TargetAll] = {
	name = "Target",
	point = "TOPLEFT",
	events = { "PLAYER_TARGET_CHANGED" },
	attrs = {
		wrapYOffset = -AURA_OFFSETS.y,
		xOffset = AURA_OFFSETS.x,
		unit = "target",
		filter = "INCLUDE_NAME_PLATE_ONLY",
		template = "XivAuraTemplate"
	}
}

AURA_FRAME_OPTS[BUFF_FRAME_TYPE.TargetBuff] = {
	name = "Target Buffs",
	point = "TOPLEFT",
	events = { "PLAYER_TARGET_CHANGED" },
	attrs = {
		wrapYOffset = -AURA_OFFSETS.y,
		xOffset = AURA_OFFSETS.x,
		unit = "target",
		filter = "HELPFUL",
		template = "XivAuraTemplate"
	}
}

AURA_FRAME_OPTS[BUFF_FRAME_TYPE.TargetDebuff] = {
	name = "Target Debuffs",
	point = "TOPRIGHT",
	events = { "PLAYER_TARGET_CHANGED" },
	attrs = {
		wrapYOffset = -AURA_OFFSETS.y,
		xOffset = -AURA_OFFSETS.x,
		unit = "target",
		filter = "HARMFUL",
		template = "XivAuraTemplate"
	}
}

local function XivBuffFrame_OnAurasChanged(auraFrame, event, args)
	if (event ~= "UNIT_AURA") then
		if (not InCombatLockdown()) then
			SecureAuraHeader_Update(auraFrame);
		end
	end

	if (not auraFrame:IsShown()) then return end;

	for aura_index = 1,40 do
		local aura = auraFrame:GetAttribute("child" .. aura_index);

		if (not aura or not aura:IsShown()) then return end;

		aura:OnAurasChanged(aura);
	end
end

local function XivBuffFrame_Enable(frame, point)
	frame:Show();
	frame:ClearAllPoints();

	if (point) then
		frame:SetPoint(point.point or "CENTER", point.x or 0, point.y or 0);
	else
		frame:SetPoint("CENTER", 0, 0);
	end
end

local function XivBuffFrame_GetFrameOffset(frame)
	local point, _, _, xOffset, yOffset = frame:GetPoint();

	return { point = point, x = xOffset, y = yOffset };
end

local function XivBuffFrame_Lock(frame)
	frame:SetMovable(false);
	frame:EnableMouse(false);
	frame.dragFrame:Hide();
end

local function XivBuffFrame_Unlock(frame)
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame.dragFrame:Show();
end

function XivBuffFrame_Create(frameType)
	local opts = AURA_FRAME_OPTS[frameType];

	local newBuffFrame = CreateFrame("Frame", nil, UIParent, "XivBuffFrame");
	local dragFrame, auraFrame = newBuffFrame:GetChildren();
	newBuffFrame.dragFrame = dragFrame;
	newBuffFrame.auraFrame = auraFrame;

	newBuffFrame.Enable = XivBuffFrame_Enable;
	newBuffFrame.Lock = XivBuffFrame_Lock;
	newBuffFrame.Unlock = XivBuffFrame_Unlock;
	newBuffFrame.GetFrameOffset = XivBuffFrame_GetFrameOffset;

	Array_ForEachKeyValue(opts.attrs, function (name, value)
		auraFrame:SetAttribute(name, value);
	end);

	auraFrame:ClearAllPoints();
	auraFrame:SetPoint(opts.point);
	auraFrame:SetAttribute("point", opts.point);

	Array_ForEach(AURA_UPDATE_EVENTS, function (eventType)
		auraFrame:RegisterEvent(eventType);
	end);

	Array_ForEach(opts.events, function (eventType)
		auraFrame:RegisterEvent(eventType);
	end);

	auraFrame:HookScript("OnEvent", XivBuffFrame_OnAurasChanged);

	auraFrame:Show();
	newBuffFrame:Show();
	XivBuffFrame_OnAurasChanged(auraFrame);

	return newBuffFrame;
end