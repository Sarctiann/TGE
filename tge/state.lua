-- related to the state of the running game/s, room/s, etc.
local utils = require("tge.utils")
local utf8 = require("utf8")

-------------------------------------------------------------------------------

local screen_repr = {}
local layers_index = {}
local total_lines = 0

local function init_screen_repr(lines)
	total_lines = lines
end

local function _init_layer()
	local data = {}
	for _ = 1, total_lines do
		table.insert(data, {})
	end
	return data
end

--- Adds a new layer to the screen representation over the previous layers
local function add_layer(layer_name)
	layers_index[layer_name] = #screen_repr + 1
	table.insert(screen_repr, { name = layer_name, data = _init_layer() })
end

--- @param layer_name string | nil
--- @param line integer
--- @param col integer
--- @param unit string
--- @param clear boolean
--- Return the unit that should be printed in the screen
local function resolve_layer(layer_name, line, col, unit, clear)
	local default = string.rep(" ", _UNIT_WIDTH)
	local layer_mode = "bg"
	local element = not clear and unit
	local result

	if #screen_repr == 0 then
		return element or default
	end

	if layer_name then
		if not layers_index[layer_name] then
			utils:exit_with_error("An UI Element is trying to write in a non-existent layer: %s ", layer_name)
		end
		for i = 1, #screen_repr do
			if layer_mode == "cur" then
				layer_mode = "fg"
				result = screen_repr[i].data[line][col] or result
			elseif screen_repr[i].name == layer_name then
				layer_mode = "cur"
				result = element or result
			else
				result = screen_repr[i].data[line][col] or result or default
			end
		end
		screen_repr[layers_index[layer_name]].data[line][col] = element
	else
		for i = 1, #screen_repr do
			result = element or screen_repr[i].data[line][col] or result or default
		end
	end
	return result or default
end

-------------------------------------------------------------------------------

--- Write in the screen checking the given boundaries
--- @param data table<string[]>
--- @param pos Point
--- @param bound Boundaries
--- @param options {clear: boolean | nil, target_layer: string | nil} | nil
local function sprite_puts(data, pos, bound, options)
	local clear = options and options.clear
	local target_layer = options and options.target_layer
	if pos.x <= bound.right and pos.x >= bound.left and pos.y <= bound.bottom and pos.y >= bound.top then
		local fstring = ""
		for i, line in ipairs(data) do
			for j, unit in ipairs(line) do
				local fpos = { x = pos.x + j - 1, y = pos.y + i - 1 }
				local u = resolve_layer(target_layer, fpos.y, fpos.x, unit, clear or false)
				fstring = fstring .. string.format("%s%s", utils.cursor.goTo(_UNITS_TO_CHARS(fpos.x), fpos.y), u)
			end
		end
		utils.console:write(fstring)
	end
end

