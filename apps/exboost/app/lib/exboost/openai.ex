defmodule ExBoost.OpenAI do
  # curl https://api.openai.com/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer $OPENAI_API_KEY"   -d '{
  #   "model": "gpt-3.5-turbo",
  #   "messages": [
  #     {
  #       "role": "system",
  #       "content": "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."
  #     },
  #     {
  #       "role": "user",
  #       "content": "Compose a poem that explains the concept of recursion in programming."
  #     }
  #   ]
  # }'

  def chat(messages, opts \\ []) do
    base_url = Keyword.get(opts, :base_url, System.fetch_env!("OPENAI_API_BASE_URL"))
    api_key = System.fetch_env!("OPENAI_API_KEY")
    model = Keyword.get(opts, :model, "accounts/fireworks/models/llama-v3-70b-instruct")
    temperature = Keyword.get(opts, :temperature, 0.7)

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{api_key}"}
    ]

    body = %{
      model: model,
      temperature: temperature,
      messages: messages
    }

    Requests.post(base_url <> "/chat/completions", body, headers: headers)
  end
end
