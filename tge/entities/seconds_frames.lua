--- @class SecondsFrames
--- @field public frame_rate integer Frames per second
--- @field public s integer
--- @field public f integer
--- @field public increment fun(self: self): nil
--- @field public to_frames fun(self: self): integer
local SecondsFrames = {}

--- Increments Seconds and Frames based on the given frame_rate
local function increment(self)
	if self.frame_rate - 1 <= self.f then
		self.s = self.s + 1
		self.f = 0
	else
		self.f = self.f + 1
	end
end

local function to_frames(self)
	return self.frame_rate * self.s + self.f
end

local function validate_new(s, f)
	if s then
		assert(s >= 0, "seconds should be grather or equal to 0")
	end
	if f then
		assert(f >= 0, "frames should be grather or equal to 0")
	end
end

local function validate_op(sf1, sf2)
	assert(sf1.frame_rate == sf2.frame_rate, "Cannot perform operations between SeconsFrames with different frame_rate")
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
		increment = increment,
		to_frames = to_frames,
	}, {
		__tostring = function(self)
			return string.format("%.5d : %.3d", self.s, self.f)
		end,

		__eq = function(self, sf_other)
			validate_op(self, sf_other)

			return self.s == sf_other.s and self.f == sf_other.f
		end,

		__le = function(self, sf_other)
			validate_op(self, sf_other)

			if self.s < sf_other.s or (self.s == sf_other.s and self.f <= sf_other.f) then
				return true
			end
			return false
		end,

		__lt = function(self, sf_other)
			validate_op(self, sf_other)

			if self.s < sf_other.s or (self.s == sf_other.s and self.f < sf_other.f) then
				return true
			end
			return false
		end,

		__add = function(self, sf_other)
			validate_op(self, sf_other)

			return SecondsFrames.from_frames(self:to_frames() + sf_other:to_frames(), self.frame_rate)
		end,

		__sub = function(self, sf_other)
			validate_op(self, sf_other)

			return SecondsFrames.from_frames(self:to_frames() - sf_other:to_frames(), self.frame_rate)
		end,
	})
end

--- Comverts from integer to SecondsFrames
--- @param frames integer
--- @param frame_rate integer
--- @return SecondsFrames sf
function SecondsFrames.from_frames(frames, frame_rate)
	return SecondsFrames.new(frame_rate, math.floor(frames / frame_rate), frames % frame_rate)
end

local sf1 = SecondsFrames.new(30, 1, 29)
local sf2 = SecondsFrames.new(30, 0, 30)

print(sf1 - sf2)

return SecondsFrames
