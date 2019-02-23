#!/bin/sh

case "$BASH" in
	*/bash)
		isBash=true
		;;
	*)
		isBash=false
		;;
esac

# Let's define some colors
if [ ${isBash} = true ]
then
	clr_red=$'\e[1;31m'
	clr_end=$'\e[0m'
else
	clr_red=''
	clr_end=''
fi

usage() {
    echo 'Usage:'
    echo '  build.sh [flags]'
    echo
    echo 'flags:'
    echo '  -h  display this help message and exit'
    echo '  -p  pack build results into tar.gz archive'
}

pack=false

while getopts ":ph" opt; do
	case ${opt} in
	    h)
	        usage
	        exit
	        ;;
		p)
			pack=true
			;;
		\?)
			printf "${clr_red}ERROR: Unrecognized option -$OPTARG${clr_end}\n" 1>&2
			usage
			exit 1
			;;
	esac
done

currentDir=$(dirname "$0")

outDir="$currentDir/dist/kmeldb-cli"
if [ ! -d "$outDir" ]
then
	mkdir -p "$outDir"
else
	rm -r -f "$outDir/"*
fi

rsync -a --exclude-from="$currentDir/kmeldb-exclude.txt" "$currentDir/kmeldb" "$outDir"
cp "$currentDir/DapGen.py" "$outDir"
cp "$currentDir/KenwoodDBReader.py" "$outDir"
cp "$currentDir/LICENSE" "$outDir"

echo Build has been successful.

if [ ${pack} = true ]
then
    echo Packing...

    cd "$outDir"
    tar -czf "../kmeldb-cli.tar.gz" *
    cd -
fi