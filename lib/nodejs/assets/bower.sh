# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# A package manager for the web (http://bower.io/)

# Install bower npm module
nodejs_bower_prepare() {
  # return early if bower is not required
  [[ "$(nodejs_is_bower_required)" = "false" ]] \
    && echo "false" && return

  # install bower
  ( cd $(nos_code_dir)
    nos_run_subprocess "installing bower" "npm install bower" )
}

# Run bower install
nodejs_bower_configure() {
  # return early if bower is not required
  [[ "$(nodejs_is_bower_required)" = "false" ]] \
    && echo "false" && return

  ( cd $(nos_code_dir)
    nos_run_subprocess "running bower install" \
      "node_modules/.bin/bower --config.interactive=false install" )
}

# Bower doesn't compile, return nothing
nodejs_bower_compile() {
  echo "false"
}

# Add bower_components to lib_dirs
nodejs_bower_detect_lib_dirs() {
  # return early if bower is not required
  [[ "$(nodejs_is_bower_required)" = "false" ]] \
    && echo "false" && return

  nodejs_asset_lib_dirs+=("bower_components")
}

# external, visible declaration of requirements
nodejs_detect_bower_requirements() {
  if [[ "$(nodejs_is_bower_required)" = "true" ]]; then
    nos_print_bullet_sub "found bower.json"
    echo "true"
  else
    echo "false"
  fi
}

# internal declaration on whether bower is required
nodejs_is_bower_required() {
  if [[ -f $(nos_code_dir)/bower.json ]]; then
  	echo "true"
  else
  	echo "false"
  fi
}
