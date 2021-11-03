#!/bin/sh
# LINKS v.20 consist of two parts. First part, from reading long reads, up to pairing contigs and outputting tigpair_checkpoint is running in C++ 
# and rest of the pipeline, which is reading tigpair_checkpoints and outputting scaffolds is still running PERL code(like v1.8.7 and before).
# Whole pipeline can be run by LINKS-make script provided. However, Makefiles take arguments like 'd=4000' where LINKS always took arguments as '-d 4000'
# We are providing this script to run makefile with LINKS inputs. So you can run whole LINKS pipeline with previuous argument nomenclature.

#usage() { echo "Usage: $0 [-s <45|90>] [-p <string>]" 1>&2; exit 1; }

usage() {
	echo "
		Usage:  LINKS v2.0.0 \n 
                -f  sequences to scaffold (Multi-FASTA format, required)\n
                -s  file-of-filenames, full path to long sequence reads or MPET pairs [see below] (Multi-FASTA/fastq format, required)\n
                -m  MPET reads (default -m 1 = yes, default = no, optional)\n
                \t! DO NOT SET IF NOT USING MPET. WHEN SET, LINKS WILL EXPECT A SPECIAL FORMAT UNDER -s\n
                \t! Paired MPET reads in their original outward orientation <- -> must be separated by :\n
                \t  >template_name\n\t  ACGACACTATGCATAAGCAGACGAGCAGCGACGCAGCACG:ATATATAGCGCACGACGCAGCACAGCAGCAGACGAC\n
                -d  distance between k-mer pairs (ie. target distances to re-scaffold on. default -d 4000, optional)\n
                \tMultiple distances are separated by comma. eg. -d 500,1000,2000,3000\n
                -k  k-mer value (default -k 15, optional)\n
                -t  step of sliding window when extracting k-mer pairs from long reads (default -t 2, optional)\n
                \tMultiple steps are separated by comma. eg. -t 10,5\n
                -o  offset position for extracting k-mer pairs (default -o 0, optional)\n
                -e  error (%) allowed on -d distance   e.g. -e 0.1  == distance +/- 10% (default -e 0.1, optional)\n
                -l  minimum number of links (k-mer pairs) to compute scaffold (default -l 5, optional)\n
                -a  maximum link ratio between two best contig pairs (default -a 0.3, optional)\n
                \t *higher values lead to least accurate scaffolding*\n
                -z  minimum contig length to consider for scaffolding (default -z 500, optional)\n
                -b  base name for your output files (optional)\n
                -r  Bloom filter input file for sequences supplied in -s (optional, if none provided will output to .bloom)\n
                \t NOTE: BLOOM FILTER MUST BE DERIVED FROM THE SAME FILE SUPPLIED IN -f WITH SAME -k VALUE\n
                \t IF YOU DO NOT SUPPLY A BLOOM FILTER, ONE WILL BE CREATED (.bloom)\n
                -p  Bloom filter false positive rate (default -p 0.001, optional; increase to prevent memory allocation errors)\n
                -x  Turn off Bloom filter functionality (-x 1 = yes, default = no, optional)\n
                -v  Runs in verbose mode (-v 1 = yes, default = no, optional)
	";
	}

while getopts "f:s:m:d:k:t:j:o:e:l:a:z:b:r:p:x:v:" args; do
    case $args in
        f)
            f=${OPTARG}
	        f="draft=${f}"
            ;;
        s)
            s=${OPTARG}
	        s="readsFof=${s}"
            ;;
	    m)
            m=${OPTARG}
	        f="m=${m}"
            ;;
        d)
            d=${OPTARG}
	        d="d=${d}"
            ;;
        k)
            k=${OPTARG}
	        k="k=${k}"
            ;;
        t)
            t=${OPTARG}
	        t="t=${t}"
            ;;
	    o)
            o=${OPTARG}
	        o="o=${o}"
            ;;
        e)
            e=${OPTARG}
	        e="e=${e}"
            ;;
        l)
            l=${OPTARG}
	        l="l=${l}"
            ;;
        a)
            a=${OPTARG}
	        a="a=${a}"
            ;;
	    z)
            z=${OPTARG}
	        z="z=${z}"
            ;;
        b)
            b=${OPTARG}
	        b="b=${b}"
            ;;
        r)
            r=${OPTARG}
	        r="r=${r}"
            ;;
        p)
            p=${OPTARG}
	        p="p=${p}"
            ;;
	    x)
            x=${OPTARG}
	        x="x=${x}"
            ;;
        v)
            v=${OPTARG}
            v="v=${v}"
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Check if draft genome and long read fof is provided
if [ -z "${f}" ] || [ -z "${s}" ]; then
    usage
fi

echo Running Command: ./LINKS-make LINKS $f $s $m $d $k $t $o $e $l $a $z $b $r $p $x $v
# Running LINKS-make
./LINKS-make LINKS $f $s $m $d $k $t $o $e $l $a $z $b $r $p $x $v

