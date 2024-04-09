package = "TGE"
version = "dev-1"
source = {
	url = "git+ssh://git@github.com/Sarctiann/TGE.git",
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
		main = "src/main.lua",
	},
}
dependencies = {
	"lua >= 5.3",
	"plterm >= 0.3",
}
