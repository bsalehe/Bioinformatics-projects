in_file = "./chrom_names.txt"

for line in $(cat in_file)
do
  sed -i 's/gi|556503834|ref|NC_000913.3|/Chromosome/g' "$f"
  echo "Processing $f"
done

