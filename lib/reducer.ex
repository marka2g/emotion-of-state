defmodule Reducer do
  # takes a list of tuples (key value pairs) and the process id of Output Writer. Similar to Map we send Output Writer the process id of Reduce to keep track of its status. Then we check to make sure tuples is not empty with a case pattern match. If tuples is not empty we send a string to Output Writer.
  def reduce(tuples, output_writer) do
    send(output_writer, {:process_put, self()})

    case tuples do
      [] ->
        IO.puts(:stderr, "Empty List")

      tuples ->
        send(output_writer, {:value_put, "#{elem(hd(tuples), 0)}
        #{Enum.reduce(tuples, 0, fn {_k, v}, total -> v + total end)}"})
    end
  end
end
