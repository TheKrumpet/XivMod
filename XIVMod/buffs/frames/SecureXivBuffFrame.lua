local function SecureXivBuffFrameAuras_OnEvent(auraFrame)
	if (not auraFrame:IsShown()) then return end;

	Array_ForEach({ auraFrame:GetChildren() }, function (aura)
		if (aura:IsShown()) then
			aura:OnAurasChanged();
		end
	end);
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