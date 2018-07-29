defmodule EmotionOfState do
  require InputReader
  require Partition

  def main(args) do
    args |> parse_args |> pipeline
  end

  defp parse_args(args) do
    {options, _, _} =
      OptionParser.parse(
        args,
        switches: [file: :string]
      )

    options
  end

  defp pipeline([]) do
  end

  defp pipeline(options) do
    partition_process_id = elem(Partition.start_link(), 1)
    InputReader.reader("#{options[:file]}", partition_process_id)
    forever()
  end

  defp forever do
    forever()
  end
end
