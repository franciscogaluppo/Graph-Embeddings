import csv
from sys import argv

script, input_file, output_file = argv

with open(input_file, "r") as inp:
    inp = csv.reader(inp, delimiter='\t')
    with open(output_file, "w") as out:
        for line in inp:
            out.write("{} {}\n".format(line[0], line[1]))