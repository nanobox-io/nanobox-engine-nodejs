# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_boxfile() {
  nos_template \
    "boxfile.mustache" \
    "-" \
    "$(boxfile_payload)"
}

boxfile_payload() {
  _has_bower=$(nodejs_has_bower)
  _has_web=$(nodejs_has_web)
  _use_npm_start=$(nodejs_use_npm_start)
  _use_server_js=$(nodejs_use_server_js)
  nos_print_bullet "Detecting settings"
  if [[ "$_has_bower" = "true" ]]; then
    nos_print_bullet_sub "Adding lib_dirs for bower"
  fi
  if [[ "$_has_web" = "true" ]]; then
    if [[ "$_use_npm_start" = "true" ]]; then
      nos_print_bullet_sub "Using 'npm start' to start process"
    elif [[ "$_use_server_js" = "true" ]]; then
      nos_print_bullet_sub "Using 'node server.js' to start process"
    fi
  else
    print_warning "Could not identify a way to start a web process. Not creating a web process."
  fi
  cat <<-END
{
  "has_bower": ${_has_bower},
  "has_web": ${_has_web},
  "npm": ${_use_npm_start},
  "server": ${_use_server_js}
}
END
}

nodejs_runtime() {
  echo $(nos_validate "$(nos_payload "boxfile_nodejs_runtime")" "string" "nodejs-0.12")
}

nodejs_install_runtime() {
  nos_install "$(nodejs_runtime)"
}

nodejs_set_runtime() {
  [[ -d $(nos_code_dir)/node_modules ]] && echo "$(nodejs_runtime)" > $(nos_code_dir)/node_modules/runtime
}

nodejs_check_runtime() {
  [[ ! -d $(nos_code_dir)/node_modules ]] && echo "true" && return
  [[ "$(cat $(nos_code_dir)/node_modules/runtime)" =~ ^$(nodejs_runtime)$ ]] && echo "true" || echo "false"
}

nodejs_npm_rebuild() {
  [[ "$(nodejs_check_runtime)" = "false" ]] && (cd $(nos_code_dir); nos_run_subprocess "npm rebuild" "npm rebuild")
}

nodejs_npm_install() {
  [[ -f $(nos_code_dir)/package.json ]] && (cd $(nos_code_dir); nos_run_subprocess "npm install" "npm install .")
}

nodejs_has_web() {
  [[ "$(nodejs_use_npm_start)" = "true" || "$(nodejs_use_server_js)" = "true" ]] && echo "true" || echo "false"
}

nodejs_use_npm_start() {
  [[ -f $(nos_code_dir)/package.json && "$(cat $(nos_code_dir)/package.json | shon)" =~ ^scripts_start ]] && echo "true" || echo "false"
}

nodejs_use_server_js() {
  [[ -f $(nos_code_dir)/server.js && $(nodejs_use_npm_start) = "false" ]] && echo "true" || echo "false"
}
