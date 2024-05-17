local base = require("tge.entities.ui_entities.base_ui_entity")
local utils = require("tge.utils")

local UIEntity, ACTION, validate_pair = base.UIEntity, base.ACTION, base.validate_pair

local function validate_graph_and_create_orientations(graph)
	for _, line in ipairs(graph) do
		if #line / 2 ~= #graph then
			utils:exit_with_error("The graph must have 2 characters")
		end
	end
	return graph
end

local function get_move_boundaries_for_sprite(graph, boundaries)
	local length = math.floor(graph[0] / 2)
	return {
		top = boundaries.top,
		bottom = boundaries.bottom,
		left = boundaries.left + 1,
		right = boundaries.right - length,
	}
end

--- @class SpriteOptions
--- @field lf number | nil
--- @field color Color | nil

--- Creates and draws a Text ui_element and return the instance
--- @param self Sprite
--- @param data {pos: Point, options: SpriteOptions}
local draw = function(self, data)
	self.pos = data.pos
	if data.options then
		self.color = data.options.color or self.color
		self.lock_frames = data.options.lf or self.lock_frames
	end

	utils:simple_puts(self.pair, self.pos, self.boundaries, { color = self.color })
end

--- Clear the ui element from the screen
--- @param self Sprite
local clear = function(self)
	if self.pos then
		utils:simple_puts("  ", self.pos, self.boundaries, { clear = true })
	end
end

--- Moves the text instance to a new location
--- @param self Sprite
--- @param data {pos: Point | DIRECTION}
local move = function(self, data)
	clear(self)

	base.try_move(self.pos, data.pos, 2, 1, get_move_boundaries_for_sprite(self.graph, self.boundaries))
	if self.pos then
		draw(self, {
			pos = self.pos,
			options = { color = self.color, lf = self.lock_frames },
		})
	end
end

--- Update the Text instance with the given data
--- @param self Sprite
--- @param data {pos: Point | nil, pair: string | nil, options: SpriteOptions}
local update = function(self, data)
	clear(self)
	self.pos = data.pos or self.pos
	self.pair = data.pair and validate_pair(data.pair) or self.pair
	if data.options then
		self.color = data.options.color or self.color
		self.lock_frames = data.options.lf or self.lock_frames
	end
	if self.pos then
		utils:simple_puts(self.pair, self.pos, self.boundaries, { color = self.color })
	end
end

--- @param data {graph: string[], orientation: ORIENTATION, options: SpriteOptions}
--- @param boundaries Boundaries
local function new(data, boundaries)
	--- @class Sprite : Unit to put/move/remove the minimal symmetrical ui element on screen ( size: 2,1 )
	local self = UIEntity.new()

	--- @type string[] the pair of the unit
	self.graph = validate_graph_and_create_orientations(data.graph)
	--- @type ORIENTATION the orientation of the given graph
	self.orientation = data.orientation
	--- @type Boundaries the boundaries of the unit
	self.boundaries = boundaries
	--- @type Point | nil the position of the unit
	self.pos = nil

	if data.options then
		--- @type Color
		self.color = data.options.color
		self.lock_frames = data.options.lf
	end

	self[ACTION.draw] = draw
	self[ACTION.clear] = clear
	self[ACTION.move] = move
	self[ACTION.update] = update

	return self
end

return { new = new }
