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
local function increment(self)
	if self.frame_rate - 1 <= self.f then
		self.s = self.s + 1
		self.f = 0
	else
		self.f = self.f + 1
	end
end

--- Converts itself seconds and frames to frames (integer)
--- @return integer frames
local function to_frames(self)
	return self.frame_rate * self.s + self.f
end

-- Since metamethods require future declarations this is a workaround
local SecondsFramesMeta = {}

--- Returns a.new SecondsFrames
--- @param frame_rate integer frames per second
--- @param seconds integer | nil the initial seconds
--- @param frames integer | nil the initial frames
--- @return SecondsFrames sf a SecondsFrames table
local function new(frame_rate, seconds, frames)
	validate_new(seconds, frames)

	--- @class SecondsFrames
	local self = {
		--- @type integer Frames per second
		frame_rate = frame_rate,
		--- @type integer Seconds
		s = seconds or 0,
		--- @type integer Frames
		f = frames or 0,
	}

	--- @type fun(): integer Converts itself seconds and frames to frames (integer)
	self.to_frames = function()
		return to_frames(self)
	end

	--- @type fun():nil Increments by one Frames
	self.increment = function()
		increment(self)
	end

	setmetatable(self, SecondsFramesMeta)

	return self
end

--- Creates a.new SecondsFrames from frames (integer)
--- @param frames integer total frames
--- @param frame_rate integer frames per second
--- @return SecondsFrames sf a SecondsFrames table
local function from_frames(frames, frame_rate)
	return new(frame_rate, math.floor(frames / frame_rate), frames % frame_rate)
end

SecondsFramesMeta.__tostring = function(self)
	return string.format("%.5d : %.3d", self.s, self.f)
end

SecondsFramesMeta.__len = function(self)
	return #string.format("%.5d : %.3d", self.s, self.f)
end

SecondsFramesMeta.__eq = function(self, sf_other)
	return validate_op(self, sf_other, self.to_frames() == sf_other.to_frames())
end

SecondsFramesMeta.__le = function(self, sf_other)
	return validate_op(self, sf_other, self.to_frames() <= sf_other.to_frames())
end

SecondsFramesMeta.__lt = function(self, sf_other)
	return validate_op(self, sf_other, self.to_frames() < sf_other.to_frames())
end

SecondsFramesMeta.__add = function(self, sf_other)
	return from_frames(validate_op(self, sf_other, self.to_frames() + sf_other.to_frames()), self.frame_rate)
end

SecondsFramesMeta.__sub = function(self, sf_other)
	return from_frames(validate_op(self, sf_other, self.to_frames() - sf_other.to_frames()), self.frame_rate)
end

SecondsFramesMeta.__mul = function(self, factor)
	assert(type(factor) == "number", "Can only multiply SecondsFrames by a number")
	return from_frames(validate_op(self, factor, math.floor(self.to_frames() * factor)), self.frame_rate)
end

SecondsFramesMeta.__div = function(self, divisor)
	assert(type(divisor) == "number", "Can only divided SecondsFrames by a number")
	return from_frames(validate_op(self, divisor, math.floor(self.to_frames() / divisor)), self.frame_rate)
end

return { from_frames = from_frames, new = new }
