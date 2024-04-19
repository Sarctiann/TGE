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
		["examples.mouse"] = "examples/mouse.lua",
		["examples.tanky"] = "examples/tanky.lua",
		["examples.tanky.console"] = "examples/tanky/console.lua",
		["examples.tanky.tank"] = "examples/tanky/tank.lua",
		tge = "tge.lua",
		["tge.brief_queue"] = "tge/brief_queue.lua",
		["tge.connection"] = "tge/connection.lua",
		["tge.entities"] = "tge/entities.lua",
		["tge.init"] = "tge/init.lua",
		["tge.loader"] = "tge/loader.lua",
		["tge.state"] = "tge/state.lua",
		["tge.utils"] = "tge/utils.lua",
	},
}
