#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "Usage $0: <infile.fq.bz2>\n";
my $infile = shift or die $usage;

#s_7_dicer_uncut.notrim.fq.bz2
if ($infile =~ /\.fq.bz2$/){
   open(IN,'-|',"bzcat $infile") || die "Could not open $infile: $!\n";
} else {
   die "Did not recognise file; is it a bzip2 fastq file?\n";
}

while(<IN>){
   chomp;
   my $header  = $_;
   my $read    = <IN>;
   my $junk    = <IN>;
   my $quality = <IN>;
   chomp($read);
   chomp($quality);
   $read = trim($read);
   $quality = trim($quality);
   print "$header\n$read\n+\n$quality\n";
}
close(IN);

exit(0);

sub trim {
   my ($seq) = @_;
   return(substr($seq,4,length($seq)-3));
}
