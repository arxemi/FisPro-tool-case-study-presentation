#!/bin/bash

hfp_method() {
	month=$1
	cd $month
	ols "consumption_${month}_train.csv" -q10 -p"consumption_${month}_test.csv" -b"consumption_${month}_test.csv"
    perf "consumption_${month}_train.csv.fis" "consumption_${month}_test.csv"
    sed -n 2p "result.perf" >> "../${result_file}"
    cd ..
}


header_result=" Name  &  PI  &   CI  &   maxE  & In 1 & In 2 & In 3 & In 4 & In 5 & In 6 & In 7 & In 8 & In 9 & In 10 & In 11 & Out 1 &  Out  &   maxR  &   nR  &   maxVr &   meanVr &  nVar &  meanMF"

declare -a months=("JAN" "FEB" "MAR" "APR" "MAY" "JUN" "JUL" "AUG" "SEP" "OCT" "NOV" "DEC")

output=$1
result_file="ols.result"

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
			rm -f *".fis" *".mat" *".ols" *".perf" *".res"
			cd ..
		done
	fi
else
	echo "OLS method:
		Argument:
			-month(ex JAN) or 'all'.
			 
		Enter --clean to remove result file"
fi
echo