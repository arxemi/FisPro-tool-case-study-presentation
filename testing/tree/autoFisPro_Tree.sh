#!/bin/bash

hfp_method() {
	month=$1
	cd $month
    hfpsr "consumption_${month}_train.csv" "${mf} ${mf} ${mf} ${mf} ${mf} ${mf} ${mf} ${mf} ${mf} ${mf} ${mf}" 1 0.01 $mf 1 MeanMax sum 0.01
    fistree "consumption_${month}_train.csv-sr.fis" "consumption_${month}_train.csv" -p1 -v"consumption_${month}_test.csv" -z"consumption_${month}_test.csv"
    sed -n 2,3p "result.fistree" >> "../${result_file}"
    cd ..
}

header_result="Name  &  PI  &   CI  &   maxE  & In 1 & In 2 & In 3 & In 4 & In 5 & In 6 & In 7 & In 8 & In 9 & In 10 & In 11 & Out 1 &  Out  &   maxR  &   nR  &   maxVr &   meanVr &  nVar &  meanMF & (class/MF)  &  nRc  & (class/MF)  &  nRc  & (class/MF)  &  nRc  AttItAv & AttItMax & FcardAv & FcardMax & EDweAv & (VarNum) & Times & avRank & (VarNum) & Times & avRank & (VarNum) & Times & avRank & (VarNum) & Times & avRank & (VarNum) & Times & avRank & (VarNum) & Times & avRank & (VarNum) & Times & avRank & (VarNum) & Times & avRank & (VarNum) & Times & avRank & (VarNum) & Times & avRank & (VarNum) & Times & avRank"

declare -a months=("JAN" "FEB" "MAR" "APR" "MAY" "JUN" "JUL" "AUG" "SEP" "OCT" "NOV" "DEC")

output=$1
mf=$2
result_file="tree_${mf}mf.result"

if [ ! -z "${output}" ]; then
	if [ "$output" == "all" ]; 
	then
		if ! test -f $result_file; then
			echo $header_result > $result_file
		fi
		for m in ${months[@]}; do
			hfp_method $m
		done
	elif [[ " ${months[*]} " == *${output}* ]]; 
	then
		if ! test -f $result_file; then
			echo $header_result > $result_file
		fi
		hfp_method $output
	elif [ "$output" == "--clean" ]; 
	then
		rm -f $result_file
		for m in ${months[@]}; do
			cd $m
			rm -f *".fis" *".perf" *".tree" *".fistree" *".vertex" *".hfp"
			cd ..
		done
	fi
else
	echo "Fuzzy decision tree method:
		Arguments:
			-month (ex JAN) or 'all' to compute over all months
			-number of MF for each variable.

		Enter --clean to remove result file"
fi
echo