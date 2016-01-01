# Integration test for a simple nodejs app

# source environment helpers
. util/env.sh

payload() {
  cat <<-END
{
  "code_dir": "/tmp/code",
  "deploy_dir": "/data",
  "live_dir": "/tmp/live",
  "cache_dir": "/tmp/cache",
  "etc_dir": "/data/etc",
  "env_dir": "/data/etc/env.d",
  "app": "simple-nodejs",
  "env": {
    "APP_NAME": "simple-nodejs"
  },
  "dns": [
    "simple-nodejs.dev"
  ],
  "boxfile": {},
  "platform": "local",
  "run": true
}
END
}

setup() {
  # cd into the engine bin dir
  cd /engine/bin
}

@test "setup" {
  # prepare environment (create directories etc)
  prepare_environment

  # prepare pkgsrc
  run prepare_pkgsrc

  # create the code_dir
  mkdir -p /tmp/code

  # copy the app into place
  cp -ar /test/apps/simple-nodejs/* /tmp/code

  run pwd

  [ "$output" = "/engine/bin" ]
}

@test "sniff" {
  run /engine/bin/sniff /tmp/code

  [ "$status" -eq 0 ]
}

@test "boxfile" {
  run /engine/bin/boxfile "$(payload)"

  [ "$status" -eq 0 ]
}

@test "prepare" {
  run /engine/bin/prepare "$(payload)"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "build" {
  run /engine/bin/build "$(payload)"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "cleanup" {
  run /engine/bin/cleanup "$(payload)"

  echo "$output"

  [ "$status" -eq 0 ]
}

@test "verify" {
  # remove the code dir
  rm -rf /tmp/code

  # mv the live_dir to code_dir
  mv /tmp/live /tmp/code

  # cd into the live code_dir
  cd /tmp/code

  # start the server in the background
  node server.js > /dev/null 2>&1 &

  # grab the pid
  pid=$!

  # sleep a few seconds so the server can start
  sleep 3

  # curl the index
  run curl -s 127.0.0.1:8080 2>/dev/null

  expected="Node.js - Express - Hello World!"

  echo "$output"

  # kill the server
  kill -9 $pid > /dev/null 2>&1

  [ "$output" = "$expected" ]
}
