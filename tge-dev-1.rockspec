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
	"luabox >= 1.3-2",
}
build = {
	type = "builtin",
	modules = {
		tge = "tge.lua",
		["tge.connection"] = "tge/connection.lua",
		["tge.core"] = "tge/core.lua",
		["tge.entities"] = "tge/entities.lua",
		["tge.entities.boundaries"] = "tge/entities/boundaries.lua",
		["tge.entities.brief"] = "tge/entities/brief.lua",
		["tge.entities.dimensions"] = "tge/entities/dimensions.lua",
		["tge.entities.point"] = "tge/entities/point.lua",
		["tge.entities.seconds_frames"] = "tge/entities/seconds_frames.lua",
		["tge.entities.ui_entities"] = "tge/entities/ui_entities.lua",
		["tge.entities.ui_entities.base_ui_entity"] = "tge/entities/ui_entities/base_ui_entity.lua",
		["tge.entities.ui_entities.box"] = "tge/entities/ui_entities/box.lua",
		["tge.entities.ui_entities.line"] = "tge/entities/ui_entities/line.lua",
		["tge.entities.ui_entities.sprite"] = "tge/entities/ui_entities/sprite.lua",
		["tge.entities.ui_entities.text"] = "tge/entities/ui_entities/text.lua",
		["tge.game"] = "tge/game.lua",
		["tge.loader"] = "tge/loader.lua",
		["tge.queue"] = "tge/queue.lua",
		["tge.sequences"] = "tge/sequences.lua",
		["tge.sequences.sprite_seqs"] = "tge/sequences/sprite_seqs.lua",
		["tge.state"] = "tge/state.lua",
		["tge.utils"] = "tge/utils.lua",
	},
}
