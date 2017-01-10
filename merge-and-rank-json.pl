#!/usr/bin/env perl

use strict;
use warnings;

use JSON;
use File::Slurp::Tiny qw(read_file write_file);

use v5.14;

my @output;

for my $f ( @ARGV ) {
  my $file_content = read_file( $f );
  my $data = decode_json $file_content;
  push @output, @{$data->{'users'}};
}

my @ranked_output = sort { $b->{'contributions'} - $b->{'private'} <=> $a->{'contributions'}-$a->{private} } @output;

@ranked_output = grep { $_->{'contributions'} > 0 } @ranked_output;
for (my $i = 0; $i <= $#ranked_output; $i++) {
  $ranked_output[$i]->{'position'} = $i+1;
}

say encode_json \@ranked_output;
