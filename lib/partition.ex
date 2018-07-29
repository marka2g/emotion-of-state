defmodule Partition do
  require Reducer
  require OutputWriter

  # we are using start_link instead of start because we want the parent process to be killed when this process is killed
  # our linked processes are MapReduce, Partition, and OutputWriter in that order
  # OutputWriter will check if all Reduce processes have finished before exiting its own process. This will exit all linked processes all the way back to the parent. We use a lambda in start_link to start a recursive function that takes 2 lists as arguments
  def start_link do
    Task.start_link(fn -> loop([], []) end)
  end

  # recursive loop function will first check the length of the mailbox of messages sent by our Map processes. If it has processed all messages it will launch a check to see if we should launch our Reduce processes yet. We use Keyword.delete to remove all null or whitespace characters that have snuck into our key value pairs. Note the use of a sigil, ~s(\s), to represent a whitespace character. Next we have some pattern matching code that checks all of our received messages for specific tuples. If we receive the atom :processor_put we will append the process id of the caller Map process to our process list inside of a recursive loop call. If we instead receive the atom :value_put we will append a Keyword containing the key sent to us by Map and a value of 1 for the word count. Any other message will produce an error.
  defp loop(processes, values) do
    mailbox_length = elem(Process.info(self(), :message_queue_len), 1)

    # processed all messages
    if mailbox_length == 0,
      do:
        mapper_check(
          processes,
          Keyword.delete(Keyword.delete(values, String.to_atom(~s(\s))), String.to_atom(""))
        )

    receive do
      {:process_put, caller} ->
        loop([caller | processes], values)

      {:value_put, key} ->
        loop(processes, [{String.to_atom(key), 1} | values])

      error ->
        IO.puts(:stderr, "Partition Error: #{error}")
    end
  end

  # this function checks if all of our Map processes are dead and launches Reduce processes for each unique word if they are
  # First we use Enum.filter to return a list, check,of any process that is still alive. Then we create a list, unique, of every unique key/word. If we have a non-zero number of keys and no Map process is alive then we start_link OutputWriter and pass its process id to every Reduce process we spawn. After this we use Enum.each on uniques and use Keyword.take to pull out every instance of each unique and then spawn a Reduce process with a list of all of those instances.
  defp mapper_check(processes, values) do
    check = Enum.filter(processes, fn process -> Process.alive?(process) == true end)
    uniques = Enum.uniq(Keyword.keys(values))

    if length(check) == 0 && length(uniques) != 0,
      do:
        (
          output_writer = elem(OutputWriter.start_link(), 1)

          Enum.each(uniques, fn unique ->
            spawn(fn ->
              Reducer.reduce(Keyword.to_list(Keyword.take(values, [unique])), output_writer)
            end)
          end)
        )
  end
end
