# Integration test for a simple brunch app

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
  "app": "simple-brunch",
  "env": {
    "APP_NAME": "simple-brunch"
  },
  "dns": [
    "simple-brunch.dev"
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
  cp -ar /test/apps/simple-brunch/* /tmp/code

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

  # ensure brunch built the public directory
  [ -d public ]
  [ -d public/javascripts ]
  [ -d public/stylesheets ]
  [ -f public/index.html ]
  [ -f public/javascripts/app.js ]
  [ -f public/javascripts/vendor.js ]
  [ -f public/stylesheets/app.css ]
}
