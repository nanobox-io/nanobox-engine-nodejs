# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

js_runtime() {
	_runtime=$(validate "$(payload "boxfile_runtime")" "string" "")
	[[ "$_runtime" =~ ^nodejs ]] && echo "$_runtime" && return
	# [[ "$_runtime" =~ ^iojs ]] && echo "$_runtime" && return
  echo $(validate "$(payload "boxfile_js_runtime")" "string" "nodejs-4.2")
}

needs_js_runtime() {
	[[ -f $(code_dir)/package.json ]] && echo "true" || >&2 echo "Could not find $(code_dir)/package.json"
	[[ -f $(code_dir)/bower.json ]] && echo "true" || >&2 echo "Could not find $(code_dir)/bower.json"
	echo "false"
}

install_js_runtime() {
  [[ "$(needs_js_runtime)" = "true" ]] && install "$(js_runtime)"
}

set_js_runtime() {
  [[ -d $(code_dir)/node_modules ]] && echo "$(js_runtime)" > $(code_dir)/node_modules/runtime
}

check_js_runtime() {
  [[ ! -d $(code_dir)/node_modules ]] && echo "true" && return
  [[ "$(cat $(code_dir)/node_modules/runtime)" =~ ^$(js_runtime)$ ]] && echo "true" || echo "false"
}

npm_rebuild() {
  [[ "$(check_js_runtime)" = "false" ]] && (cd $(code_dir); run_subprocess "npm rebuild" "npm rebuild")
}

npm_install() {
  [[ -f $(code_dir)/package.json ]] && (cd $(code_dir); run_subprocess "npm install" "npm install .")
}