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

@test "run" {
  # node server.js
}

@test "verify" {

}
