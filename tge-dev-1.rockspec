package = "TGE"
version = "dev-1"
source = {
	url = "https://github.com/Sarctiann/TGE.git",
}
description = {
	summary = "[Text | Terminal] Game Engine",
	detailed = "An attempt to create a simple text-based game engine",
	homepage = "*** not yet ***",
	license = "*** not yet ***",
}
dependencies = {
	"lua >= 5.3",
	"luabox >= 1.3-1",
}
build = {
	type = "builtin",
	modules = {
		tge = "tge.lua",
		["tge.connection"] = "tge/connection.lua",
		["tge.entities"] = "tge/entities.lua",
		["tge.entities.brief"] = "tge/entities/brief.lua",
		["tge.entities.dimensions"] = "tge/entities/dimensions.lua",
		["tge.entities.point"] = "tge/entities/point.lua",
		["tge.entities.ui_entities"] = "tge/entities/ui_entities.lua",
		["tge.game"] = "tge/game.lua",
		["tge.loader"] = "tge/loader.lua",
		["tge.queue"] = "tge/queue.lua",
		["tge.state"] = "tge/state.lua",
		["tge.utils"] = "tge/utils.lua",
	},
}
