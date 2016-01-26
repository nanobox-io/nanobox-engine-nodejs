# Test the grunt asset plugin

# source the Nos framework
. /opt/nos/common.sh

# source the nos test helper
. util/nos.sh

# source stub.sh to stub functions and binaries
. util/stub.sh

# initialize nos
nos_init

# source the nodejs libraries
. ${engine_lib_dir}/nodejs.sh

setup() {
  rm -rf /tmp/code
  mkdir -p /tmp/code
  nos_reset_payload
  nodejs_asset_lib_dirs=()
}

@test "detects grunt is required if Gruntfile.js is found" {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
  )"

  touch /tmp/code/Gruntfile.js

  required=$(nodejs_is_grunt_required)

  [ "$required" = "true" ]
}

@test "determines grunt is not required if no Gruntfile.js is found" {

  required=$(nodejs_is_grunt_required)

  [ "$required" = "false" ]
}

@test "prints grunt requirements when required" {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
  )"

  touch /tmp/code/Gruntfile.js

  stub_and_echo "nodejs_is_grunt_required" "true"

  result=$(nodejs_detect_grunt_requirements 2>&1)

  expected="$(cat <<-END
   - found Gruntfile.js
true
END
  )"

  restore "nodejs_is_grunt_required"

  [ "$result" = "$expected" ]
}
