#/bin/sh
set -e
OUTPUT="$1"
rm -Rf ${OUTPUT} && mkdir ${OUTPUT}
FILES=$(pacman -Sp mingw-w64-{i686,x86_64}-{tcl,tk})
for FILE in $FILES
do
    curl -OL $FILE
	echo "Extracting: $(basename $FILE)"
	tar xf $(basename $FILE) -C ${OUTPUT}
	unlink $(basename $FILE)
done
rm -f $(find ${OUTPUT} -name *.a)
