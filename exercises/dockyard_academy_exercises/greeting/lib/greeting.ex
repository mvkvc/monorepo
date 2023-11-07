defmodule Greeting do
  def main(args) do
    {opts, _word, _errors} = OptionParser.parse(args, switches: [time: :string, upcase: :boolean])
    time = Keyword.get(opts, :time, nil)
    upcase = Keyword.get(opts, :upcase, false)

    string = "Good #{ time || "morning" }!"
    string = if upcase, do: String.upcase(string), else: string

    IO.puts(string)
  end
end
