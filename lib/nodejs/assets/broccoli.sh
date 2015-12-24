# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# The asset pipeline for ambitious applications. (http://broccolijs.com/)

# Install broccoli npm module
nodejs_broccoli_prepare() {
  # return early if broccoli is not required
  if [[ "$(nodejs_is_broccoli_required)" = "false" ]]; then
    return
  fi

  # install broccoli
  ( cd $(nos_code_dir)
    nos_run_subprocess "installing broccoli" "npm install broccoli-cli" )
}

# Nothing to configure
nodejs_broccoli_configure() {
  echo "false"
}

nodejs_broccoli_compile() {
  # return early if broccoli is not required
  if [[ "$(nodejs_is_broccoli_required)" = "false" ]]; then
    return
  fi

  # todo: make the broccoli command available through Boxfile
  ( cd $(nos_code_dir)
    nos_run_subprocess "running broccoli build" \
      "node_modules/.bin/broccoli build" )
}

# Broccoli doesn't need to store anything
nodejs_broccoli_detect_lib_dirs() {
  return
}

# external, visible declaration of requirements
nodejs_detect_broccoli_requirements() {
  if [[ "$(nodejs_is_broccoli_required)" = "true" ]]; then
    nos_print_bullet_sub "found Brocfile.js"
    echo "true"
  else
    echo "false"
  fi
}

# internal declaration on whether broccoli is required
nodejs_is_broccoli_required() {
  if [[ -f $(nos_code_dir)/Brocfile.js ]]; then
  	echo "true"
  else
  	echo "false"
  fi
}
