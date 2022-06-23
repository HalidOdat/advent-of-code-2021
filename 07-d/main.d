import std.math;
import std.algorithm;
import std.stdio;
import std.array;
import std.conv;

int part_one(int[] crabs) {
  int min = crabs.minElement;
  int max = crabs.maxElement;
  int result = int.max;
  for (int i = min; i <= max; ++i) {
    int sum = 0;
    foreach (crab; crabs) {
      sum += abs(crab - i);
    }

    result = sum < result ? sum : result;
  }
  return result;
}

int part_two(int[] crabs) {
  int min = crabs.minElement;
  int max = crabs.maxElement;
  int result = int.max;
  for (int i = min; i <= max; ++i) {
    int sum = 0;
    foreach (crab; crabs) {
      for (int j = 1; j <= abs(crab - i); ++j) {
        sum += j;
      }
    }

    result = sum < result ? sum : result;
  }
  return result;
}

void main(string[] argv) {
  foreach (string filename; argv[1 .. $]) {
    auto file = File(filename);
    auto crabs = file
      .byLine
      .front
      .split(",")
      .map!(to!int)
      .array;

    writefln("%s: Part one: %d", filename, part_one(crabs));
    writefln("%s: Part two: %d", filename, part_two(crabs));
  }
}
