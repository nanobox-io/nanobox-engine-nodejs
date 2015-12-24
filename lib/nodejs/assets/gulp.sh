# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# The streaming build system. (http://gulpjs.com/)

# Install gulp npm module
nodejs_gulp_prepare() {
  # return early if gulp is not required
  if [[ "$(nodejs_is_gulp_required)" = "false" ]]; then
    return
  fi

  # install gulp
  ( cd $(nos_code_dir)
    nos_run_subprocess "installing gulp" "npm install gulp" )
}

# nothing to configure
nodejs_gulp_configure() {
 return
}

#
nodejs_gulp_compile() {
  # return early if gulp is not required
  if [[ "$(nodejs_is_gulp_required)" = "false" ]]; then
    return
  fi

  # todo: make the gulp command available through Boxfile
  ( cd $(nos_code_dir)
    nos_run_subprocess "running gulp" \
      "node_modules/.bin/gulp" )
}

# gulp doesn't store anything between builds
nodejs_gulp_detect_lib_dirs() {
  return
}

# external, visible declaration of requirements
nodejs_detect_gulp_requirements() {
  if [[ "$(nodejs_is_gulp_required)" = "true" ]]; then
    nos_print_bullet_sub "found gulpfile.js"
    echo "true"
  else
    echo "false"
  fi
}

# internal declaration on whether gulp is required
nodejs_is_gulp_required() {
  if [[ -f $(nos_code_dir)/gulpfile.js ]]; then
  	echo "true"
  else
  	echo "false"
  fi
}
