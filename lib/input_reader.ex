defmodule InputReader do
  require Mapper

  # note: Strings in Erlang anr not arrays, they are lists(`IOLists`).  very_nice:
  # now File.read, later, stream in https://twitter.com/RealDonad_Trump.  lord_help_us_all
  def reader(file, partition_process_id) do
    case File.read(file) do
      {:ok, body} ->
        Enum.each(Regex.split(~r/\r|\n|\r\n/), String.trim(body), fn line ->
          spawn(fn -> Mapper.map(line, partition_process_id) end)
        end)

      {:error, reason} ->
        IO.puts(:stderr, "File Error: #{reason}")
    end
  end
end
