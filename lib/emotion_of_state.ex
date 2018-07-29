defmodule EmotionOfState do
  # def main(args) do
  def main() do
    # hardcode for now
    File.stream!("../test/input.txt")
    |> Flow.from_enumerable()
    |> Flow.flat_map(&String.split(&1, " "))
    |> Flow.partition()
    |> Flow.reduce(fn -> %{} end, fn word, acc ->
      Map.update(acc, word, 1, &(&1 + 1))
    end)
    |> Enum.to_list()
  end
end
