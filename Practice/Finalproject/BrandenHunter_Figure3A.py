# Use python gallery
# look at pathogenic bacteria in the infected blood/feces samples
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Dataframes
df1 = pd.read_csv("TrypanosomeBlood_Control-counts-species.csv")
df2 = pd.read_csv("TrypanosomeBlood2-counts-species.csv")
df3 = pd.read_csv("Feces_Control-counts-species.csv")
df4 = pd.read_csv('Feces_Infected-counts-species.csv')

# Filtering for Terms
strings_to_filter = ['Salmonella', 'Klebsiella', 'Escherichia', 'Shigella', 'Staphylococcus', 'Clostridium',
                    'Streptomyces', 'Pseudomonas']
filtered_df1 = df1[df1['species'].str.contains('|'.join(strings_to_filter))]
filtered_df2 = df2[df2['species'].str.contains('|'.join(strings_to_filter))]
filtered_df3 = df3[df3['species'].str.contains('|'.join(strings_to_filter))]
filtered_df4 = df4[df4['species'].str.contains('|'.join(strings_to_filter))]

# Y-values
agg_df1 = filtered_df1['fastq'].sum()
agg_df2 = filtered_df2['fastq'].sum()
agg_df3 = filtered_df3['fastq'].sum()
agg_df4 = filtered_df4['fastq'].sum()

# Scale of Chart
plt.figure(figsize=(10, 6))
bar_width = 0.5
index = np.arange(4)

# Create Chart
bars = plt.bar(index, [agg_df1, agg_df2, agg_df3, agg_df4], bar_width, color=['blue', 'green', 'red', 'orange'],
               alpha=0.7)
# Labeling
for bar in bars:
    plt.text(bar.get_x() + bar.get_width() / 2, bar.get_height(), str(int(bar.get_height())), ha='center', va='bottom')
plt.xlabel('Experimental Samples')
plt.ylabel('Fastq Counts for Pathogenic Bacteria')
plt.title('Comparison of Fastq Counts for Potentially Pathogenic Bacteria Between Samples')
plt.xticks(index, ['Mouse Blood Control ', 'Trypanosome Infected Blood', 'Control Feces',
                   'Trypanosome Infected Feces'])
plt.tight_layout()
plt.show()
