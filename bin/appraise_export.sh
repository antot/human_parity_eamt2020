#!/bin/bash

# 20191116. Adapted from previous code from Toral et al. at WMT18

set -u

WDIR=../data/appraise_export/
TSKILL=$PWD/../third/wmt-trueskill


#----------------------------------------------------------------------------
# convert a non-3-way export file from Appraise
function conversion {
	INPUT=$1
	OUTPUT=$2

	2>&1 echo "Converting $INPUT -> $OUTPUT"
	cat $INPUT.xml | \
		# CODE TO ANONIMISE THE DATA
		> $OUTPUT.xml
	python $TSKILL/data/xml2csv_custom.py $OUTPUT.xml
}

# convert a 3-way export file from Appraise
function conversion_3way {
	INPUT=$1
	OUTPUT=$2

	2>&1 echo "Converting $INPUT -> $OUTPUT"
	cat $INPUT.xml | \
		# CODE TO ANONIMISE THE DATA
		> $OUTPUT.xml
	python $TSKILL/data/xml2csv_3way_custom.py $OUTPUT.xml
}


# convert all Appraise export files (20 documents for each translation direction)
function conversions {
	cd $WDIR

	#----- deen (complete, 2 translators + 1 non-translator)
	DIR=deen
	for i in $(seq 1 9); do
		conversion $DIR/exported-task-w19_deen_00$i-2020-02-16 $DIR/deen_00$i
	done
	for i in $(seq 10 20); do
		conversion $DIR/exported-task-w19_deen_0$i-2020-02-16 $DIR/deen_0$i
	done


	#----- ende (complete, 2 translators + 3 non-translators)
	DIR=ende
	for i in $(seq 1 9); do
		conversion_3way $DIR/exported-task-w19_ende_00$i-2019-12-04 $DIR/ende_00$i
	done
	for i in $(seq 10 20); do
		conversion_3way $DIR/exported-task-w19_ende_0$i-2019-12-04 $DIR/ende_0$i
	done


	#----- enru (complete, 4 translators + 2 non-translators)
	DIR=enru
	for i in $(seq 1 9); do
		conversion_3way $DIR/exported-task-w19_enru_00$i-2020-02-16 $DIR/enru_00$i
	done
	for i in $(seq 10 20); do
		conversion_3way $DIR/exported-task-w19_enru_0$i-2020-02-16 $DIR/enru_0$i
	done
}

#----------------------------------------------------------------------------

