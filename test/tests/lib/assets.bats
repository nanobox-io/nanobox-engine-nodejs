# Test the asset plugin api

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

@test "delegates function call to plugins" {

  call_count=0
  stub_and_eval "nodejs_bower_foo" "((call_count+=1))"
  stub_and_eval "nodejs_broccoli_foo" "((call_count+=1))"
  stub_and_eval "nodejs_brunch_foo" "((call_count+=1))"
  stub_and_eval "nodejs_grunt_foo" "((call_count+=1))"
  stub_and_eval "nodejs_gulp_foo" "((call_count+=1))"

  _nodejs_delegate_to_plugins "foo"

  [ $call_count -eq 5 ]
}

@test "determines asset compilation is required if package.json exists" {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  touch /tmp/code/package.json

  required=$(_nodejs_is_asset_compilation_required)

  [ "$required" = "true" ]
}

@test "determines asset compilation required from a plugin" {
  stub_and_echo "nodejs_is_bower_required" "false"
  stub_and_echo "nodejs_is_broccoli_required" "false"
  stub_and_echo "nodejs_is_brunch_required" "true"
  stub_and_echo "nodejs_is_grunt_required" "false"
  stub_and_echo "nodejs_is_gulp_required" "false"

  required=$(_nodejs_is_asset_compilation_required)

  restore "nodejs_is_bower_required"
  restore "nodejs_is_broccoli_required"
  restore "nodejs_is_brunch_required"
  restore "nodejs_is_grunt_required"
  restore "nodejs_is_gulp_required"

  [ "$required" = "true" ]
}

@test "determines asset compilation is not required from plugins" {
  stub_and_echo "nodejs_is_bower_required" "false"
  stub_and_echo "nodejs_is_broccoli_required" "false"
  stub_and_echo "nodejs_is_brunch_required" "false"
  stub_and_echo "nodejs_is_grunt_required" "false"
  stub_and_echo "nodejs_is_gulp_required" "false"

  required=$(_nodejs_is_asset_compilation_required)

  restore "nodejs_is_bower_required"
  restore "nodejs_is_broccoli_required"
  restore "nodejs_is_brunch_required"
  restore "nodejs_is_grunt_required"
  restore "nodejs_is_gulp_required"

  [ "$required" = "false" ]
}

@test "reports javascript requirements when dependencies are met" {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  touch /tmp/code/package.json

  stub_and_echo "nodejs_detect_bower_requirements" "false"
  stub_and_echo "nodejs_detect_broccoli_requiements" "false"
  stub_and_echo "nodejs_detect_brunch_requirements" "false"
  stub_and_echo "nodejs_detect_grunt_requirements" "false"
  stub_and_echo "nodejs_detect_gulp_requirements" "false"

  output=$(_nodejs_detect_asset_requirements 2>&1)

  expected="$(cat <<-END
+> Detecting javascript requirements
   - found package.json
true
END
  )"

  restore "nodejs_detect_bower_requirements"
  restore "nodejs_detect_broccoli_requiements"
  restore "nodejs_detect_brunch_requirements"
  restore "nodejs_detect_grunt_requirements"
  restore "nodejs_detect_gulp_requirements"

  [ "$output" = "$expected" ]
}

@test "reports no javascript requirements when dependencies are not met" {
  stub_and_echo "nodejs_detect_bower_requirements" "false"
  stub_and_echo "nodejs_detect_broccoli_requiements" "false"
  stub_and_echo "nodejs_detect_brunch_requirements" "false"
  stub_and_echo "nodejs_detect_grunt_requirements" "false"
  stub_and_echo "nodejs_detect_gulp_requirements" "false"

  output=$(_nodejs_detect_asset_requirements 2>&1)

  expected="$(cat <<-END
+> Detecting javascript requirements
   - no javascript integration required
false
END
  )"

  restore "nodejs_detect_bower_requirements"
  restore "nodejs_detect_broccoli_requiements"
  restore "nodejs_detect_brunch_requirements"
  restore "nodejs_detect_grunt_requirements"
  restore "nodejs_detect_gulp_requirements"

  [ "$output" = "$expected" ]
}

