Site-specific DICER and DROSHA RNA products control the DNA-damage response
========

### Clone this repository

`git clone https://github.com/davetang/22722852.git`

### Data description

Sequence data is available at DDBJ under the accession DRA000540.

There were 3 experiments under DRA000540 (DRX001415 is the first sequencing run; DRX001413 and DRX001414 are the second sequencing run):

1. DRX001413 (RIKEN ID SRhi10024) - Illumina HiSeq 2000 of the uncut samples (pLKO, shDicer and shDrosha) from the less than 200 nt small RNA fraction
2. DRX001414 (RIKEN ID SRhi10025) – Illumina HiSeq 2000 of the cut samples (pLKO, shDicer and shDrosha) from the less than 200 nt small RNA fraction
3. DRX001415 (RIKEN ID U29-DA) – Illumina GAIIx of the 3 samples, mock (Isce-I library), uncut (NIH 2/4 library) and cut (NIH 2/4 Isce-I library)

### Short RNA pipeline

Below is a description of the pipeline

#### Tag extraction

All tags containing undetermined bases (N) were considered to be low quality and were discarded from further analysis.

Of the remaining tags, only the ones containing the barcode (AAAA, CAAA and GAAA) and the Solexa-specific 3' linker (5’ ATCTCGTATGCCGTCTTCTGCTTG  3’) perfectly* are selected e.g. 5’ AAAA[tag]ATCTCGTATGCCGTCTTCTGCTTG 3’.

Linker and barcode sequences were then removed from the tags and assigned to individual files based on the barcode.

*The 3’ linker sequence is searched for in an iterative manner; firstly the entire 3’ linker is searched, then if no match is found another search is made using the 3’ linker sequence minus the last base e.g. 5’ AAAA[tag]ATCTCGTATGCCGTCTTCTGCTT 3’. This is continued until a match is found or if no match is found the short RNA is considered to be longer than 31 bp.

Please refer to <http://www.ncbi.nlm.nih.gov/pubmed/20964636> for more information on the short RNA protocol.

#### Artefact removal

Next TagDust* running on default settings was used to filter out artefactual tags. Below are the artefactual sequences stored in fasta format that were used as input into TagDust.

>five_prime_aaaa_three_prime
GTTCAGAGTTCTACAGTCCGACGATAAAAATCTCGTATGCCGTCTTCTGCTTG
>five_prime_caaa_three_prime
GTTCAGAGTTCTACAGTCCGACGATCAAAATCTCGTATGCCGTCTTCTGCTTG
>five_prime_gaaa_three_prime
GTTCAGAGTTCTACAGTCCGACGATGAAAATCTCGTATGCCGTCTTCTGCTTG
>five_prime_three_prime
GTTCAGAGTTCTACAGTCCGACGATATCTCGTATGCCGTCTTCTGCTTG
>rt_primer
CAAGCAGAAGACGGCATACGA
>forward_primer
AATGATACGGCGACCACCGACAGGTTCAGAGTTCTACAGTCCGA

*Please refer to <http://www.ncbi.nlm.nih.gov/pubmed/19737799> for more information on TagDust and the software is available at <http://genome.gsc.riken.jp/osc/english/software/src/tagdust.tgz>

#### Mapping

After filtering out artefactual tags, all remaining short RNA tags were mapped to the mm9 genome assembly, except for haplotype and random sequences using Eland, the default Solexa mapping tool with standard parameters (2 mismatches allowed). Tags mapping with fewer mismatches to ribosomal sequences than the genome were discarded. Tags that did not map were stored in an unmapped file.

#### Mapping files

At RIKEN OSC, we use a standardised file format to store our mapping results called the OSCtable format, which is a simple tab delimited file containing metadata and the mapping results. The metadata and column descriptions of the OSCtable format are stored at the start of the file as hash (#) comments. We have attached both our mapped and unmapped results stored in OSCtable format.

U29-DA.mapping.gz – contains all tags that were mapped to the mm9 genome for the 3 libraries
U29-DA.mapping.unmap.gz – contains all tags that were not mapped to the mm9 genome for the 3 libraries

In the paper, we refer to the Isce-I library (barcode AAAA) as mock, the NIH 2/4 library (barcode CAAA) as uncut and the NIH 2/4 Isce-I library (barcode GAAA) as cut.

#### Unmapped tag analysis

For the unmapped analysis, we first generated the locus (final_forward_locus_030910.fa). The locus contains 104 tet repeats (42 bp), the Isce site and 273 lac repeats (36 bp) totaling to 14,274 bp, which is approximately the length of the 14 kp locus described in paper.

Using BWA* with default parameters, we aligned the unmapped tags to our locus. We filtered for tags that mapped to the locus entirely with no mismatches i.e. a perfect match. A total of 46 unique tags, totaling 67 tag sequences mapped perfectly.

For our nucleotide bias analysis, we removed tags that were 32 bp in length as it is not possible to determine the composition of the last nucleotide for tags longer than 31 bp. 13 of the 67 tag sequences were longer than 31 bp.

*Please refer to <http://www.ncbi.nlm.nih.gov/pubmed/19451168> for more information on BWA.
