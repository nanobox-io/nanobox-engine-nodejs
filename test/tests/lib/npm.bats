# Test the npm functionality

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

@test "npm install will not run without a package.json file" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  npm_ran="false"

  stub_and_eval "nos_run_process" "npm_ran=\"true\""

  npm_install

  restore "nos_run_process"
  npm_installed="false"

  [ "$npm_ran" = "false" ]
}

@test "npm install will run if a package.json file is present" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  npm_ran="false"

  stub_and_eval "nos_run_process" "npm_ran=\"true\""

  mkdir -p /tmp/code
  touch /tmp/code/package.json

  npm_install

  restore "nos_run_process"

  [ "$npm_ran" = "true" ]
}

@test "yarn install will not run without a package.json file" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  yarn_ran="false"

  stub_and_eval "nos_run_process" "yarn_ran=\"true\""

  yarn_install

  restore "nos_run_process"
  yarn_installed="false"

  [ "$yarn_ran" = "false" ]
}

@test "yarn install will run if a package.json file is present" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  yarn_ran="false"

  stub_and_eval "nos_run_process" "yarn_ran=\"true\""

  mkdir -p /tmp/code
  touch /tmp/code/package.json

  yarn_install

  restore "nos_run_process"

  [ "$yarn_ran" = "true" ]
}
