# Test the runtime selection

# source the Nos framework
. /opt/nanobox/nos/common.sh

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

  stub_and_echo "package_json_runtime" "nodejs-from-package-json"

  default=$(default_runtime)

  restore "package_json_runtime"

  [ "$default" = "nodejs-from-package-json" ]
}

@test "default runtime falls back to a hard-coded default" {

  stub_and_echo "package_json_runtime" "false"

  default=$(default_runtime)

  restore "package_json_runtime"

  [ "$default" = "nodejs-6.11" ]
}

@test "runtime is chosen from the Boxfile if present" {

    nos_init "$(cat <<-END
{
  "config": {
    "runtime": "config-runtime"
  }
}
END
)"

  runtime=$(runtime)

  [ "$runtime" = "config-runtime" ]
}

@test "runtime falls back to default runtime" {

  stub_and_echo "default_runtime" "default-runtime"

  default=$(default_runtime)

  restore "package_json_runtime"

  [ "$default" = "default-runtime" ]
}

@test "will install node" {
  called="false"

  stub_and_eval "nos_install" "called=\"true\""

  install_runtime_packages

  restore "is_node_installed"
  restore "nos_install"

  [ "$called" = "true" ]
}

@test "default python_version falls back to a hard-coded default" {

  python_version=$(default_python_version)

  [ "$python_version" = "python-3.6" ]
}

@test "python_version is chosen from the Boxfile if present" {

    nos_init "$(cat <<-END
{
  "config": {
    "python_version": "python-2.7"
  }
}
END
)"

  python_version=$(python_version)

  [ "$python_version" = "python-2.7" ]
}
