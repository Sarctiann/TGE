local ui_enttities = require("tge.entities.ui_entities")

--- @class Entities
--- @field public Brief Brief
--- @field public Dimensions Dimensions
--- @field public SecondsFrames SecondsFrames
--- @field public UIEntity UIEntity
return {
	Brief = require("tge.entities.brief"),
	Dimensions = require("tge.entities.dimensions"),
	Point = require("tge.entities.point"),
	SecondsFrames = require("tge.entities.seconds_frames"),
	UIEntity = ui_enttities.UIEntity,
}
