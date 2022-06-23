use strict;
use warnings;

use List::Util qw(min max);
use Class::Struct;

struct Segment =>
[
    x1 => '$',
    y1 => '$',
    x2 => '$',
    y2 => '$',
];

use constant MATRIX_WIDTH => 1000;
use constant MATRIX_SIZE  => MATRIX_WIDTH * MATRIX_WIDTH;

foreach my $filename (@ARGV) {
  open my $file, $filename or die "Could not open $filename: $!";

  my @segments;
  while (my $line = <$file>) {
    my @parts     = split ' -> ', $line;
    my @fromParts = split ',', $parts[0];
    my @toParts   = split ',', $parts[1];

    my $segment = Segment->new(
      x1 => $fromParts[0],
      y1 => $fromParts[1],
      x2 => $toParts[0],
      y2 => $toParts[1],
    );

    push(@segments, $segment);
  }


  my $count = 0;
  my @array = (0) x MATRIX_SIZE;

  for my $s (@segments) {
    my ($x1, $y1, $x2, $y2) = ($s->x1, $s->y1, $s->x2, $s->y2);
    if ($x1 == $x2) {
      for (my $y = min($y1, $y2); $y <= max($y1, $y2); $y++) {
        if ($array[$y * MATRIX_WIDTH + $x1]++ == 1) {
          $count++;
        }
      }
    } elsif ($y1 == $y2) {
      for (my $x = min($x1, $x2); $x <= max($x1, $x2); $x++) {
        if ($array[$y1 * MATRIX_WIDTH + $x]++ == 1) {
          $count++;
        }
      }
    }
  }

  print "$filename: Part one: $count\n";

  for my $s (@segments) {
    my ($x1, $y1, $x2, $y2) = ($s->x1, $s->y1, $s->x2, $s->y2);
    
    if ($y2 > $y1 and $x2 > $x1) {
      for (my $i = 0; $i <= $x2 - $x1; $i++) {
        if ($array[($y1 + $i) * MATRIX_WIDTH + ($x1 + $i)]++ == 1) {
          $count++;
        }
      }
    } elsif ($y2 < $y1 and $x2 < $x1) {
      for (my $i = 0; $i <= $x1 - $x2; $i++) {
        if ($array[($y1 - $i) * MATRIX_WIDTH + ($x1 - $i)]++ == 1) {
          $count++;
        }
      }
    } elsif ($y2 > $y1 and $x2 < $x1) {
      for (my $i = 0; $i <= $x1 - $x2; $i++) {
        if ($array[($y1 + $i) * MATRIX_WIDTH + ($x1 - $i)]++ == 1) {
          $count++;
        }
      }
    } elsif ($y2 < $y1 and $x2 > $x1) {
      for (my $i = 0; $i <= $x2 - $x1; $i++) {
        if ($array[($y1 - $i) * MATRIX_WIDTH + ($x1 + $i)]++ == 1) {
          $count++;
        }
      }
    }
  }

  print "$filename: Part two: $count\n";

  close $file;
}
