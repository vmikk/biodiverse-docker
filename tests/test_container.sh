
## Build the docker image
docker build --tag biodiversedev --file Dockerfile_NoPerlbrew . 

## Get scripts and test data
mkdir -p /tmp/biodiverse_test
cd /tmp/biodiverse_test

wget https://raw.githubusercontent.com/vmikk/PhyloNext/refs/heads/main/bin/00_create_bds.pl
wget https://raw.githubusercontent.com/vmikk/PhyloNext/refs/heads/main/bin/00_create_bts.pl
wget https://raw.githubusercontent.com/vmikk/PhyloNext/refs/heads/main/bin/02_biodiverse_analyses.pl
wget https://raw.githubusercontent.com/vmikk/PhyloNext/refs/heads/main/bin/04_load_bds_and_export_results.pl

wget https://raw.githubusercontent.com/vmikk/PhyloNext/refs/heads/main/test_data/Biodiverse_tests/FelidaeCanidae_occurrences.csv
wget https://raw.githubusercontent.com/vmikk/PhyloNext/refs/heads/main/test_data/Biodiverse_tests/FelidaeCanidae_tree.nex


##### Run the docker image

## Create the bds file
docker run \
  --rm -it \
  -v /tmp/biodiverse_test:/__w \
  biodiversedev \
    perl /__w/00_create_bds.pl \
        --csv_file /__w/FelidaeCanidae_occurrences.csv \
        --out_file /__w/occ.bds \
        --label_column_number '0' \
        --group_column_number_x '1'\
        --cell_size_x '-1'

## Create the bts file
docker run \
  --rm -it \
  -v /tmp/biodiverse_test:/__w \
  biodiversedev \
    perl /__w/00_create_bts.pl \
        --input_tree_file /__w/FelidaeCanidae_tree.nex \
        --out_file /__w/tree.bts

## Run the biodiversity analyses
docker run \
  --rm -it \
  -v /tmp/biodiverse_test:/__w \
  biodiversedev \
    perl /__w/02_biodiverse_analyses.pl \
        --input_bds_file /__w/occ.bds \
        --input_bts_file /__w/tree.bts \
        --calcs calc_richness,calc_pd,calc_pe

## Load the bds file and export the results
docker run \
  --rm -it \
  -v /tmp/biodiverse_test:/__w \
  biodiversedev \
    perl /__w/04_load_bds_and_export_results.pl \
        --input_bds_file /__w/occ_analysed.bds \
        --output_csv_prefix /__w/RND

## Verify the results
head -5 RND_SPATIAL_RESULTS.csv


