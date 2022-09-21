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
	frame:SetPoint(point.point, point.x, point.y);
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
	auraFrame:ClearAllPoints();

	if (filter == "HELPFUL") then
		auraFrame:SetPoint("BOTTOMLEFT");
		auraFrame:SetAttribute("point", "BOTTOMLEFT");
		auraFrame:SetAttribute("xOffset", "24");
	elseif (filter == "HARMFUL") then
		auraFrame:SetPoint("BOTTOMRIGHT");
		auraFrame:SetAttribute("point", "BOTTOMRIGHT");
		auraFrame:SetAttribute("xOffset", "-24");
	end

	auraFrame:HookScript("OnEvent", XivBuffFrame_OnAurasChanged);

	auraFrame:Show();
	newBuffFrame:Show();
	XivBuffFrame_OnAurasChanged(auraFrame);

	return newBuffFrame;
end