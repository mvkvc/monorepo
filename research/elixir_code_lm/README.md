# elixir_code_lm

Fine-tuning CodeLlama on Elixir source from Hex for code completion.

## Files

- `src/download.exs`: Downloads the source text from Hex.
- `src/dataset.py`: Load text, encode, create HF dataset and upload to HF Hub.
