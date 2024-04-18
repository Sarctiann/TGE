package = "TGE"
version = "dev-1"
source = {
	url = "git+ssh://git@github.com/Sarctiann/TGE.git",
}
description = {
	summary = "[Text | Terminal] Game Engine",
	detailed = "An attempt to create a simple text-based game engine",
	homepage = "*** please enter a project homepage ***",
	license = "*** please specify a license ***",
}
dependencies = {
	"lua >= 5.3",
	"luabox >= 1.3-1",
}
build = {
	type = "builtin",
	modules = {
		tge = "tge.lua",
		["tge.init"] = "tge/init.lua",
		["tge.utils"] = "tge/utils.lua",
	},
}
