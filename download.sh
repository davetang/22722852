#!/bin/bash

wget ftp://ftp.ddbj.nig.ac.jp/ddbj_database/dra/fastq/DRA000/DRA000540/DRX001413/DRR001952.fastq.bz2
wget ftp://ftp.ddbj.nig.ac.jp/ddbj_database/dra/fastq/DRA000/DRA000540/DRX001414/DRR001953.fastq.bz2
wget ftp://ftp.ddbj.nig.ac.jp/ddbj_database/dra/fastq/DRA000/DRA000540/DRX001415/DRR001954.fastq.bz2

ln -s DRR001952.fastq.bz2 s_7_sequence.txt.bz2
ln -s DRR001953.fastq.bz2 s_8_sequence.txt.bz2

mv *.bz2 data
