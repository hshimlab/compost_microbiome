# 1. match TATA or nothing
# 2. match TATAA followed by A or T  (such motifs are called TATA boxes)
# 3. match 3-mer consisting of the dimer CG that is not immediately followed by C or G

# 1. r'TATA'
# 2. TATAA[A|T]
# 3. CG[^C|G]
