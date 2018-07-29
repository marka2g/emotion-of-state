# Emotion of State
A map reduce exercise written in Elixir that parses the emotional state of The POTUS via twitter.

## [changelog] branch: `add-mix-and-basic-map-reduce`
### Basic Map Reduce Flow
[followed this post at first](https://hackernoon.com/build-a-mapreduce-flow-in-elixir-f97c317e457e)
0. `EmotionOfState`(parent process - `main()`)
  - starts up the engines
1. `InputReader` "File.read() One Line At a Time"
  - takes in data
  - splits into form that `Map` process can read
  - concurrently launches `Map` processes
2. `Mapper` "Map the Words in the Line"
  - reads in data from `InputReader`
  - runs a function on each piece of the data
  - outputs `key: :value` pair to a `Partition/Compare` processes
3. `Partition/Compare` "The Concurrent Supervisor"
    (most complex module - uses `Task.start_link()`)
  - accumulates `key: :value` pairs from ALL the `Mapper` processes
  - compares the pairs
  - spawns `Reduce` processes for each unique key
4. `Reduce` "The Accumulator"
    Counts the unique words.
  - runs a function for each key and on each `value` that adds up all the values for the `key`
  - emits them to `OutputWriter`
5. `Output Writer` "Tell the World"
  - yields data in the format of your choice
