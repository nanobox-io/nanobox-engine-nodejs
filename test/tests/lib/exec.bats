# Test the exec detection

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

@test "can exec if npm start is detected" {

  stub_and_echo "nodejs_can_npm_start" "true"
  stub_and_echo "nodejs_can_server_js" "false"
  stub_and_echo "nodejs_can_app_js" "false"

  can_exec=$(nodejs_can_exec)

  restore "nodejs_can_npm_start"
  restore "nodejs_can_server_js"
  restore "nodejs_can_app_js"

  [ "$can_exec" = "true" ]
}

@test "can exec if can server_js" {

  stub_and_echo "nodejs_can_npm_start" "false"
  stub_and_echo "nodejs_can_server_js" "true"
  stub_and_echo "nodejs_can_app_js" "false"

  can_exec=$(nodejs_can_exec)

  restore "nodejs_can_npm_start"
  restore "nodejs_can_server_js"
  restore "nodejs_can_app_js"

  [ "$can_exec" = "true" ]
}

@test "can exec if can app_js" {

  stub_and_echo "nodejs_can_npm_start" "false"
  stub_and_echo "nodejs_can_server_js" "false"
  stub_and_echo "nodejs_can_app_js" "true"

  can_exec=$(nodejs_can_exec)

  restore "nodejs_can_npm_start"
  restore "nodejs_can_server_js"
  restore "nodejs_can_app_js"

  [ "$can_exec" = "true" ]
}

@test "cannot exec if can't find a way to start" {

  stub_and_echo "nodejs_can_npm_start" "false"
  stub_and_echo "nodejs_can_server_js" "false"
  stub_and_echo "nodejs_can_app_js" "false"

  can_exec=$(nodejs_can_exec)

  restore "nodejs_can_npm_start"
  restore "nodejs_can_server_js"
  restore "nodejs_can_app_js"

  [ "$can_exec" = "false" ]
}

@test "can npm start if package.json with start value" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  cat > /tmp/code/package.json <<-END
{
  "scripts": {
    "start": "test"
  }
}
END

  can_npm_start=$(nodejs_can_npm_start)

  echo "$can_npm_start"

  [ "$can_npm_start" = "true" ]
}

@test "can't npm start without a package.json" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  can_npm_start=$(nodejs_can_npm_start)

  [ "$can_npm_start" = "false" ]
}

@test "can't start with a package.json without scripts defined" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  cat > /tmp/code/package.json <<-END
{
}
END

  can_npm_start=$(nodejs_can_npm_start)

  [ "$can_npm_start" = "false" ]
}

@test "can server_js if server.js" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  touch /tmp/code/server.js

  can_server_js=$(nodejs_can_server_js)

  [ "$can_server_js" = "true" ]
}

@test "cannot server_js if not server.js" {

  can_server_js=$(nodejs_can_server_js)

  [ "$can_server_js" = "false" ]
}

@test "can app_js if app.js" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  touch /tmp/code/app.js

  can_app_js=$(nodejs_can_app_js)

  [ "$can_app_js" = "true" ]
}

@test "cannot app_js if not app.js" {

  can_app_js=$(nodejs_can_app_js)

  [ "$can_app_js" = "false" ]
}

@test "provides npm exec when available" {

  stub_and_echo "nodejs_can_npm_start" "true"

  exec_cmd=$(nodejs_exec_cmd)

  restore "nodejs_can_npm_start"

  [ "$exec_cmd" = "npm start" ]
}

@test "provides server_js exec when available" {

  stub_and_echo "nodejs_can_npm_start" "false"
  stub_and_echo "nodejs_can_server_js" "true"

  exec_cmd=$(nodejs_exec_cmd)

  restore "nodejs_can_npm_start"
  restore "nodejs_can_server_js"

  [ "$exec_cmd" = "node server.js" ]
}

@test "provides app_js exec when available" {

  stub_and_echo "nodejs_can_npm_start" "false"
  stub_and_echo "nodejs_can_server_js" "false"
  stub_and_echo "nodejs_can_app_js" "true"

  exec_cmd=$(nodejs_exec_cmd)

  restore "nodejs_can_npm_start"
  restore "nodejs_can_server_js"
  restore "nodejs_can_app_js"

  [ "$exec_cmd" = "node app.js" ]
}

@test "returns false when no exec is available" {

  stub_and_echo "nodejs_can_npm_start" "false"
  stub_and_echo "nodejs_can_server_js" "false"
  stub_and_echo "nodejs_can_app_js" "false"

  exec_cmd=$(nodejs_exec_cmd)

  restore "nodejs_can_npm_start"
  restore "nodejs_can_server_js"
  restore "nodejs_can_app_js"

  [ "$exec_cmd" = "false" ]
}
