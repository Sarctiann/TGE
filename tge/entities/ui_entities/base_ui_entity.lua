local utils = require("tge.utils")

--- @enum ACTION
local ACTION = {
	---| fun(self, data: any): nil Draws the UI entity on the screen and returns the instance
	draw = 1,
	---| fun(self): nil Clears the UI entity from the screen
	clear = 2,
	---| fun(self, data: any): nil Moves the UI entity in the specified direction
	move = 3,
	---| fun(self, data: any): nil Updates the UI entity with the new data
	update = 4,
}

--- @enum DIRECTION
local DIRECTION = {
	up = 1,
	down = 2,
	left = 3,
	right = 4,
}

local function not_implemented(action)
	utils:exit_with_error("%s action is not implemented by this UI Entity", action)
end

--- Tries to move the point to a new location
--- @param point Point | nil must be a `Point` to use `new_pos` = `DIRECTION`
--- @param new_pos Point | DIRECTION could be a `Point` to replace `point` or a `DIRECTION` to move `point`
--- @param x_amt integer amount of characters for the step in the X axis.
--- @param y_amt integer amount of characters for the step in the Y axis.
--- @param boundaries Boundaries the limits for the direction movement.
local function try_move(point, new_pos, x_amt, y_amt, boundaries)
	if type(new_pos) == "table" and type(new_pos.x) == "number" and type(new_pos.y) == "number" then
		point.x, point.y = new_pos.x, new_pos.y
	elseif point and type(new_pos) == "number" then
		if new_pos == DIRECTION.up and point.y > boundaries.top then
			point.y = point.y - y_amt
		elseif new_pos == DIRECTION.down and point.y < boundaries.bottom then
			point.y = point.y + y_amt
		elseif new_pos == DIRECTION.left and point.x > boundaries.left then
			point.x = point.x - x_amt
		elseif new_pos == DIRECTION.right and point.x < boundaries.right then
			point.x = point.x + x_amt
		end
	end
end

local function new()
	--- @class UIEntity
	local self = {
		boundaries = nil,
		locked_until = nil,
		lock_frames = 1,
		call_action = function(self, action, data)
			---@diagnostic disable-next-line: redundant-parameter
			return self[action](self, data)
		end,
		[ACTION.draw] = function()
			not_implemented("DRAW")
		end,
		[ACTION.clear] = function()
			not_implemented("CLEAR")
		end,
		[ACTION.move] = function()
			not_implemented("MOVE")
		end,
		[ACTION.update] = function()
			not_implemented("UPDATE")
		end,
	}
	return self
end

return { UIEntity = { new = new }, ACTION = ACTION, DIRECTION = DIRECTION, try_move = try_move }
