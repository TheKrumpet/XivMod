local function SecureXivBuffFrameAuras_OnEvent(auraFrame)
	if (not auraFrame:IsShown()) then return end;

	for aura_index = 1,40 do
		local aura = auraFrame:GetAttribute("child" .. aura_index);

		if (not aura or not aura:IsShown()) then return end;

		aura:OnAurasChanged();
	end
end

local function SecureXivBuffFrame_Render(frame)
	SecureXivBuffFrameAuras_OnEvent(frame.auraFrame);
end

function SecureXivBuffFrame_SetOptions(frame, opts)
	Table_ForEach(opts.attrs, function (name, value)
		frame.auraFrame:SetAttribute(name, value);
	end);

	frame.auraFrame:SetAttribute("point", opts.point);
	frame.auraFrame:HookScript("OnEvent", SecureXivBuffFrameAuras_OnEvent);
	frame.Render = SecureXivBuffFrame_Render;
end