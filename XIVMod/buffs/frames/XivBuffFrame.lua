local function XivBuffFrame_CreateNewFrame(auraFrame, index, opts)
    childFrame = CreateFrame("Frame", nil, auraFrame, "XivAuraTemplate");
    local wrapAfter = opts.attrs.wrapAfter or 10;

    -- It's easier to do the math with a zero-based index.
    local zeroed_index = index - 1;

    local wrap = math.floor(zeroed_index / wrapAfter);
    local wrap_index = zeroed_index % wrapAfter;

    local wrapXOffset = opts.attrs.wrapXOffset or 0;
    local wrapYOffset = opts.attrs.wrapYOffset or AURA_OFFSETS.y;
    local xOffset = opts.attrs.xOffset or AURA_OFFSETS.x;
    local yOffset = opts.attrs.yOffset or 0;

    local x = (wrap * wrapXOffset) + (wrap_index * xOffset);
    local y = (wrap * wrapYOffset) + (wrap_index * yOffset);

    local point = opts.point or "BOTTOMLEFT";

    childFrame:ClearAllPoints();
    childFrame:SetPoint(point, x, y);

    return childFrame;
end

local function XivBuffFrameAuras_OnEvent(auraFrame)
    local auras = {};
    local opts = auraFrame.opts;

    for aura_index = 1,40 do
        local addAura = true;
        local name, _, _, _, duration, expirationTime, caster = UnitAura(opts.attrs.unit, aura_index, opts.attrs.filter);

        if (not name) then break end;

        if (opts.maxDuration and (expirationTime == 0 or duration >= opts.maxDuration)) then
            addAura = false;
        end

        if (addAura and (opts.playerOnly and caster ~= "player")) then
            addAura = false
        end

        if (addAura) then
            table.insert(auras, { id = aura_index, expirationTime = expirationTime, caster = caster });
        end
    end

    table.sort(auras, function (left, right)
        if (opts.attrs.seperateOwn) then
            if (left.caster == "player" and right.caster ~= "player") then
                return true;
            end
        end
    end);

    local childFrames = { auraFrame:GetChildren() };
    local allAurasRendered = false;
    local index = 1;

    repeat
        local aura = auras[index];
        local childFrame = childFrames[index];

        if (aura) then 
            if (not childFrame) then
                childFrame = XivBuffFrame_CreateNewFrame(auraFrame, index, opts);
            end

            childFrame:SetID(aura.id);
            childFrame:OnAurasChanged();
            childFrame:Show();
        else
            if (childFrame) then
                childFrame:Hide();
            else
                allAurasRendered = true;
            end
        end;

        index = index + 1;
    until (allAurasRendered);
end

local function XivBuffFrame_Render(frame)
    XivBuffFrameAuras_OnEvent(frame.auraFrame);
end

function XivBuffFrame_SetOptions(frame, opts)
    frame.auraFrame.opts = opts;
    frame.auraFrame:SetAttribute("unit", opts.attrs.unit);
    frame.auraFrame:SetAttribute("filter", opts.attrs.filter);

    frame.auraFrame:HookScript("OnEvent", XivBuffFrameAuras_OnEvent);
    frame.auraFrame:RegisterEvent("UNIT_AURA");
    frame.auraFrame:RegisterEvent("PLAYER_TARGET_CHANGED");

    frame.Render = XivBuffFrame_Render;
end
