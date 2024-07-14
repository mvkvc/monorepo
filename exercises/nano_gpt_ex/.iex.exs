import NanoGpt
import NanoGpt.Data
import NanoGpt.Hex

# Get default hex pm config
config = get_config()

# Testing
x = "data/tokenized/bigcode/train.bin"
|>stream_binary()
|> stream_batches()
|> Enum.take(1)
