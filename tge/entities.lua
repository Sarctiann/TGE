local ui_enttities = require("tge.entities.ui_entities")

--- @class Entities
--- @field Brief Brief
--- @field Dimensions Dimensions
--- @field UI_Entity UI_Entity
return {
	Brief = require("tge.entities.brief"),
	Dimensions = require("tge.entities.dimensions"),
	Point = require("tge.entities.point"),
	UI_Entity = ui_enttities.UI_Entity,
}
