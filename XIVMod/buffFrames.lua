local frames = { buffFrame = nil, debuffFrame = nil };

function EnableFrame(frame, offset)
	frame:Show();
	frame:ClearAllPoints();
	frame:SetPoint(offset.point, offset.x, offset.y);
	XivBuffFrameAuras_RenderAuras(frame);
end

function BuffFrames_Toggle(enabled)
	if (enabled) then
		BuffFrame:Hide();

		if (not frames.buffFrame) then
			frames.buffFrame = XivBuffFrame_Create("player", "HELPFUL");
		end

		if (not frames.debuffFrame) then
			frames.debuffFrame = XivBuffFrame_Create("player", "HARMFUL");
		end

		EnableFrame(frames.buffFrame, XivMod_Config.Buffs.BuffFrameOffset);
		EnableFrame(frames.debuffFrame, XivMod_Config.Buffs.DebuffFrameOffset);
	else
		BuffFrame:Show();
		
		frames.buffFrame:Hide();
		frames.debuffFrame:Hide();
	end

	XivMod_Config.Buffs.Enabled = checked;
end

function GetFrameOffset(frame)
	local point, _, _, xOffset, yOffset = frame:GetPoint();
	return { point = point, x = xOffset, y = yOffset };
end

function LockFrames_Toggle(locked)
	if (locked) then
		XivBuffFrame_Lock(frames.buffFrame);
		XivBuffFrame_Lock(frames.debuffFrame);

		XivMod_Config.Buffs.BuffFrameOffset = GetFrameOffset(frames.buffFrame);
		XivMod_Config.Buffs.DebuffFrameOffset = GetFrameOffset(frames.debuffFrame);
		XivMod_Config.Buffs.Locked = true;
	else
		XivBuffFrame_Unlock(frames.buffFrame);
		XivBuffFrame_Unlock(frames.debuffFrame);
		XivMod_Config.Buffs.Locked = false;
	end

	XivMod_Config.Buffs.Locked = locked;
end
