-- related to the state of the running game/s, room/s, etc.
local utils = require("tge.utils")

-------------------------------------------------------------------------------
-- TODO: Complete and Test all this
-- Implementing the `target` param to the put methods and updating the `clear` section
-- Implementing the `layer` attr to the base_ui_element and passing it to the draw methods
-- Implementing the layer registration into simple_sprite or non_bloking_io examples

local screen_repr = {}

--- Adds a new layer to the screen representation over the previous layers
local function add_layer(layer_name)
	local data = setmetatable({}, {
		__index = function()
			return {}
		end,
	})
	table.insert(screen_repr, { name = layer_name, data = data, prev_amt = #screen_repr })
end

--- Gets the background elements of the given layer
local function get_background_elements(layer_name, line, from, to)
	local result = {}
	for i = 1, screen_repr[layer_name].prev_amt do
		local data = screen_repr[i].data
		for j = from, to do
			if data[line][j] then
				table.insert(result, j, data[line][j])
			end
		end
	end
	return table.concat(result)
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
--- @param clear boolean | nil
local function sprite_puts(data, pos, bound, clear)
	if pos.x <= bound.right and pos.x >= bound.left and pos.y <= bound.bottom and pos.y >= bound.top then
		local fstring = ""
		for i, line in ipairs(data) do
			for j, unit in ipairs(line) do
				-- TODO: take the background elements from the "get_background_elements"
				local u = (clear or unit == "") and "  " or unit
				local fpos = { x = pos.x + (j - 1) * 2, y = pos.y + i - 1 }
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
--- @param options {color: Color | nil, clear: boolean | nil} | nil
local function ortogonal_puts(data, from, to, options)
	local color = options and options.color or nil
	local clear = options and options.clear or false
	local fg = color and color.fg and utils.colors.fg(color.fg) or ""
	local bg = color and color.bg and utils.colors.bg(color.bg) or ""
	local rfg = color and color.fg and utils.colors.resetFg or ""
	local rbg = color and color.bg and utils.colors.resetBg or ""
	-- TODO: take the background elements from the "get_background_elements"
	local fdata = clear and "  " or data
	-- If is a horizontal line
	if from.y == to.y then
		local line = string.rep(fdata, math.floor((to.x - from.x) / 2) + 1)
		utils.console:write(string.format("%s%s%s%s%s%s", utils.cursor.goTo(from.x, from.y), fg, bg, line, rfg, rbg))
	-- If is a vertical line
	elseif from.x == to.x then
		for i = from.y, to.y do
			utils.console:write(string.format("%s%s%s%s%s%s", utils.cursor.goTo(from.x, i), fg, bg, fdata, rfg, rbg))
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
