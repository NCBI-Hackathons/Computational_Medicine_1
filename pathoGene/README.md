#pathoGene

## What does it do?

##### This tool allows a user to take the coordinate of a structural variant (SV) and compare it to SVs in ClinVar and GNOMAD!  Once there are matches identified, a pathogenicity score is calculated based on ClinVar assertions and GNOMAD frequencies!  

``` 
It outputs a report that contains 
* A description of the ClinVar Variant
* An overall and population specific frequency from GNOMAD
* The original query information 
```

## How do you use it?

##### The chromosome and position are put in on the command line.  A fuzzy matching algorithm is implemented (see the paper for more details).    

```
List of flags:
* "-p", "--position", help="Position formatted as chrom:start_pos:end_pos"
* "-m", "--match_type", choices=["exact", "left", "right", "both", "any"], help="Type of match: left extended (left), right extended (right), both sides extended (both) any overlap (any), exact location match (exact)."
* "-d", "--distance", type=int help="Extend distance for any applicable match type"
```

## Example Input

```
HERE
```

## You're awesome.  
