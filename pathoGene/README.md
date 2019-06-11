# pathoGene

## What does it do?

##### This tool allows a user to take the coordinate of a structural variant (SV) and compare it to SVs in ClinVar and gnomAD.  Once there are matches identified, a pathogenicity score is calculated based on ClinVar assertions and gnomAD frequencies.  

``` 
It outputs a report that contains 
* A description of the ClinVar Variant
* An overall and population specific frequency from gnomAD
* The original query information 
```

## How do you use it?

##### The chromosome and position are put in on the command line.  A fuzzy matching algorithm is implemented (see the paper for more details).    

```
List of flags:
* "-p", "--position", help="Position formatted as chrom:start_pos:end_pos"
* "-m", "--match_type", choices=["exact", "left", "right", "within", "any"], help="Type of match: left extended (left), right extended (right), both sides extended (both) any overlap (any), exact location match (exact)."
* "-d", "--distance", type=int help="Extend distance for any applicable match type"
```

## Example Input

```
HERE
```

![Alt text](https://github.com/NCBI-Hackathons/Computational_Medicine_1/blob/master/pathoGene/pathoGene.jpg)

## You're awesome.

## Example Output
```
pathoGene Score Report
----------------------

Query interval (GRCh37):    14:12365544-12428839 (63,296 bp)

pathoGene Score:            +2 (some evidence for ‘Pathogenic’)

Your query overlapped the following variants:

Source    ID.           Location           % Overlap   Score Contribution   Reason
----------------------------------------------------------------------------------------
ClinVar   SCV0003454    14:76876-2787383     100%           +3              Likely path.
gnomAD    gnomad_2_etc  14:236863-2763461     45%           -1              AF >0.01
					
Total Score = +2	
```

