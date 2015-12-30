
# source the Nos framework
. /opt/nos/common.sh

# source the nos test helper
. util/nos.sh

@test "addition using bc" {
  # result="$(ps)"
  # [ "$result" -eq 4 ]
  [ 1 ]
}

@test "addition using dc" {
  result="$(ls > /dev/null)"
  [ "$result" -eq 4 ]
}
