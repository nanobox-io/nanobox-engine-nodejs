#!/bin/bash
FAILED=0
VERSION=$1

echo "VERSION: ${VERSION}"

for file in `find . -type f -name '*_test.sh'`; do
  echo running $file
  FOLDER=`dirname $0`
  read -r -d '' TEST <<EOF
. $FOLDER/util/bash_help.sh
. $file $VERSION 2>&1
EOF
  echo "$TEST"
  echo "------"
  # bash -c "$TEST" | awk '{print " "$0}'
  # if [ "${PIPESTATUS[0]}" != "0" ]; then
  #   echo test "$file" failed to run correctly
  #   let FAILED=FAILED+1
  # fi
done

# if [ "$FAILED" == "0" ]; then
#   echo "all tests passed"
#   exit 0
# else
#   echo "$FAILED test failed to run"
#   exit 1
# fi
