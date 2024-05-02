local utils = require("tge.utils")

local function not_implemented(action)
	utils:exit_with_error("%s action is not implemented by this UI Entity", action)
end

--- @class UIEntity
--- @field public boundaries Boundaries The boundaries of the UI entity
--- @field public lock_frames integer The ammount of frames must wait to unlock
--- @field public locked_until SecondsFrames | nil The time in seconds and frames until the entity is unlocked
--- @field public draw fun(self, data: any, boundaries: Boundaries): self Draws the UI entity on the screen and returns the instance
--- @field public clear fun(self, patch: any): nil Clears the UI entity from the screen
--- @field public move fun(self, data: any, patch: any): nil Moves the UI entity in the specified direction
--- @field public move_or_draw fun(self, data: any, boundaries: Boundaries, patch: any): self Tries to move the instance or draws and returns it
--- @field public update fun(self, data: any): nil Updates the UI entity with the new data
--- @field public update_or_draw fun(self, data: any, boundaries: Boundaries): self Tries to update the instance or draws and returns it
--- @field public copy fun(self, data: any, boundaries: Boundaries): self Tries to copy the instance or draws and returns it
local UIEntity = {
	locked_until = nil,
	lock_frames = 1,
	draw = function()
		---@diagnostic disable-next-line: missing-return
		not_implemented("DRAW")
	end,
	clear = function()
		not_implemented("CLEAR")
	end,
	move = function()
		not_implemented("MOVE")
	end,
	move_or_draw = function()
		---@diagnostic disable-next-line: missing-return
		not_implemented("MOVE_OR_DRAW")
	end,
	update = function()
		not_implemented("UPDATE")
	end,
	update_or_draw = function()
		---@diagnostic disable-next-line: missing-return
		not_implemented("UPDATE_OR_DRAW")
	end,
	copy = function()
		---@diagnostic disable-next-line: missing-return
		not_implemented("COPY")
	end,
}
UIEntity.__index = UIEntity

return UIEntity
