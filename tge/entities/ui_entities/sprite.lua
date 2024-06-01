local base = require("tge.entities.ui_entities.base_ui_entity")
local utils = require("tge.utils")
local state = require("tge.state")

local UIEntity, ACTION, ORIENTATION = base.UIEntity, base.ACTION, base.ORIENTATION

--- @class SpriteOptions
--- @field lf number | nil
--- @field target_layer string | nil

--- @alias Behavior
--- | "rotate"
--- | "flip"
--- | "flip_sides"

local function validate_graph(graph)
	for _, line in ipairs(graph) do
		if #line ~= #graph then
			utils:exit_with_error("Each Unit is 2 chars long and the graph must be a square matrix of Units")
		end
	end
	return #graph
end

local function set_next_rotations(graphs_tbl, cur_orient)
	local idx = cur_orient - 1
	graphs_tbl[((idx + 1) % 4) + 1] = utils.rotate_left(graphs_tbl[cur_orient])
	graphs_tbl[((idx + 2) % 4) + 1] = utils.rotate_left(graphs_tbl[((idx + 1) % 4 + 1)])
	graphs_tbl[((idx + 3) % 4) + 1] = utils.rotate_left(graphs_tbl[((idx + 2) % 4 + 1)])
end

local function set_complementary_h_flip(graphs_tbl, cur_orient)
	graphs_tbl[((cur_orient + 1) % 4) + 1] = utils.flip_horizontaly(graphs_tbl[cur_orient])
end

local function set_flips(graphs_tbl, cur_orient)
	local first_flip, second_flip
	if cur_orient == ORIENTATION.south or cur_orient == ORIENTATION.north then
		first_flip = utils.flip_verticaly
		second_flip = utils.flip_horizontaly
	end
	local idx = cur_orient - 1
	graphs_tbl[((idx + 1) % 4) + 1] = first_flip(graphs_tbl[cur_orient])
	graphs_tbl[((idx + 2) % 4) + 1] = utils.rotate_left(graphs_tbl[(cur_orient + 2) % 4])
	graphs_tbl[((idx + 3) % 4) + 1] = second_flip(graphs_tbl[(cur_orient + 1) % 4])
end

--- @param graph table<string[]>
--- @param orientation ORIENTATION
--- @param behavior Behavior
local function create_oriented_graphs(graph, orientation, behavior)
	if (orientation == ORIENTATION.north or orientation == ORIENTATION.south) and behavior == "flip_sides" then
		utils:exit_with_error('A "flip_sides" Sprite requires a "west" or "east" orientation')
	end
	local graphs = {
		[orientation] = graph,
	}
	if behavior == "flip_sides" then
		set_complementary_h_flip(graphs, orientation)
	elseif behavior == "rotate" then
		set_next_rotations(graphs, orientation)
	elseif behavior == "flip" then
		set_flips(graphs, orientation)
	end

	return graphs
end

local function get_move_boundaries_for_sprite(size, boundaries)
	return {
		top = boundaries.top,
		bottom = boundaries.bottom - size + 1,
		left = boundaries.left + 1,
		right = boundaries.right - size * 2,
	}
end

--- @type fun(self: self, data: {graph: table<string[]>, orientation: ORIENTATION})
local set_random_graph = function(self, data)
	local new_graph_size = validate_graph(data.graph)
	if new_graph_size ~= self.size then
		utils:exit_with_error("The new graph must have the same size as the previous one")
	end
	self.graphs[data.orientation] = data.graph
end

--------------------------------- ACTIONS IMPLEMENTATION ------------------------------

--- Draws a Text ui_element and return the instance
--- @param self Sprite
--- @param data {pos: Point, orientation: ORIENTATION, options: SpriteOptions}
local draw = function(self, data)
	self.pos = data.pos
	self.orientation = data.orientation or self.orientation
	local graph = self.graphs[self.orientation]
	if data.options then
		self.lock_frames = data.options.lf or self.lock_frames
	end
	state.sprite_puts(graph, self.pos, self.boundaries, { target_layer = self.target_layer })
	self.is_present = true
end

--- Clear the ui element from the screen
--- @param self Sprite
local clear = function(self)
	if self.pos then
		state.sprite_puts(self.graph, self.pos, self.boundaries, { clear = true, target_layer = self.target_layer })
	end
	self.is_present = false
end

--- Moves the text instance to a new location
--- @param self Sprite
--- @param data {pos: Point | DIRECTION, orientation: ORIENTATION | nil}
local move = function(self, data)
	if not self.is_present then
		return
	end
	clear(self)

	base.try_move(self.pos, data.pos, 2, 1, get_move_boundaries_for_sprite(self.size, self.boundaries))
	if self.pos then
		draw(self, {
			pos = self.pos,
			orientation = data.orientation,
			options = { lf = self.lock_frames },
		})
	end
	self.is_present = true
end

--- Update the Text instance with the given data
--- @param self Sprite
--- @param data {graph: table<string[]>, behavior: Behavior, orientation: ORIENTATION, pos: Point | nil, options: SpriteOptions}
local update = function(self, data)
	local is_present = self.is_present
	clear(self)
	local behavior = data.behavior or "rotate"
	local size = validate_graph(data.graph)

	self.graphs = create_oriented_graphs(data.graph, data.orientation, behavior)
	self.orientation = data.orientation
	self.pos = data.pos or self.pos
	self.graph = data.graph
	self.size = size

	if data.options then
		self.lock_frames = data.options.lf
	end

	if self.pos and is_present then
		state.sprite_puts(self.graph, self.pos, self.boundaries, { target_layer = self.target_layer })
	end
	self.is_present = is_present
end

--- @param data {graph: table<string[]>, behavior: Behavior | nil, orientation: ORIENTATION, options: SpriteOptions}
--- @param boundaries Boundaries
local function new(data, boundaries)
	local behavior = data.behavior or "rotate"
	local size = validate_graph(data.graph)

	--- @class Sprite : Unit to put/move/remove the minimal symmetrical ui element on screen ( size: 2,1 )
	local self = UIEntity.new()

	--- @type {[ORIENTATION]: table<string[]>} The graph in the four orientations
	self.graphs = create_oriented_graphs(data.graph, data.orientation, behavior)
	--- @type ORIENTATION the orientation of the given graph
	self.orientation = data.orientation
	--- @type Point | nil the position of the unit
	self.pos = nil
	--- @type table<string[]> the unit graph
	self.graph = data.graph
	--- @type integer the size of the Sprite in units
	self.size = size

	if data.options then
		self.lock_frames = data.options.lf and data.options.lf
		self.target_layer = data.options.target_layer and data.options.target_layer
	end

	self.set_random_graph = set_random_graph

	--- @type Boundaries the boundaries of the unit
	self.boundaries = boundaries

	self[ACTION.draw] = draw
	self[ACTION.clear] = clear
	self[ACTION.move] = move
	self[ACTION.update] = update

	return self
end

return { new = new }
