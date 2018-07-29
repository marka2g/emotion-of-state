defmodule EmotionOfState do
  require InputReader
  require Partition

  def main(args) do
    args |> parse_args |> pipeline
  end

  # for now, we'll just use the command line and pass in a arg to the module like `--file=potus_right_now.txt`
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

  # launch partition process, but only store process id in variable
  # use elem to give us the second element of the tuple returned by starting our process because we don’t need the atom, :ok, first element.
  # then the Partition process id and the file name are passed to an Input Reader that we will write in the next step
  defp pipeline(options) do
    partition_process_id = elem(Partition.start_link(), 1)
    InputReader.reader("#{options[:file]}", partition_process_id)
    forever()
  end

  defp forever do
    forever()
  end
end
