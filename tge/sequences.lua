local base = require("tge.sequences.base_sequence")

return {
	SpriteSeqs = require("tge.sequences.sprite_seqs"),
	create_sequence = base.create_sequence,
	cancel_sequences = base.cancel_sequences,
}