@test "detect lib_dirs adds node_modules to lib_dirs if package.json is present" {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
  )"

  touch /tmp/code/package.json

  stub "_nodejs_delegate_to_plugins"

  nodejs_detect_asset_lib_dirs

  restore "_nodejs_delegate_to_plugins"

  [ "${nodejs_asset_lib_dirs[@]}" = "node_modules" ]
}

@test "serializes asset_lib_dirs into json" {
  stub "nodejs_detect_asset_lib_dirs"

  nodejs_asset_lib_dirs=("bower_components" "node_modules")

  json="$(nodejs_asset_lib_dirs_json)"

  restore "nodejs_detect_asset_lib_dirs"


  [ "$json" = "[ \"bower_components\",\"node_modules\" ]" ]
}

@test "won't compile assets if compilation isn't necessary" {

  delegated="false"
  stub_and_echo "_nodejs_is_asset_compilation_required" "false"
  stub_and_eval "_nodejs_delegate_to_plugins" "delegated=\"true\""

  nodejs_compile_assets

  restore "_nodejs_is_asset_compilation_required"
  restore "_nodejs_delegate_to_plugins"

  [ "$delegated" = "false" ]
}

@test "delegates asset compilation if compilation is required" {
  delegated="false"
  stub_and_echo "_nodejs_is_asset_compilation_required" "true"
  stub_and_eval "_nodejs_delegate_to_plugins" "delegated=\"true\""

  nodejs_compile_assets

  restore "_nodejs_is_asset_compilation_required"
  restore "_nodejs_delegate_to_plugins"

  [ "$delegated" = "true" ]
}

@test "won't configure assets if configuration isn't necessary" {

  delegated="false"
  stub_and_echo "_nodejs_is_asset_compilation_required" "false"
  stub_and_eval "_nodejs_delegate_to_plugins" "delegated=\"true\""
  stub "nodejs_npm_install"

  nodejs_configure_asset_environment

  restore "_nodejs_is_asset_compilation_required"
  restore "_nodejs_delegate_to_plugins"
  restore "nodejs_npm_install"

  [ "$delegated" = "false" ]
}

@test "delegates asset configuration if configuration is required" {

  delegated="false"
  stub_and_echo "_nodejs_is_asset_compilation_required" "true"
  stub_and_eval "_nodejs_delegate_to_plugins" "delegated=\"true\""
  stub "nodejs_npm_install"

  nodejs_configure_asset_environment

  restore "_nodejs_is_asset_compilation_required"
  restore "_nodejs_delegate_to_plugins"
  restore "nodejs_npm_install"

  [ "$delegated" = "true" ]
}

@test "won't prepare assets if prep isn't necessary" {

  delegated="false"
  stub_and_echo "_nodejs_detect_asset_requirements" "false"
  stub_and_eval "_nodejs_delegate_to_plugins" "delegated=\"true\""
  stub "nodejs_install_runtime"

  nodejs_prepare_asset_runtime

  restore "_nodejs_detect_asset_requirements"
  restore "_nodejs_delegate_to_plugins"
  restore "nodejs_install_runtime"

  [ "$delegated" = "false" ]
}

@test "delegates asset preparation if prep is required" {

  delegated="false"
  stub_and_echo "_nodejs_detect_asset_requirements" "true"
  stub_and_eval "_nodejs_delegate_to_plugins" "delegated=\"true\""
  stub "nodejs_install_runtime"

  nodejs_prepare_asset_runtime

  restore "_nodejs_detect_asset_requirements"
  restore "_nodejs_delegate_to_plugins"
  restore "nodejs_install_runtime"

  [ "$delegated" = "true" ]
}
