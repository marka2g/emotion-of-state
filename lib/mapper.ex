defmodule Mapper do
  def map(line, partition_process_id) do
    send(partition_process_id, {:process_put, self()})

    Enum.each(String.split(line, " "), fn key -> send(partition_process_id, {:value_put, key}) end)
  end
end
