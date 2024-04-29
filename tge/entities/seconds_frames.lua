--- @class SecondsFrames
--- @field public frame_rate integer Frames per second
--- @field public s integer
--- @field public f integer
local SecondsFrames = {}

local function validate_new(s, f)
	if s then
		assert(s >= 0, "seconds should be grather or equal to 0")
	end
	if f then
		assert(f >= 0, "frames should be grather or equal to 0")
	end
end

local function validate_op(sf1, sf2, value)
	assert(sf1.frame_rate == sf2.frame_rate, "Cannot perform operations between SeconsFrames with different frame_rate")
	if type(value) == "boolean" then
		return value
	end
	assert(value >= 0, "Cannot create SecondsFrames with negative values")
	return value
end

--- Increments by one Frames
function SecondsFrames:increment()
	if self.frame_rate - 1 <= self.f then
		self.s = self.s + 1
		self.f = 0
	else
		self.f = self.f + 1
	end
end

--- Converts itself to frames (integer)
--- @return integer frames
function SecondsFrames:to_frames()
	return self.frame_rate * self.s + self.f
end

--- Returns a New SecondsFrames
--- @param frame_rate integer frames per second
--- @param seconds integer | nil
--- @param frames integer | nil
--- @return SecondsFrames sf
function SecondsFrames.new(frame_rate, seconds, frames)
	validate_new(seconds, frames)

	return setmetatable({
		frame_rate = frame_rate,
		s = seconds or 0,
		f = frames or 0,
	}, {
		__index = SecondsFrames,

		__tostring = function(self)
			return string.format("%.5d : %.3d", self.s, self.f)
		end,

		__len = function(self)
			return #string.format("%.5d : %.3d", self.s, self.f)
		end,

		__eq = function(self, sf_other)
			return validate_op(self, sf_other, self:to_frames() == sf_other:to_frames())
		end,

		__le = function(self, sf_other)
			return validate_op(self, sf_other, self:to_frames() <= sf_other:to_frames())
		end,

		__lt = function(self, sf_other)
			return validate_op(self, sf_other, self:to_frames() < sf_other:to_frames())
		end,

		__add = function(self, sf_other)
			return SecondsFrames.from_frames(
				validate_op(self, sf_other, self:to_frames() + sf_other:to_frames()),
				self.frame_rate
			)
		end,

		__sub = function(self, sf_other)
			return SecondsFrames.from_frames(
				validate_op(self, sf_other, self:to_frames() - sf_other:to_frames()),
				self.frame_rate
			)
		end,

		__mul = function(self, sf_other)
			return SecondsFrames.from_frames(
				validate_op(self, sf_other, self:to_frames() * sf_other:to_frames()),
				self.frame_rate
			)
		end,

		__div = function(self, sf_other)
			return SecondsFrames.from_frames(
				validate_op(self, sf_other, self:to_frames() / sf_other:to_frames()),
				self.frame_rate
			)
		end,
	})
end

--- Creates a new SecondsFrames from frames (integer)
--- @param frames integer
--- @param frame_rate integer
--- @return SecondsFrames sf
function SecondsFrames.from_frames(frames, frame_rate)
	return SecondsFrames.new(frame_rate, math.floor(frames / frame_rate), frames % frame_rate)
end

return SecondsFrames
