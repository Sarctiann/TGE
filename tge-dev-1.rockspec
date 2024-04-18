package = "TGE"
version = "dev-1"
source = {
	url = "https://github.com/Sarctiann/TGE.git",
}
description = {
	summary = "> [Text | Terminal] Game Engine",
	detailed = [[
> [Text | Terminal] Game Engine
]],
	homepage = "*** please enter a project homepage ***",
	license = "*** please specify a license ***",
}
build = {
	type = "builtin",
	modules = {
		tge = "tge.lua",
		["tge.init"] = "tge/init.lua",
		["tge.utils"] = "tge/utils.lua",
	},
}
dependencies = {
	"lua >= 5.3",
	"luabox >= 1.3-1",
}
