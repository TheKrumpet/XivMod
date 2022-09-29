function Array_ForEach(array, func)
	for index, value in pairs(array) do
		func(value);
	end
end

function Array_KeyOf(array, val)
	for key, value in pairs(array) do
		if (value == val) then
			return key;
		end
	end

	return 0;
end

function Array_IndexOf(array, val)
	for index, value in ipairs(array) do
		if (value == val) then
			return index;
		end
	end

	return 0;
end

function Array_Contains(array, val)
	return Array_IndexOf(array, val) > 0;
end

function Array_ForEachKeyValue(array, func)
	for key, value in pairs(array) do
		func(key, value);
	end
end