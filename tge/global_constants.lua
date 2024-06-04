--- @alias UNIT_WIDTH 1 | 2

--- This global constant is used to set the weight of a unit.
--- @type UNIT_WIDTH
_UNIT_WIDTH = 2 -- Default value for normal fonts

--- Converts X position from screen chars to units
--- @param pos integer the X position in characters
_CHARS_TO_UNITS = function(pos)
	return math.ceil(pos / _UNIT_WIDTH)
end

--- Converts X position from units to screen chars
--- @param pos integer the X position in units
_UNITS_TO_CHARS = function(pos)
	return pos * _UNIT_WIDTH - (_UNIT_WIDTH - 1)
end
