-- related to the state of the running game/s, room/s, etc.
local utils = require("tge.utils")

-------------------------------------------------------------------------------
-- TODO: Complete and Test all this
-- Implementing the `target` param to the put methods and updating the `clear` section
-- Implementing the `layer` attr to the base_ui_element and passing it to the draw methods
-- Implementing the layer registration into simple_sprite or non_bloking_io examples

local screen_repr = {}
local layers_index = {}

--- Adds a new layer to the screen representation over the previous layers
local function add_layer(layer_name)
	local data = setmetatable({}, {
		__index = function()
			return {}
		end,
	})
	layers_index[layer_name] = #screen_repr + 1
	table.insert(screen_repr, { name = layer_name, data = data })
end

--- Gets the background elements of the given layer
--- also updates the given layer deleting the corresponding unit
--- @param layer_name string | nil
--- @param line integer
--- @param col integer
local function get_background_units(layer_name, line, col)
	if not layer_name then
		return "  "
	end
	local result
	for i = 1, layers_index[layer_name] - 1 do
		result = screen_repr[i].data[line][col] or "  "
	end
	screen_repr[layers_index[layer_name]].data[line][col] = nil
	return result ~= nil and result or "  "
end

--- Gets the foreground elements of the given layer or the elements of the given data,
--- also updates the given layer setting the corresponding unit
--- @param layer_name string | nil
--- @param line integer
--- @param col integer
--- @param unit string
local function get_foreground_units(layer_name, line, col, unit)
	if not layer_name then
		return unit
	end
	if layers_index[layer_name] >= #screen_repr then
		screen_repr[layers_index[layer_name]].data[line][col] = unit
		return unit
	end
	local result
	for i = layers_index[layer_name] + 1, #screen_repr do
		result = screen_repr[i].data[line][col] or unit
	end
	screen_repr[layers_index[layer_name]].data[line][col] = unit
	return result ~= nil and result or unit
end

-------------------------------------------------------------------------------

--- Write in the screen checking the given boundaries
--- @param data string
--- @param pos Point
--- @param bound Boundaries
--- @param options {color: Color | nil, clear: boolean | nil} | nil
local function unit_puts(data, pos, bound, options)
	local color = options and options.color or nil
	local clear = options and options.clear or false
	local fg = color and color.fg and utils.colors.fg(color.fg) or ""
	local bg = color and color.bg and utils.colors.bg(color.bg) or ""
	local rfg = color and color.fg and utils.colors.resetFg or ""
	local rbg = color and color.bg and utils.colors.resetBg or ""
	if pos.x <= bound.right and pos.x >= bound.left and pos.y <= bound.bottom and pos.y >= bound.top then
		-- TODO: take the background elements from the "get_background_elements"
		local fdata = clear and "  " or data
		utils.console:write(string.format("%s%s%s%s%s%s", utils.cursor.goTo(pos.x, pos.y), fg, bg, fdata, rfg, rbg))
	end
end

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
				local fpos = { x = pos.x + (j - 1) * 2, y = pos.y + i - 1 }
				local u = (clear or unit == "") and get_background_units(target_layer, fpos.y, fpos.x)
					or get_foreground_units(target_layer, fpos.y, fpos.x, unit)
				fstring = fstring .. string.format("%s%s", utils.cursor.goTo(fpos.x, fpos.y), u)
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
		for i = 0, to.x - from.x, 2 do
			local fdata = clear and get_background_units(target_layer, from.y, from.x + (i - 1))
				or get_foreground_units(target_layer, from.y, from.x + (i - 1), data)
			line = line .. fdata
		end
		utils.console:write(string.format("%s%s%s%s%s%s", utils.cursor.goTo(from.x, from.y), fg, bg, line, rfg, rbg))
	-- If is a vertical line
	elseif from.x == to.x then
		for i = from.y, to.y do
			local line = clear and get_background_units(target_layer, i, from.x)
				or get_foreground_units(target_layer, i, from.x, string.format("%s%s%s%s%s", fg, bg, data, rfg, rbg))
			utils.console:write(string.format("%s%s", utils.cursor.goTo(from.x, i), line))
		end
	-- else is a box
	else
		local line = string.rep(fdata, math.floor((to.x - from.x) / 2) + 1)
		utils.console:write(string.format("%s%s%s%s%s%s", utils.cursor.goTo(from.x, from.y), fg, bg, line, rfg, rbg))
		utils.console:write(string.format("%s%s%s%s%s%s", utils.cursor.goTo(from.x, to.y), fg, bg, line, rfg, rbg))
		for i = from.y + 1, to.y - 1 do
			utils.console:write(string.format("%s%s%s%s%s%s", utils.cursor.goTo(from.x, i), fg, bg, fdata, rfg, rbg))
			utils.console:write(string.format("%s%s%s%s%s%s", utils.cursor.goTo(to.x, i), fg, bg, fdata, rfg, rbg))
		end
	end
end

--- Write in the screen checking the given boundaries
--- @param data string | string[]
--- @param pos Point
--- @param bound Boundaries
--- @param options {color: Color | nil, align: boolean | nil, clear: boolean | nil} | nil
local function puts(data, pos, bound, options)
	local color = options and options.color or nil
	local align = options and options.align or false
	local clear = options and options.clear or false
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
				if pos.x + utf8.len(line) + 1 > bound.right then
					fdata[i] = string.sub(line, 1, bound.right + 1 - pos.x)
				end
			end
		end
		for i, line in ipairs(fdata) do
			-- TODO: take the background elements from the "get_background_elements"
			local fline = clear and string.rep(" ", utf8.len(line) or 1) or line
			local x = fpos.x
			if align and pos.x + utf8.len(line) > bound.right then
				x = bound.right + 1 - utf8.len(line)
			end
			if not align and fpos.y + i > bound.bottom + 1 then
				break
			end
			utils.console:write(
				string.format("%s%s%s%s%s%s", utils.cursor.goTo(x, fpos.y + i - 1), fg, bg, fline, rfg, rbg)
			)
		end
	end
end

return {
	add_layer = add_layer,
	ortogonal_puts = ortogonal_puts,
	sprite_puts = sprite_puts,
	unit_puts = unit_puts,
	puts = puts,
}
