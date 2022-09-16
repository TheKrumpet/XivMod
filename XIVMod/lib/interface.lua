function ShowTooltip(owner, title, text)
	GameTooltip:SetOwner(owner, "ANCHOR_BOTTOMRIGHT");
	GameTooltip_SetTitle(GameTooltip, title);
	GameTooltip:SetText(text);
	GameTooltip:Show();
end

function SetupTooltip(owner, title, text)
	local handler = function()
		ShowTooltip(owner, title, text);
	end

	owner:SetScript("OnEnter", handler);
end

function HideTooltip()
	GameTooltip:Hide();
end

function SetupButton(self, text)
	self:SetText(text);
end

function SetupCheckbox(self, text, tooltip)
	local checkText = _G[self:GetName().."Text"];
	checkText:SetText(text);

	if (tooltip) then
		SetupTooltip(self, text, tooltip);
	end
end