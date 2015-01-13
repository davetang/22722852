#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "Usage $0: <infile.fq>\n";
my $infile = shift or die $usage;
my $outfile = $infile;
my $no_match = $infile;

$outfile =~ s/\.fq$/_no_tail.fq/;
open(MATCH,'>',$outfile) || die "Could not open $outfile for writing: $!\n";
$no_match =~ s/\.fq$/_no_match.fq/;
open(NOMATCH,'>',$no_match) || die "Could not open $no_match for writing: $!\n";

#new ATCTCGTATGCCGTCTTCTGCTTG
my $revcom_adaptor = 'ATCTCGTATGCCGTCTTCTGCTTG';
my $length_adaptor = length($revcom_adaptor);

my $matched = '0';
my $scanned = '0';

warn "Running $0 $infile\n";

if ($infile =~ /\.fq.bz2$/){
   open(IN, '-|', $infile) || die "Could not open $infile: $!\n";
} else {
   open(IN, '<', $infile) || die "Could not open $infile: $!\n";
}

while(<IN>){
   chomp;
   next if /^$/;
=head2 example fastq file
@HWUSI-EAS733_0001:1:1:1020:19310#0/1
NTACGTGGGGGGTGATGAGACAGTTATACTTACAAC
+HWUSI-EAS733_0001:1:1:1020:19310#0/1
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
@HWUSI-EAS733_0001:1:1:1023:17385#0/1
=cut
   if (/^@/){
      ++$scanned;
      my $did_it_match = '0';
      my $header = $_;
      my $read = <IN>;
      chomp($read);
      my $plus_line = <IN>;
      my $quality = <IN>;
      chomp($quality);
      my $chopped_read = '';

      if ($read =~ /$revcom_adaptor/){
         $chopped_read = $read;
         $chopped_read =~ s/$revcom_adaptor.*$//;
         my $final_length = length($chopped_read);
         next if $final_length == 0;
         $quality = substr($quality,0,$final_length);
         $did_it_match = '1';
         ++$matched;
         print MATCH "$header\n";
         print MATCH "$chopped_read\n";
         print MATCH "+\n";
         print MATCH "$quality\n";
      } else {
         my $read_length = length($read);
         SCAN: for (my $i=$length_adaptor-1;$i>0;--$i){
            my $tail = substr($revcom_adaptor,0,$i);

            if ($read =~ /$tail$/){
               my $final_length = $read_length - length($tail);
               $chopped_read = substr($read,0,$final_length);
               $quality = substr($quality,0,$final_length);
               print MATCH "$header\n";
               print MATCH "$chopped_read\n";
               print MATCH "+\n";
               print MATCH "$quality\n";
               ++$matched;
               $did_it_match = '1';
               last SCAN;
            }
         }
      }

      if ($did_it_match == '0'){
         print NOMATCH "$header\n";
         print NOMATCH "$read\n";
         print NOMATCH "+\n";
         print NOMATCH "$quality\n";
      }
   } else {
      die "Error line $. not recognised: $_\n";
   }
}

warn "Total scanned: $scanned and total matched: $matched\n";

close(MATCH);
close(NOMATCH);

warn("Zipping files\n");
system("bzip2 $outfile");
system("bzip2 $no_match");

exit(0);
__END__
