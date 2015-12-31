# Test the gulp asset plugin

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

@test "detects gulp is required if gulpfile.js is found" {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
  )"

  touch /tmp/code/gulpfile.js

  required=$(nodejs_is_gulp_required)

  [ "$required" = "true" ]
}

@test "determines gulp is not required if no gulpfile.js is found" {

  required=$(nodejs_is_gulp_required)

  [ "$required" = "false" ]
}

@test "prints gulp requirements when required" {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
  )"

  touch /tmp/code/gulpfile.js

  stub_and_echo "nodejs_is_gulp_required" "true"

  result=$(nodejs_detect_gulp_requirements 2>&1)

  expected="$(cat <<-END
   - found gulpfile.js
true
END
  )"

  restore "nodejs_is_gulp_required"

  [ "$result" = "$expected" ]
}
