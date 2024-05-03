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

local function not_implemented(action)
	utils:exit_with_error("%s action is not implemented by this UI Entity", action)
end

--- @class UIEntity
--- @field public boundaries Boundaries The boundaries of the UI entity
--- @field public lock_frames integer The ammount of frames must wait to unlock
--- @field public locked_until SecondsFrames | nil The time in seconds and frames until the entity is unlocked
local UIEntity = {
	locked_until = nil,
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
UIEntity.__index = UIEntity

function UIEntity:call_action(action, data, boundaries)
	---@diagnostic disable-next-line: redundant-parameter
	return self[action](self, data, boundaries)
end

return { UIEntity = UIEntity, ACTION = ACTION }
