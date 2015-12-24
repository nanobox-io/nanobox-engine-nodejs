# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# The JavaScript Task Runner. (http://gruntjs.com/)

# Install grunt npm module
nodejs_grunt_prepare() {
  # return early if grunt is not required
  if [[ "$(nodejs_is_grunt_required)" = "false" ]]; then
    return
  fi

  # install grunt
  ( cd $(nos_code_dir)
    nos_run_subprocess "installing grunt" "npm install grunt" )
}

# nothing to configure
nodejs_grunt_configure() {
 return
}

#
nodejs_grunt_compile() {
  # return early if grunt is not required
  if [[ "$(nodejs_is_grunt_required)" = "false" ]]; then
    return
  fi

  # todo: make the grunt command available through Boxfile
  ( cd $(nos_code_dir)
    nos_run_subprocess "running grunt" \
      "node_modules/.bin/grunt" )
}

# grunt doesn't store anything between builds
nodejs_grunt_detect_lib_dirs() {
  return
}

# external, visible declaration of requirements
nodejs_detect_grunt_requirements() {
  if [[ "$(nodejs_is_grunt_required)" = "true" ]]; then
    nos_print_bullet_sub "found Gruntfile"
    echo "true"
  else
    echo "false"
  fi
}

# internal declaration on whether grunt is required
nodejs_is_grunt_required() {
  if [[ -f $(nos_code_dir)/Gruntfile ]]; then
  	echo "true"
  else
  	echo "false"
  fi
}
