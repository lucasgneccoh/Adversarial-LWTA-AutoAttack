#!/bin/bashh
# Add custom parameters here to make the call
# Use dictionary to make it more flexible (https://www.xmodulo.com/key-value-dictionary-bash.html
declare -A args

#args[epochs]="50"
#args[log_interval]="10"
args[model_dir]="./run_first_test&"
#args[train_nat]="bool:1"
#args[no_cuda]="bool:1"
#args[save_freq]="30"
args[data_path]="./data/cifar10"

# This can be obtained from the system
exe="python3"
script="train_cifar10.py"

cmd="$exe $script" 


# Need a function for this particular case because of the terrible name convention used

s_repl() {
	if [ $# -ne 3 ]; then
		exit
	else
		echo "$1" | sed "s/$2/$3/g"
	fi
}

bool_arg(){
	if [ $# -eq 0 ]; then
		return 0
	fi
	if [[ $1 =~ bool:* ]]; then
		return 1
	else
		return 0
	fi
}	

parse_arg(){
	if [ ! $# -eq 4 ]; then
		echo "$0: 4 arguments needed"
		exit
	fi
	local key=$1
	local value=$2
	local old_sep=$3
	local new_sep=$4
	# if boolean arg, then decide whether to add the key or not
	bool_arg $value
	# Get value returned by function bool_arg using #?
	local b=$?
	if [ $b -eq 1 ]; then
		local boo=${value#*:}
		if [ $boo="1" ]; then 
			echo " --$(s_repl $key $old_sep $new_sep)"
		else
			echo ""
		fi
	else
		echo " --$(s_repl $key $old_sep $new_sep) $value"
	fi
}



for key in "${!args[@]}"; do
	cmd="$cmd$(parse_arg $key ${args[$key]} "_" "-")"
done

echo $cmd
echo "----------------------"
eval $cmd
