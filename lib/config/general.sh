# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_boxfile() {
  template \
    "boxfile.mustache" \
    "-" \
    "$(boxfile_payload)"
}

boxfile_payload() {
  _has_bower=$(has_bower)
  _has_web=$(has_web)
  _use_npm_start=$(use_npm_start)
  _use_server_js=$(use_server_js)
  if [[ "$_has_bower" = "true" ]]; then
    print_bullet_sub "Adding lib_dirs for bower"
  fi
  if [[ "$_has_web" = "true" ]]; then
    if [[ "$_use_npm_start" = "true" ]]; then
      print_bullet_sub "Using 'npm start' to start process"
    elif [[ "$_use_server_js" = "true" ]]; then
      print_bullet_sub "Using 'node server.js' to start process"
    fi
  else
    print_warning "Could not identify a way to start a web process. Not creating a web process."
  fi
  cat <<-END
{
  "has_bower": $(has_bower),
  "has_web": $(has_web),
  "npm": $(use_npm_start),
  "server": $(use_server_js)
}
END
}

deploy_dir() {
  # payload deploy_dir
  echo $(payload "deploy_dir")
}

code_dir() {
  # payload code_dir
  echo $(payload "code_dir")
}

live_dir() {
  # payload live_dir
  echo $(payload "live_dir")
}

runtime() {
  echo $(validate "$(payload "boxfile_js_runtime")" "string" "nodejs-0.12")
}

install_runtime() {
  install "$(runtime)"
}

set_runtime() {
  [[ -d $(code_dir)/node_modules ]] && echo "$(runtime)" > $(code_dir)/node_modules/runtime
}

check_runtime() {
  [[ ! -d $(code_dir)/node_modules ]] && echo "true" && return
  [[ "$(cat $(code_dir)/node_modules/runtime)" =~ ^$(runtime)$ ]] && echo "true" || echo "false"
}

npm_rebuild() {
  [[ "$(check_runtime)" = "false" ]] && (cd $(code_dir); run_subprocess "npm rebuild" "npm rebuild")
}

npm_install() {
  [[ -f $(code_dir)/package.json ]] && (cd $(code_dir); run_subprocess "npm install" "npm install .")
}

has_web() {
  [[ "$(use_npm_start)" = "true" || "$(use_server_js)" = "true" ]] && echo "true" || echo "false"
}

use_npm_start() {
  [[ -f $(code_dir)/package.json && "$(cat $(code_dir)/package.json | shon)" =~ ^scripts_start ]] && echo "true" || echo "false"
}

use_server_js() {
  [[ -f $(code_dir)/server.js && $(use_npm_start) = "false" ]] && echo "true" || echo "false"
}
