#!/bin/bash

passed_directory="$1"
if [ -z "$passed_directory" ];
then
	passed_directory="$(pwd)"
fi
echo "Going to validate binaries in $passed_directory"


# Find all executables without an extension - should be the binaries we want to check
find -L "$passed_directory" -type f -perm -a=x ! -name "*.*" -print0 | while read -d $'\0' file_to_check
do {
	echo "checking $file_to_check"
	nm -m -arch all "$file_to_check" | grep -q gcov
	if [ $? -eq 0 ]; then
		echo "Found GCC records in $file_to_check"
		exit 1
	fi

	otool -l -arch all "$file_to_check" | grep -q __llvm_prf
	if [ $? -eq 0 ]; then
		echo "Found LLVM records in $file_to_check, worth paying attention to"
		exit 1
	fi
}
done
