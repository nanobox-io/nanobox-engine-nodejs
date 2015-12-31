# Test the bower asset plugin

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

@test "detects bower is required if bower.json is found" {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
  )"

  touch /tmp/code/bower.json

  required=$(nodejs_is_bower_required)

  [ "$required" = "true" ]
}

@test "determines bower is not required if no bower.json is found" {

  required=$(nodejs_is_bower_required)

  [ "$required" = "false" ]
}

@test "prints bower requirements when required" {

 stub_and_echo "nodejs_is_bower_required" "true"

 result=$(nodejs_detect_bower_requirements 2>&1)

 expected="$(cat <<-END
   - found bower.json
true
END
  )"

 restore "nodejs_is_bower_required"

 [ "$result" = "$expected" ]
}

@test "adds bower_components to asset_lib_dirs if bower is required" {

  stub_and_echo "nodejs_is_bower_required" "true"

  nodejs_bower_detect_lib_dirs

  [ "${nodejs_asset_lib_dirs[@]}" = "bower_components" ]
}
