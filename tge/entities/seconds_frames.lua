--- @class SecondsFrames
--- @field public s integer The seconds of the entire life of the Game
--- @field public f integer The freames per second
--- @field public increment fun(self: self, fr: integer): nil
local SecondsFrames = {}

--- Increments Seconds and Frames based on the given frame_rate
--- @param fr integer frames per second
local function increment(self, fr)
	if fr <= self.f then
		self.s = self.s + 1
		self.f = 1
	else
		self.f = self.f + 1
	end
end

--- Returns a New SecondsFrames
--- @return SecondsFrames sf
function SecondsFrames.new()
	return setmetatable({
		s = 0,
		f = 1,
		increment = increment,
	}, {
		__tostring = function(self)
			return string.format("%.5d : %.3d", self.s, self.f)
		end,
	})
end

return SecondsFrames
