#!/bin/awk -f

BEGIN {
  COUNT = 9;
  for (i = 0; i < COUNT; ++i) {
    states[i] = 0;
  }
}

{
  n = split($1, fishes, ",");
}

END {
  for (i = 1; i <= n; ++i) {
    states[fishes[i]]++;
  }

  for (generation = 0; generation < 80; ++generation) {
    s = states[0];
    states[0] = 0;
    for (i = 1; i < COUNT; ++i) {
      states[i - 1] = states[i];
    }
    states[COUNT - 1]  = s;
    states[6]         += s;
  }

  sum = 0;
  for (i = 0; i < COUNT; ++i) {
    sum += states[i];
  }
  printf "%s: Part one: %d\n", FILENAME, sum;

  for (generation = 0; generation < 256 - 80; ++generation) {
    s = states[0];
    states[0] = 0;
    for (i = 1; i < COUNT; ++i) {
      states[i - 1] = states[i];
    }
    states[COUNT - 1]  = s;
    states[6]         += s;
  }

  sum = 0;
  for (i = 0; i < COUNT; ++i) {
    sum += states[i];
  }
  printf "%s: Part two: %d\n", FILENAME, sum;
}