import os

import argparse
import gzip
import urllib
import urllib.request

parser = argparse.ArgumentParser(description = "Searches selected databases against a specified pathogenic variant")
parser.add_argument("-p", "--position", help="Position formatted as chrom:start_pos:end_pos")
parser.add_argument("-m", "--match_type", choices=["exact", "left", "right", "within", "any"], help="Type of match: left extended (left), right extended (right), both sides extended (both) any overlap (any), exact location match (exact).")
parser.add_argument("-d", "--distance", type=int, help="Extend distance for any applicable match type. If not specified for an applicable match type, will default to 50% of length of allele.")
args = parser.parse_args()

position = args.position.split(":")
position = [int(x) for x in position]
match = args.match_type
if match != "exact":
    if args.distance:
        distance = args.distance
    else:
        distance = (position[1] - position[2])/2
    if match == "left":
        position[1] += distance
    elif match == "right":
        position[2] += distance
    elif match == "within" or match == "any":
        position[1] += distance
        position[2] += distance
position.append((position[1] + position[2]/2))

copy = []
clinical = []

def matchesonly(match, listval, position):
    '''Takes an a list of identified matches on a chromosome and a user input position, removes non-matches based on match criteria'''
    newlist = []
    for n in range(0,len(listval)):
        if match == "exact":
            if int(listval[n][1]) == int(position[1]) and int(listval[n][2]) == int(position[2]):
                newlist.append(listval[n])
        elif match == "any":
            if int(listval[n][1]) in range(int(position[1]), int(position[2])) or int(listval[n][2]) in range(int(position[1]), int(position[2])):
                newlist.append(listval[n])
        elif match == "within":
            if int(position[1]) >= int(listval[n][1]) and int(position[2]) <= int(listval[n][2]):
                newlist.append(listval[n])
        elif match == "left" or match == "right":
            half = int(listval[n][1]) - int(listval[n][2])/2
            if match == "left":
                if int(listval[n][2]) == int(position[2]) and (int(position[1]) - int(listval[n][2])) <= half:
                    newlist.append(listval[n])
            elif match == "right":
                if int(listval[n][1]) == int(position[1]) and (int(listval[n][1]) - int(position[2])) <= half:
                    newlist.append(listval[n])
    return(newlist)


if os.path.exists("./pathogenetemp/gnomad.vcf"):
    os.remove("./pathogenetemp/gnomad.vcf.gz")
if os.path.exists("./pathogenetemp/clintemp.tsv.gz"):
    os.remove("./pathogenetemp/clintemp.tsv.gz")
if not os.path.exists("./pathogenetemp"):
    os.mkdir("./pathogenetemp")


file = urllib.request.urlretrieve("https://storage.googleapis.com/gnomad-public/papers/2019-sv/gnomad_v2_sv.sites.vcf.gz", "./pathogenetemp/gnomad.vcf.gz")

with gzip.open("./pathogenetemp/gnomad.vcf.gz", "r") as f:
    for line in f:
        line = line.decode('ascii')
        if line[0:2] == "##":
            pass
        else:
            line = line.strip().split()
            if line[0] == str(position[0]):
                current = []
                if "MULTIALLELIC" in line: #Structure list
                    current.append(line[0]) # Chromosome
                    current.append(line[1]) # Start position
                    info = line[7].split(";")
                    for end in info:
                        if "END=" in end:
                            current.append(end[4:]) # End position
                    current.append(line[4]) # ALT
                    current.append(line[5]) # QUAL
                    copy.append(current)
os.remove("./pathogenetemp/gnomad.vcf.gz")

clinfile = urllib.request.urlretrieve("ftp://ftp.ncbi.nlm.nih.gov/pub/dbVar/data/Homo_sapiens/by_study/tsv/nstd102.GRCh37.variant_call.tsv.gz", "./pathogenetemp/clintemp.tsv.gz")

with gzip.open("./pathogenetemp/clintemp.tsv.gz", "r") as clin:
    clin.readline()
    clin.readline()
    for line in clin:
        current = []
        line = line.decode('utf-8')
        line = line.strip().split("\t")
        if str(line[7]) == str(position[0]):
            current.append(line[7]) #Chromosome
            starts = line[9:12] #Start position
            for x in starts:
                if x != "":
                    current.append(x)
                    break
            ends = reversed(line[12:15]) #End position
            for y in ends:
                if y != "":
                    current.append(y)
                    break
            current.append(line[18]) #Copy number
            for i in range(0,3):
                current.append(line[i]) #Variant call accession, id and type
            current.append(line[36]) # Clinical significance
            current.append(line[19]) #Description
            clinical.append(current)
os.remove("./pathogenetemp/clintemp.tsv.gz")

clinheader = ["Chromosome", "Start position", "End Position", "Copy number", "Variant call accession" "Variant call ID",  "Variant call type", "Clinical significance" "Description"]
healthyheader = ["Chromosome", "Start Position", "End Position", "Alternates", "Quality score"]

os.mkdir("./pathoGeneout")
with open("./pathoGeneout/gegnome.tsv", "w") as healthyout:
    healthyheader = "\t".join(healthyheader)
    healthyout.write(healthyheader)
    for x in copy:
        x = "\t".join(x)
        healthyout.write(x)

with open("./pathoGeneout/clinvar.tsv", "w") as clinout:
    clinheader = "\t".join(clinheader)
    clinout.write(clinheader)
    for x in clinical:
        x = "\t".join(x)
        clinout.write(x)
