# Test the broccoli asset plugin

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

@test "detects broccoli is required if Brocfile.js is found" {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
  )"

  touch /tmp/code/Brocfile.js

  required=$(nodejs_is_broccoli_required)

  [ "$required" = "true" ]
}

@test "determines broccoli is not required if no Brocfile.js is found" {

  required=$(nodejs_is_broccoli_required)

  [ "$required" = "false" ]
}

@test "prints broccoli requirements when required" {

 stub_and_echo "nodejs_is_broccoli_required" "true"

 result=$(nodejs_detect_broccoli_requirements 2>&1)

 expected="$(cat <<-END
   - found Brocfile.js
true
END
  )"

 restore "nodejs_is_broccoli_required"

 [ "$result" = "$expected" ]
}
