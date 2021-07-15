#!/bin/bash

hfp_method() {
	month=$1
	cd $month
    hfpsr "consumption_${month}_train.csv" "${mf} ${mf} ${mf} ${mf} ${mf} ${mf} ${mf} ${mf} ${mf} ${mf} ${mf}" 1 0.01 $mf 1 MeanMax sum 0.01
    hfpselect "consumption_${month}_train.csv" "consumption_${month}_train.csv.hfp" -b0.7 -e2 -m0.3 -l"consumption_${month}_train.csv.vertex" -v"consumption_${month}_test.csv"
    sed -n 2,12p "result.min" >> "../${result_file}"
    sed -n 12p "result.min" >> "../${best_result_file}"
    cd ..
}

header_hpf_result="Name  &  PI  &   CI  &   maxE  & In 1 & In 2 & In 3 & In 4 & In 5 & In 6 & In 7 & In 8 & In 9 & In 10 & In 11 & Out 1 &  Out  &   maxR  &   nR  &   maxVr &   meanVr &  nVar &  meanMF"

declare -a months=("JAN" "FEB" "MAR" "APR" "MAY" "JUN" "JUL" "AUG" "SEP" "OCT" "NOV" "DEC")

help=$"HFP method:
	Arguments:
		-month (ex JAN) or 'all' to compute over all months
		-number of MF for each variable.
			 
	Enter only '--clean' to remove all result file"

output=$1
mf=$2
result_file="hfp_${mf}mf.result"
best_result_file="hfp_${mf}mf_best.result"

if [ ! -z "${output}" ]; then
	if [ "$output" == "all" ]; 
	then
		if ! test -f $result_file; then
			echo $header_hpf_result > $result_file
			echo $header_hpf_result > $best_result_file
		fi
		for m in ${months[@]}; do
			hfp_method $m
		done
	elif [[ " ${months[*]} " == *${output}* ]]; 
	then
		if ! test -f $result_file; then
			echo $header_hpf_result > $result_file
			echo $header_hpf_result > $best_result_file
		fi
		hfp_method $output
	elif [ "$output" == "--clean" ]; 
	then
		rm -f *".result"
		for m in ${months[@]}; do
			cd $m
			rm -f *".fis" *".vertex" *".hfp" "result" "result.min" 
			cd ..
		done
	else
		echo "$help"
	fi
else
	echo "$help"
fi
echo