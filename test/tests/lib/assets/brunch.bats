# Test the brunch asset plugin

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

@test "detects brunch is required if brunch-config.js is found" {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
  )"

  touch /tmp/code/brunch-config.js

  required=$(nodejs_is_brunch_required)

  [ "$required" = "true" ]
}

@test "determines brunch is not required if no brunch-config.js is found" {

  required=$(nodejs_is_brunch_required)

  [ "$required" = "false" ]
}

@test "prints brunch requirements when required" {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
  )"

  touch /tmp/code/brunch-config.js

  stub_and_echo "nodejs_is_brunch_required" "true"

  result=$(nodejs_detect_brunch_requirements 2>&1)

  expected="$(cat <<-END
   - found brunch-config.js
true
END
  )"

  restore "nodejs_is_brunch_required"

  [ "$result" = "$expected" ]
}
