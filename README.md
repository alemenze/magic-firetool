# RNA-seq Visualization with Shiny
![GitHub last commit](https://img.shields.io/github/last-commit/alemenze/magic-firetool)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![made with Shiny](https://img.shields.io/badge/R-Shiny-blue)](https://shiny.rstudio.com/)

## Running the App
This Shiny App has been built in to a docker container for easy deployment. You can build the image yourself (and thereby customize any ports you need) after downloading it:
```
docker build -t FIREtool .
docker run -d --rm -p 3838:3838 FIREtool
```
And it should be hosted at localhost:3838

## Input Data
The input data should be two files, the raw hitcount data and metadata table.

### Hitcount file
The hitcount file is designed to currently come from featureCounts or similar. The format should be as below, or can be viewed by the sample gene count file. It is important that the data input is the raw un-normalized hit counts. This workflow is based on DESeq2 which can get funky with normalized data. 

| Ensembl Gene ID | Gene Symbol | Counts for Sample 1 | Counts for Sample N |
|---	|---	|---	|---	|
| ENSMUSG00000029580 | Actb | 378000 | 344705 |

### Metadata file
The metadata file is more customizable and should be expanded to fit your experiment. At a minimum, the table should contain the sample names and 1 group of comparison. 

|  | Sample Name | Grouping1 | ExperimentVariable1 |
|---	|---	|---	|---	|
| Control1 | Control1 | Control | NoTreatment |