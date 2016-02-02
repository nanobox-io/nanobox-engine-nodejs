# Integration test for a simple gulp app

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
  "app": "simple-gulp",
  "env": {
    "APP_NAME": "simple-gulp"
  },
  "dns": [
    "simple-gulp.dev"
  ],
  "boxfile": {
    "nodejs_runtime": "nodejs-0.12.7"
  },
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

  # ensure the tmp/code dir is clean
  rm -rf /tmp/code

  # copy the app into place
  cp -r /test/apps/simple-gulp/ /tmp/code

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

  # ensure gulp built the dist directory
  [ -d dist ]
  [ -f dist/ba-tiny-pubsub.js ]
  [ -f dist/ba-tiny-pubsub.min.js ]
}
