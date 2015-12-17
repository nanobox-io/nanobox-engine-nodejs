# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# A package manager for the web (http://bower.io/)

nodejs_bower_prepare() {

}

nodejs_bower_configure() {

}

nodejs_bower_compile() {

}

nodejs_bower_detect_lib_dirs() {

}

nodejs_is_bower_required() {
  if [[ -f $(nos_code_dir)/bower.json ]]; then
  	echo "true"
  else
  	echo "false"
  fi
}

# nodejs_install_bower() {
#   if [[ "$(nodejs_has_bower)" = "true" ]]; then
#   	nos_print_bullet_info "Found bower.json, installing bower"
#     (cd $(nos_code_dir); nos_run_process "npm install bower" "npm install bower")
#   fi
# }
#
# nodejs_bower_install() {
#   if [[ "$(nodejs_has_bower)" = "true" ]]; then
#   	nos_print_bullet_info "Found bower.json, running 'bower install'"
#   	(cd $(nos_code_dir); nos_run_process "bower install" "node_modules/.bin/bower --config.interactive=false install")
#   fi
# }
