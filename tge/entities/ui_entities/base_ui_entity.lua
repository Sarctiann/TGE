local utils = require("tge.utils")

--- @enum ACTION
local ACTION = {
	---| fun(self, data: any, boundaries: Boundaries): self Draws the UI entity on the screen and returns the instance
	draw = 1,
	---| fun(self): nil Clears the UI entity from the screen
	clear = 2,
	---| fun(self, data: any): nil Moves the UI entity in the specified direction
	move = 3,
	---| fun(self, data: any, boundaries: Boundaries): self Tries to move the instance or draws and returns it
	move_or_draw = 4,
	---| fun(self, data: any): nil Updates the UI entity with the new data
	update = 5,
	---| fun(self, data: any, boundaries: Boundaries): self Tries to update the instance or draws and returns it
	update_or_draw = 6,
	---| fun(self, data: any, boundaries: Boundaries): self Tries to copy the instance or draws and returns it
	copy = 7,
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
--- @param current Point | nil must be a `Point` to use `new_pos` = `DIRECTION`
--- @param new_pos Point | DIRECTION could be a `Point` to replace `current` or a `DIRECTION` to move `current`
--- @param x_amt integer amount of characters for the step in the X axis.
--- @param y_amt integer amount of characters for the step in the Y axis.
--- @return Point | nil
local function move_point_or_nil(current, new_pos, x_amt, y_amt)
	if type(new_pos) == "table" and type(new_pos.x) == "number" and type(new_pos.y) == "number" then
		return new_pos
	end
	if current and type(new_pos) == "number" then
		if new_pos == DIRECTION.up then
			current.y = current.y - y_amt
			return current
		elseif new_pos == DIRECTION.down then
			current.y = current.y + y_amt
			return current
		elseif new_pos == DIRECTION.left then
			current.x = current.x - x_amt
			return current
		elseif new_pos == DIRECTION.right then
			current.x = current.x + x_amt
			return current
		end
	end
end

--- @class UIEntity
local UIEntity = {
	--- @type  Boundaries | nil The boundaries of the UI entity
	boundaries = nil,
	--- @type SecondsFrames | nil The time in seconds and frames until the entity is unlocked
	locked_until = nil,
	--- @type integer The ammount of frames must wait to unlock
	lock_frames = 1,

	[ACTION.draw] = function()
		not_implemented("DRAW")
	end,
	[ACTION.clear] = function()
		not_implemented("CLEAR")
	end,
	[ACTION.move] = function()
		not_implemented("MOVE")
	end,
	[ACTION.move_or_draw] = function()
		not_implemented("MOVE_OR_DRAW")
	end,
	[ACTION.update] = function()
		not_implemented("UPDATE")
	end,
	[ACTION.update_or_draw] = function()
		not_implemented("UPDATE_OR_DRAW")
	end,
	[ACTION.copy] = function()
		not_implemented("COPY")
	end,
}

function UIEntity:call_action(action, data, boundaries)
	---@diagnostic disable-next-line: redundant-parameter
	return self[action](self, data, boundaries)
end

return { UIEntity = UIEntity, ACTION = ACTION, DIRECTION = DIRECTION, move_point_or_nil = move_point_or_nil }
