defmodule LLAMACPPNIF do
  use Rustler,
    otp_app: :llama_cpp_nif,
    crate: :llama

  def new(path), do: new(path, %LLAMACPPNIF.SamplerOptions{})
  def new(_path, _model_opts), do: :erlang.nif_error(:nif_not_loaded)
  def predict(llama, query), do: predict(llama, query, 1024)
  def predict(_llama, _query, _max_tokens), do: :erlang.nif_error(:nif_not_loaded)
end
