# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

has_bower() {
  [[ -f $(code_dir)/bower.json ]] && echo "true" || echo "false"
}

install_bower() {
  [[ "$(has_bower)" = "true" ]] && (cd $(code_dir); run_subprocess "npm install bower" "npm install bower")
}

bower_install() {
  [[ "$(has_bower)" = "true" ]] && (cd $(code_dir); run_subprocess "bower install" "node_modules/.bin/bower --config.interactive=false install")
}