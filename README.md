# Emotion of State
A map reduce exercise written in Elixir that parses the emotional state of The POTUS via twitter.

## [changelog] branch: `add-mix-and-basic-map-reduce`
### Basic Map Reduce Flow
1. `InputReader`
  - takes in data
  - splits into form that `Map` process can read
  - concurrently launches `Map` processes
2. `Mapper`
  - reads in data from `InputReader`
  - runs a function on each piece of the data
  - outputs `key: :value` pair to a `Partition/Compare` processes
3. `Partition/Compare`
  - accumulates `key: :value` pairs from ALL the `Mapper` processes
  - compares the pairs
  - spawns `Reduce` processes for each unique key
4. `Reduce`(process)
  - runs a function on each `value` that adds up all the values for the `key`
  - emits them to `OutputWriter`
5. `Output Writer`
  - yields data in the format of your choice
