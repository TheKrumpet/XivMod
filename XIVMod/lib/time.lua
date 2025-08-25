local ONE_DAY = 86400;
local ONE_HOUR = 3600;
local ONE_MINUTE = 60;

function GetCountdown(secsRemaining)
	if (secsRemaining >= ONE_DAY) then
		local daysRemaining = math.floor(secsRemaining / ONE_DAY);
		return daysRemaining .. "d";
	elseif (secsRemaining >= ONE_HOUR) then
		local hoursRemaining = math.floor(secsRemaining / ONE_HOUR);
		return hoursRemaining .. "h";
	elseif (secsRemaining >= ONE_MINUTE) then
		local minsRemaining = math.floor(secsRemaining / ONE_MINUTE);
		return minsRemaining .. "m";
	else
		local secsRemaining = math.floor(secsRemaining);
		-- It looks a little nicer if we don't render the 0 that sometimes appears for the last couple frames.
		if (secsRemaining == 0) then
			return nil;
		end

		return tostring(secsRemaining);
	end
end

function GetCountdownUntilExpires(expirationTime, currentTime)
	local secsRemaining = (expirationTime - currentTime) + 1;
	return GetCountdown(secsRemaining);
end