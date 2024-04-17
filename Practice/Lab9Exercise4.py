import re
dna = "601 accacac gacgag gtattag"
dna1 = re.sub(r"[\d\s]", "", dna)
print(dna1)
dna2 = re.subn('t', 'u', dna1)
print(dna2)
print(dna2[1])

# This code substitutes the spaces and numbers with a "no space". This puts all the nucleotides together in line.
# It also substitutes the "t" for "u" which turns the original DNA sequence into an RNA sequence.
