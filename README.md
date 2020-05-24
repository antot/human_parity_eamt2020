ABOUT
-----

This repository contains supplementary material for the publication:

Antonio Toral. 2020. [Reassessing Claims of Human Parity and Super-Human Performance in Machine Translation at WMT 2019](https://arxiv.org/abs/2005.05738). EAMT.


CONTENTS
--------

- **bin/** scripts
  - **appraise_prepare_files.py** prepares sgm files from WMT to the format required by Appraise for relative ranking
  - **appraise_export.sh** exports files from Appraise and calculates inter-annotator agreement 
  - **sign_tests.Rmd** sign tests (code)
  - **sign_tests.html** sign tests (resulting HTML notebook)

- **data/** data sets used in the experiments
  - **appraise_export/** data exported from Appraise
  - **appraise_import/** data imported into Appraise
  - **wmt/** data sets from WMT (source texts, reference translations and MT outputs)
  - **questionnaire.csv** answers to the post-experiment questionnaire

- **third/** third-party code

