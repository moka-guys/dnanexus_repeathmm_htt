# Use python3 statistics package
import statistics
import glob

# Empty lists to hold all allele counts
allele1_all = []
allele2_all = []

# Function to read repeathmm results file and extract allele1 and 2 repeat counts 
def read_hmm_output(repeathmm_file):
	with open(repeathmm_file, 'r') as repeathmm_results:
		for line in repeathmm_results:
            # allele counts are on line that starts with 'HTT'
			if line.startswith('HTT'):
                # e.g
                # HTT	 18 50;
                # Split line on tabs and take second element to remove 'HTT',
                # strip whitespace from start/end of alleles, 
                # remove semi-colon and split the alleles on space
				results = line.split('\t')[1].strip().replace(';','').split(' ')
    # return allele1, allele2
	return int(results[0]), int(results[1])

# Loop through results files and extract results
for repeathmm_file in glob.glob('/home/dnanexus/out/repeathmm_output/repeathmm_output/all_results/*.tsv'):
    allele1, allele2 = read_hmm_output(repeathmm_file)
    # Append allele counts to lists
    allele1_all.append(allele1)
    allele2_all.append(allele2)

# Sort the lists
allele1_all.sort()
allele2_all.sort()

# Get median, min, max and range for each allele
# Median can be a .5 decimal e.g. if list was [1,2,2,3,3,3] median would be 2.5
# Therefore round the result to whole number
allele1_median = round(statistics.median(allele1_all))
allele1_min = allele1_all[0] # First element in list
allele1_max = allele1_all[-1] # Last element in list
allele1_range = allele1_max - allele1_min
allele1_range_formatted = '{range} ({min} to {max})'.format(range=allele1_range, min=allele1_min, max=allele1_max)
allele2_median = round(statistics.median(allele2_all))
allele2_min = allele2_all[0] # First element in list
allele2_max = allele2_all[-1] # Last element in list
allele2_range = allele2_max - allele2_min
allele2_range_formatted = '{range} ({min} to {max})'.format(range=allele2_range, min=allele2_min, max=allele2_max)

# Write to output. Use map to convert integers to strings.
with open('/home/dnanexus/repeathmm_results_summary.csv', 'w') as output:
    output.write(','.join(map(str, ['allele1_median', 'allele2_median', '', 'allele1_range', 'allele2_range\n'])))
    output.write(','.join(map(str, [allele1_median, allele2_median, '', allele1_range_formatted, allele2_range_formatted])))