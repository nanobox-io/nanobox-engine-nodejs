# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# Brunch is an ultra-fast HTML5 build tool (http://brunch.io/)

# Install brunch npm module
nodejs_brunch_prepare() {
  # return early if brunch is not required
  if [[ "$(nodejs_is_brunch_required)" = "false" ]]; then
    return
  fi

  # install brunch
  ( cd $(nos_code_dir)
    nos_run_subprocess "installing brunch" "npm install brunch" )
}

# nothing to configure
nodejs_brunch_configure() {
 echo "false"
}

#
nodejs_brunch_compile() {
  # return early if brunch is not required
  if [[ "$(nodejs_is_brunch_required)" = "false" ]]; then
    return
  fi

  # todo: make the brunch command available through Boxfile
  ( cd $(nos_code_dir)
    nos_run_subprocess "running brunch" \
      "node_modules/.bin/brunch build --production" )
}

# brunch doesn't store anything between builds
nodejs_brunch_detect_lib_dirs() {
  return
}

# external, visible declaration of requirements
nodejs_detect_brunch_requirements() {
  if [[ -f $(nos_code_dir)/config.coffee ]]; then
    nos_print_bullet_sub "found config.coffee"
    echo "true"
  elif [[ -f $(nos_code_dir)/config.js ]]; then
    nos_print_bullet_sub "found config.js"
    echo "true"
  else
    echo "false"
  fi
}

# internal declaration on whether brunch is required
nodejs_is_brunch_required() {
  if [[ -f $(nos_code_dir)/config.coffee || -f $(nos_code_dir)/config.js ]]; then
  	echo "true"
  else
  	echo "false"
  fi
}
