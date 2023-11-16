#!/bin/bash

outdir=$1
counts_type=$2 # counts or counts.aa
counts_dir="$1/$2"

# Get the maximum round
max_round=0
for file in "$counts_dir"/*-out*_$counts_type.txt; do
    filename=$(basename "$file")
    round=${filename%%-out_*}
    if [ $round -gt $max_round ]; then
        max_round=$round
    fi
done

in_format="*-in*_$counts_type.txt"
neg_format="*-neg*_$counts_type.txt"
# Check if there are any files matching the format "*-in*_counts.txt"
if [ ! -n "$(find "$counts_dir" -name "$in_format" -print -quit)" ]; then
    # Cases 1A and 1B: Loop up to max_round - 1
    for ((i = 1; i < max_round; i++)); do
        # Run the modified_counts_bash.sh script with the appropriate arguments
        if [ ! -n "$(find "$counts_dir" -name "$neg_format" -print -quit)" ]; then
          python3 ./scripts_enrichments/modified_counts.py -out "$counts_dir/$i-out"*"_$counts_type.txt" -res "modified_counts/$i-res.txt"
        else
          python3 ./scripts_enrichments/modified_counts.py -out "$counts_dir/$i-out"*"_$counts_type.txt" -neg "$counts_dir/$(($i + 1))-neg"*"_$counts_type.txt" -res "modified_counts/$i-res.txt"
        fi
    done
else
    # Case 2A and 2B: Loop up to max_round
    for ((i = 1; i <= max_round; i++)); do
        # Run the modified_counts_bash.sh script with the appropriate arguments
        if [ ! -n "$(find "$counts_dir" -name "$neg_format" -print -quit)" ]; then
          python3 ./scripts_enrichments/modified_counts.py -in "$counts_dir/$i-in*_$counts_type.txt" -out "$counts_dir/$i-out"*"_$counts_type.txt" -res "modified_counts/$i-res.txt"
        else
          python3 ./scripts/modified_counts.py -in "$counts_dir/$i-in"*"_$counts_type.txt" -out "$counts_dir/$i-out"*"_$counts_type.txt" -neg "$counts_dir/$i-neg"*"_$counts_type.txt" -res "$outdir/modified_counts/$i-res.txt"
        fi
    done
fi

