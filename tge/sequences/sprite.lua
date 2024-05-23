local ui = require("tge.entities.ui_entities")

local function move_up_now(game, sprite)
	game.queue.enqueue({
		ui_element = sprite,
		when = game.sf,
		data = { pos = ui.DIRECTION.up },
		action = ui.ACTION.move,
	})
end

--- @param game Game
local function new(game)
	local self = {
		move_up_now = function(sprite)
			move_up_now(game, sprite)
		end,
	}

	return self
end

return { new = new }
