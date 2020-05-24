#!/bin/bash

# The human submission (wmt19.newstest2019.HUMAN.de-en) was provided in plain format
# This scripts converts is to SGM

perl ../../../third/wrap-xml.perl en newstest2019-deen-src.de.sgm HUMAN < wmt19.newstest2019.HUMAN.de-en > wmt19.newstest2019.HUMAN.de-en.sgm