--- Write in the screen checking the given boundaries
--- @param data string
--- @param from Point
--- @param to Point
--- @param options {color: Color | nil, clear: boolean | nil, target_layer: string | nil} | nil
local function ortogonal_puts(data, from, to, options)
	local color = options and options.color or nil
	local clear = options and options.clear or false
	local target_layer = options and options.target_layer
	local fg = color and color.fg and utils.colors.fg(color.fg) or ""
	local bg = color and color.bg and utils.colors.bg(color.bg) or ""
	local rfg = color and color.fg and utils.colors.resetFg or ""
	local rbg = color and color.bg and utils.colors.resetBg or ""
	-- If is a horizontal line
	if from.y == to.y then
		local line = ""
		for i = 1, to.x - from.x + 1 do
			local fdata = resolve_layer(
				target_layer,
				from.y,
				from.x + (i - 1),
				string.format("%s%s%s%s%s", fg, bg, data, rfg, rbg),
				clear
			)
			line = line .. fdata
		end
		utils.console:write(string.format("%s%s", utils.cursor.goTo(_UNITS_TO_CHARS(from.x), from.y), line))

	-- If is a vertical line
	elseif from.x == to.x then
		for i = from.y, to.y do
			local line =
				resolve_layer(target_layer, i, from.x, string.format("%s%s%s%s%s", fg, bg, data, rfg, rbg), clear)
			utils.console:write(string.format("%s%s", utils.cursor.goTo(_UNITS_TO_CHARS(from.x), i), line))
		end

	-- else is a box
	else
		local line = ""
		for i = 1, to.x - from.x do
			local fdata = resolve_layer(
				target_layer,
				from.y,
				from.x + (i - 1),
				string.format("%s%s%s%s%s", fg, bg, data, rfg, rbg),
				clear
			)
			line = line .. fdata
		end
		local from_x = _UNITS_TO_CHARS(from.x)
		utils.console:write(string.format("%s%s", utils.cursor.goTo(from_x, from.y), line))
		utils.console:write(string.format("%s%s", utils.cursor.goTo(from_x, to.y - 1), line))
		for i = from.y, to.y - 1 do
			line = resolve_layer(target_layer, i, from.x, string.format("%s%s%s%s%s", fg, bg, data, rfg, rbg), clear)
			utils.console:write(string.format("%s%s", utils.cursor.goTo(from_x, i), line))
			utils.console:write(string.format("%s%s", utils.cursor.goTo(_UNITS_TO_CHARS(to.x), i), line))
		end
	end
end

--- Write in the screen checking the given boundaries
--- @param data string | string[]
--- @param pos Point
--- @param bound Boundaries
--- @param options {color: Color | nil, align: boolean | nil, clear: boolean | nil, target_layer: string | nil} | nil
local function puts(data, pos, bound, options)
	local color = options and options.color or nil
	local align = options and options.align or false
	local clear = options and options.clear or false
	local target_layer = options and options.target_layer or nil
	local fg = color and color.fg and utils.colors.fg(color.fg) or ""
	local bg = color and color.bg and utils.colors.bg(color.bg) or ""
	local rfg = color and color.fg and utils.colors.resetFg or ""
	local rbg = color and color.bg and utils.colors.resetBg or ""
	local fpos = pos
	local fdata = {}
	if type(data) == "string" then
		table.insert(fdata, data)
	else
		fdata = { table.unpack(data) }
	end
	if pos.x <= bound.right and pos.x >= bound.left and pos.y <= bound.bottom and pos.y >= bound.top then
		if align then
			if pos.y + #fdata > bound.bottom then
				fpos.y = bound.bottom + 1 - #fdata
			end
		else
			for i, line in ipairs(fdata) do
				if pos.x + _CHARS_TO_UNITS(utf8.len(line) or 0) > bound.right then
					fdata[i] = string.sub(line, 1, _UNITS_TO_CHARS(bound.right - pos.x) + _UNIT_WIDTH)
				end
			end
		end
		for i, line in ipairs(fdata) do
			local x = _UNITS_TO_CHARS(fpos.x)
			local linelen = utf8.len(line) + utf8.len(line) % 2
			if align and pos.x + _CHARS_TO_UNITS(linelen) > bound.right then
				x = _UNITS_TO_CHARS(bound.right) - linelen + _UNIT_WIDTH
			end
			local get_unit = utils.async_split_text_into_units(line)
			local fline = ""
			for j = 1, #line, _UNIT_WIDTH do
				fline = fline
					.. resolve_layer(
						target_layer,
						fpos.y,
						x + (j - 1),
						string.format("%s%s%s%s%s", fg, bg, get_unit(), rfg, rbg),
						clear
					)
			end
			if not align and fpos.y + i > bound.bottom + 1 then
				break
			end
			utils.console:write(string.format("%s%s", utils.cursor.goTo(x, fpos.y + i - 1), fline))
		end
	end
end

return {
	add_layer = add_layer,
	init_screen_repr = init_screen_repr,
	ortogonal_puts = ortogonal_puts,
	sprite_puts = sprite_puts,
	puts = puts,
}
