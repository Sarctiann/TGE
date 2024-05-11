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
local SecondsFrames = {

	__tostring = function(self)
		return string.format("%.5d : %.3d", self.s, self.f)
	end,

	__len = function(self)
		return #string.format("%.5d : %.3d", self.s, self.f)
	end,

	__eq = function(self, sf_other)
		return validate_op(self, sf_other, self.to_frames() == sf_other.to_frames())
	end,

	__le = function(self, sf_other)
		return validate_op(self, sf_other, self.to_frames() <= sf_other.to_frames())
	end,

	__lt = function(self, sf_other)
		return validate_op(self, sf_other, self.to_frames() < sf_other.to_frames())
	end,
}

--- Increments by one Frames
local function increment(self)
	if self.frame_rate - 1 <= self.f then
		self.s = self.s + 1
		self.f = 0
	else
		self.f = self.f + 1
	end
end

--- Converts itself to frames (integer)
--- @return integer frames
local function to_frames(self)
	return self.frame_rate * self.s + self.f
end

--- Returns a.new SecondsFrames
--- @param frame_rate integer frames per second
--- @param seconds integer | nil the initial seconds
--- @param frames integer | nil the initial frames
--- @return SecondsFrames sf a SecondsFrames table
local function new(frame_rate, seconds, frames)
	validate_new(seconds, frames)

	--- @class SecondsFrames
	local self = {
		frame_rate = frame_rate,
		s = seconds or 0,
		f = frames or 0,
	}
	self.to_frames = function()
		to_frames(self)
	end

	self.increment = function()
		increment(self)
	end

	setmetatable(self, SecondsFrames)

	return self
end

--- Creates a.new SecondsFrames from frames (integer)
--- @param frames integer total frames
--- @param frame_rate integer frames per second
--- @return SecondsFrames sf a SecondsFrames table
local function from_frames(frames, frame_rate)
	return new(frame_rate, math.floor(frames / frame_rate), frames % frame_rate)
end

SecondsFrames.__add = function(self, sf_other)
	return from_frames(validate_op(self, sf_other, self.to_frames() + sf_other.to_frames()), self.frame_rate)
end

SecondsFrames.__sub = function(self, sf_other)
	return from_frames(validate_op(self, sf_other, self.to_frames() - sf_other.to_frames()), self.frame_rate)
end

SecondsFrames.__mul = function(self, sf_other)
	return from_frames(validate_op(self, sf_other, self.to_frames() * sf_other.to_frames()), self.frame_rate)
end

SecondsFrames.__div = function(self, sf_other)
	return from_frames(validate_op(self, sf_other, self.to_frames() / sf_other.to_frames()), self.frame_rate)
end

local sf = new(30)

print(sf)

return { from_frames = from_frames, new = new }
