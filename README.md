# soybean pan-3D genome analysis

## Summary

This repository contains scripts used in the analysis of soybean pan-3D genome. Scripts are provided as follows. However, there may be an effort in the future to translate this code into a program for streamlined analysis depending on demand.

Users should be aware that the majority of this code was designed for our specific use case, and as such, has been written to analyze the data sets detailed in the manuscript. Thus, all users should carefully look over the code to better understand if the default parameters make sense for your experiment/species/conditions/etc. You're more than welcome to post an issue or e-mail us if you have any questions about any part of the scripts.

## Subfolder information

* **hiCProcessing:** preprocess the Hi-C data including reads alignments, mapping statistics, and reproducibility scores, etc.

* **compartmentAnalysis:** calculate A/B compartment eigenvectors and I regions.

* **compartmentPanAnalysis:** pan-3D genome analysis of A/B compartments.

* **insulationBoundaryAnalysis:** call TADs using insulation score algorithm, arrowhead algorithm and calculate directionality index.

* **insulationBoundaryComparativeAnalysis:** comparative 3D genome analysis of insulation boundaries.

* **insulationBoundaryPanAnalysis:** pan-3D genome analysis of insulation boundaries.

* **enrichmentAnalysis:** GO enrichment analysis of insulation boundaries of pan-3D genome.

* **structuralVariationCompartment:** analyze structural variations of A/B compartments.

* **exampleCompartment:** example analysis of structural variations and A/B compartments.

* **structuralVariationInsulationBoundary:** analyze structural variations of insulation boundaries.

* **exampleInsulationBoundary:** example analysis of structural variations and insulation boundaries.

* **expressionAnalysis:** process RNA-seq data.

* **expressionCompartment:** RNA-seq analysis of A/B compartments.

* **expressionInsulationBoundary:** RNA-seq analysis of insulation boundaries.

* **figures:** plot the figures.

* **utility:** some general purpose functions.

## Additional scripts

This repository contains the major scripts used in the analysis. Requests for additional code can be made in the issues tab of this repository, or by contacting us by email (zxtian@genetics.ac.cn).

## LiftOver chain files

In addition to raw sequencing data available from GSA, we also provide liftOver chain files of ZH13 and other 26 soybean accessions on the database. The liftOver chain files can be found under the following URLs:

https://figshare.com/articles/dataset/UCSC_chain_files_of_soybean_genomes/20027336

## References

**Ni L**, Liu Y, Ma X, Liu T, Yang X, Wang Z, Liang Q, Liu S, Zhang M, Wang Z, et al. (2023). Pan-3D genome analysis reveals structural and functional differentiation of soybean genomes. Genome Biol 24, 12.