# Extract sets of judgements according to annotator
function judgement_sets {
	cd $WDIR

	#----- deen
	DIR=deen
	head -1 $DIR/deen_001.csv > $DIR/deen_001_020.csv
	cat $DIR/deen_???.csv | grep -v "^system2" \
	>> $DIR/deen_001_020.csv

	cat $DIR/deen_001_020.csv | grep -v "w19_deen_u1" > $DIR/deen_001_020.ts.csv
	cat $DIR/deen_001_020.csv | grep -v "w19_deen_t1" | grep -v "w19_deen_u1" > $DIR/deen_001_020.t2.csv
	cat $DIR/deen_001_020.csv | grep -v "w19_deen_t2" | grep -v "w19_deen_u1" > $DIR/deen_001_020.t1.csv
	cat $DIR/deen_001_020.csv | grep -v "w19_deen_t1" | grep -v "w19_deen_t2" > $DIR/deen_001_020.u1.csv

	cat $DIR/deen_001_020.csv | grep -v "w19_deen_t1" > $DIR/deen_001_020.t2u1.csv
	cat $DIR/deen_001_020.csv | grep -v "w19_deen_t2" > $DIR/deen_001_020.t1u1.csv


	#----- ende
	DIR=ende
	head -1 $DIR/ende_001.csv > $DIR/ende_001_020.csv
	cat $DIR/ende_???.csv | grep -v "^system2" \
	>> $DIR/ende_001_020.csv

	cat $DIR/ende_001_020.csv | grep -v "w19_ende_t." > $DIR/ende_001_020.us.csv
	cat $DIR/ende_001_020.csv | grep -v "w19_ende_u." > $DIR/ende_001_020.ts.csv

	cat $DIR/ende_001_020.csv | grep -v "w19_ende_t2" | \
		grep -v "w19_ende_u." > $DIR/ende_001_020.t1.csv
	cat $DIR/ende_001_020.csv | grep -v "w19_ende_t1" | \
		grep -v "w19_ende_u." > $DIR/ende_001_020.t2.csv
	cat $DIR/ende_001_020.csv | grep -v "w19_ende_t." | \
		grep -v "w19_ende_u2" | grep -v "w19_ende_u3" > $DIR/ende_001_020.u1.csv
	cat $DIR/ende_001_020.csv | grep -v "w19_ende_t." | \
		grep -v "w19_ende_u1" | grep -v "w19_ende_u3" > $DIR/ende_001_020.u2.csv
	cat $DIR/ende_001_020.csv | grep -v "w19_ende_t." | \
		grep -v "w19_ende_u1" | grep -v "w19_ende_u2" > $DIR/ende_001_020.u3.csv


	#----- enru
	DIR=enru
	head -1 $DIR/enru_001.csv > $DIR/enru_001_020.csv
	cat $DIR/enru_???.csv | grep -v "^system2" \
	>> $DIR/enru_001_020.csv

	cat $DIR/enru_001_020.csv | grep -v "w19_enru_u." > $DIR/enru_001_020.ts.csv
	cat $DIR/enru_001_020.csv | grep -v "w19_enru_t." > $DIR/enru_001_020.us.csv


	cat $DIR/enru_001_020.csv | grep -v "w19_enru_t2" | \
		grep -v "w19_enru_t3" | grep -v "w19_enru_t4" | grep -v "w19_enru_u." > $DIR/enru_001_020.t1.csv
	cat $DIR/enru_001_020.csv | grep -v "w19_enru_t1" | \
		grep -v "w19_enru_t3" | grep -v "w19_enru_t4" | grep -v "w19_enru_u." > $DIR/enru_001_020.t2.csv
	cat $DIR/enru_001_020.csv | grep -v "w19_enru_t1" | \
		grep -v "w19_enru_t2" | grep -v "w19_enru_t4" | grep -v "w19_enru_u." > $DIR/enru_001_020.t3.csv
	cat $DIR/enru_001_020.csv | grep -v "w19_enru_t1" | \
		grep -v "w19_enru_t2" | grep -v "w19_enru_t3" | grep -v "w19_enru_u." > $DIR/enru_001_020.t4.csv
	cat $DIR/enru_001_020.csv | grep -v "w19_enru_u2" | \
		grep -v "w19_enru_t." > $DIR/enru_001_020.u1.csv
	cat $DIR/enru_001_020.csv | grep -v "w19_enru_u1" | \
		grep -v "w19_enru_t." > $DIR/enru_001_020.u2.csv
}


#----------------------------------------------------------------------------
# Note: ../third/compute_agreement_scores.py requires Python 2
function agreements {
	#----- deen
	echo "----- Agreements DE->EN -----"
	for F in $WDIR/deen/deen_001_020.csv $WDIR/deen/deen_001_020.ts.csv $WDIR/deen/deen_001_020.t1u1.csv $WDIR/deen/deen_001_020.t2u1.csv; do
		echo $F
		python ../third/compute_agreement_scores.py $F
	done
	echo
	# annotators	pA	pE	kappa
	# all		0.490  0.375  0.184
	# t1,t2		0.585  0.389  0.320
	# t1,u1		0.427  0.358  0.107
	# t2,u1		0.458  0.381  0.125


	#----- ende
	echo "----- Agreements EN->DE -----"
	for F in $WDIR/ende/ende_001_020.csv $WDIR/ende/ende_001_020.ts.csv $WDIR/ende/ende_001_020.us.csv; do
		echo $F
		python ../third/compute_agreement_scores.py --inter --verbose --pairwise $F
	done
	echo
	# annotators	pA	pE	kappa	agree	comparab   ties	   total
	# all		0.527  0.347  0.276     1586     3008      360     1507
	# t1,t2		0.553  0.337  0.326      166      300      170      602
	# u1,u2,u3	0.528  0.356  0.266      477      904      190      905


	#----- enru
	echo "----- Agreements EN->RU -----"
	for F in $WDIR/enru/enru_001_020.csv $WDIR/enru/enru_001_020.ts.csv $WDIR/enru/enru_001_020.us.csv; do
		echo $F
		python ../third/compute_agreement_scores.py --inter --verbose --pairwise $F
	done
	# annotators	pA	pE	kappa	agree	comparab   ties	   total
	# all		0.523  0.353  0.262     2297     4396      389     1785
	# ts (t1-t4)	0.504  0.348  0.239      873     1732      276     1181
	# us (u1,u2)	0.517  0.365  0.238      156      302      113      604
}




#conversions
judgement_sets
agreements
