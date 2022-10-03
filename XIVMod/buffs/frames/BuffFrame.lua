local AURA_UPDATE_EVENTS = { "PLAYER_DEAD" };
local AURA_FRAME_OPTS = {}

AURA_FRAME_OPTS[BUFF_FRAME_TYPE.PlayerBuff] = {
	name = "Player Buffs",
	point = "BOTTOMLEFT",
	secure = true,
	attrs = {
		wrapYOffset = AURA_OFFSETS.y,
		xOffset = AURA_OFFSETS.x,
		unit = "player",
		filter = "HELPFUL"
	}
}

AURA_FRAME_OPTS[BUFF_FRAME_TYPE.PlayerDebuff] = {
	name = "Player Debuffs",
	point = "BOTTOMRIGHT",
	secure = false,
	attrs = {
		wrapYOffset = AURA_OFFSETS.y,
		xOffset = -AURA_OFFSETS.x,
		unit = "player",
		filter = "HARMFUL"
	}
}

AURA_FRAME_OPTS[BUFF_FRAME_TYPE.TargetAll] = {
	name = "Target",
	point = "TOPLEFT",
	secure = false,
	attrs = {
		wrapYOffset = -AURA_OFFSETS.y,
		xOffset = AURA_OFFSETS.x,
		unit = "target",
		filter = "INCLUDE_NAME_PLATE_ONLY"
	}
}

AURA_FRAME_OPTS[BUFF_FRAME_TYPE.TargetBuff] = {
	name = "Target Buffs",
	point = "TOPLEFT",
	secure = false,
	attrs = {
		wrapYOffset = -AURA_OFFSETS.y,
		xOffset = AURA_OFFSETS.x,
		unit = "target",
		filter = "HELPFUL"
	}
}

AURA_FRAME_OPTS[BUFF_FRAME_TYPE.TargetDebuff] = {
	name = "Target Debuffs",
	point = "TOPRIGHT",
	secure = false,
	attrs = {
		wrapYOffset = -AURA_OFFSETS.y,
		xOffset = -AURA_OFFSETS.x,
		unit = "target",
		filter = "HARMFUL"
	}
}

local function BuffFrame_Enable(frame, point)
	frame:Show();
	frame:ClearAllPoints();

	if (point) then
		frame:SetPoint(point.point or "CENTER", point.x or 0, point.y or 0);
	else
		frame:SetPoint("CENTER", 0, 0);
	end
end

local function BuffFrame_GetFrameOffset(frame)
	local point, _, _, xOffset, yOffset = frame:GetPoint();

	return { point = point, x = xOffset, y = yOffset };
end

local function BuffFrame_Lock(frame)
	frame:SetMovable(false);
	frame:EnableMouse(false);
	frame.dragFrame:Hide();
end

local function BuffFrame_Unlock(frame)
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame.dragFrame:Show();
end

function BuffFrame_Create(frameType)
	local opts = AURA_FRAME_OPTS[frameType];
	local frame = nil;

	if (opts.secure) then
		frame = CreateFrame("Frame", nil, UIParent, "SecureXivBuffFrame");
	else
		frame = CreateFrame("Frame", nil, UIParent, "XivBuffFrame");
	end

    local dragFrame, auraFrame = frame:GetChildren();
	frame.dragFrame = dragFrame;
	frame.auraFrame = auraFrame;

	frame.Enable = BuffFrame_Enable;
	frame.Lock = BuffFrame_Lock;
	frame.Unlock = BuffFrame_Unlock;
	frame.GetFrameOffset = BuffFrame_GetFrameOffset;
	
	auraFrame:ClearAllPoints();
	auraFrame:SetPoint(opts.point);

	Array_ForEach(AURA_UPDATE_EVENTS, function (eventType)
		frame:RegisterEvent(eventType);
	end);

	if (opts.secure) then
		SecureXivBuffFrame_SetOptions(frame, opts);
	else
		XivBuffFrame_SetOptions(frame, opts);
	end

	auraFrame:Show();
	frame:Show();
	frame:Render();

	return frame;
end