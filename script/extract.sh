#!/bin/bash

bzcat ../data/s_8_sequence.txt.bz2 | fastx_barcode_splitter.pl --bcfile ../data/bc2 --exact --bol --prefix s_8_ --suffix .notrim.fq
bzcat ../data/s_7_sequence.txt.bz2 | fastx_barcode_splitter.pl --bcfile ../data/bc --exact --bol --prefix s_7_ --suffix .notrim.fq
