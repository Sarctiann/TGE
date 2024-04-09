T = require("plterm")

local function render()
	local prevmode, e, m = T.savemode()
	if not prevmode then
		print(prevmode, e, m)
		os.exit()
	end
	T.setrawmode()
	T.show() -- show cursor
	T.restoremode(prevmode)
end --display

local function main()
	render()
end
main()
