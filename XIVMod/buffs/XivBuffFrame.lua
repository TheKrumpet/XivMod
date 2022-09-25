local function XivBuffFrame_OnAurasChanged(auraFrame)
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

function XivBuffFrame_Create(unit, filter)
	local newBuffFrame = CreateFrame("Frame", "XivBuffFrame", UIParent, "XivBuffFrame");
	local dragFrame, auraFrame = newBuffFrame:GetChildren();
	newBuffFrame.dragFrame = dragFrame;
	newBuffFrame.auraFrame = auraFrame;

	newBuffFrame.Enable = XivBuffFrame_Enable;
	newBuffFrame.Lock = XivBuffFrame_Lock;
	newBuffFrame.Unlock = XivBuffFrame_Unlock;
	newBuffFrame.GetFrameOffset = XivBuffFrame_GetFrameOffset;

	auraFrame:SetAttribute("unit", unit);
	auraFrame:SetAttribute("filter", filter);
	local auraFramePoint = "";

	if (unit == "player") then
		auraFrame:SetAttribute("wrapYOffset", "45");
		auraFramePoint = "BOTTOM";
	elseif (unit == "target") then
		auraFrame:SetAttribute("wrapYOffset", "-45");
		auraFramePoint = "TOP";
		auraFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
	end

	if (filter == "HELPFUL") then
		auraFrame:SetAttribute("xOffset", "24");
		auraFramePoint = auraFramePoint.."LEFT";
	elseif (filter == "HARMFUL") then
		auraFrame:SetAttribute("xOffset", "-24");
		auraFramePoint = auraFramePoint.."RIGHT";
	end

	auraFrame:ClearAllPoints();
	auraFrame:SetAttribute("point", auraFramePoint);
	auraFrame:SetPoint(auraFramePoint);

	auraFrame:HookScript("OnEvent", XivBuffFrame_OnAurasChanged);

	auraFrame:Show();
	newBuffFrame:Show();
	XivBuffFrame_OnAurasChanged(auraFrame);

	return newBuffFrame;
end