# Test the runtime selection

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
}

@test "detects runtime from package.json" {
  skip
  # todo: implement functionality
}

@test "default runtime uses package.json if available" {

  stub_and_echo "nodejs_package_json_runtime" "nodejs-from-package-json"

  default=$(nodejs_default_runtime)

  restore "nodejs_package_json_runtime"

  [ "$default" = "nodejs-from-package-json" ]
}

@test "default runtime falls back to a hard-coded default" {

  stub_and_echo "nodejs_package_json_runtime" "false"

  default=$(nodejs_default_runtime)

  restore "nodejs_package_json_runtime"

  [ "$default" = "nodejs-4.2" ]
}

@test "runtime is chosen from the Boxfile if present" {

    nos_init "$(cat <<-END
{
  "boxfile": {
    "nodejs_runtime": "boxfile-runtime"
  }
}
END
)"

  runtime=$(nodejs_runtime)

  [ "$runtime" = "boxfile-runtime" ]
}

@test "runtime falls back to default runtime" {

  stub_and_echo "nodejs_default_runtime" "default-runtime"

  default=$(nodejs_default_runtime)

  restore "nodejs_package_json_runtime"

  [ "$default" = "default-runtime" ]
}

@test "won't install node if already installed" {

  called="false"

  stub_and_echo "nodejs_is_node_installed" "true"

  stub_and_eval "nos_install" "called=\"true\""

  nodejs_install_runtime

  restore "nodejs_is_node_installed"
  restore "nos_install"

  [ "$called" = "false" ]
}

@test "will install node if not already installed" {
  called="false"

  stub_and_echo "nodejs_is_node_installed" "false"

  stub_and_eval "nos_install" "called=\"true\""

  nodejs_install_runtime

  restore "nodejs_is_node_installed"
  restore "nos_install"

  [ "$called" = "true" ]
}

@test "sets runtime for later use" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  mkdir -p /tmp/code/node_modules

  stub_and_echo "nodejs_runtime" "custom-runtime"

  nodejs_set_runtime

  restore "nodejs_runtime"

  [ "$(cat /tmp/code/node_modules/runtime)" = "custom-runtime" ]
}

@test "detects when runtime hasn't changed" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  stub_and_echo "nodejs_runtime" "custom-runtime"

  mkdir -p /tmp/code/node_modules
  echo "custom-runtime" > /tmp/code/node_modules/runtime

  changed=$(nodejs_check_runtime)

  restore "nodejs_runtime"

  [ "$changed" = "false" ]
}

@test "detects when runtime has changed" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  stub_and_echo "nodejs_runtime" "new-runtime"

  mkdir -p /tmp/code/node_modules
  echo "old-runtime" > /tmp/code/node_modules/runtime

  changed=$(nodejs_check_runtime)

  restore "nodejs_runtime"

  [ "$changed" = "true" ]
}
