# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# todo: try to detect the port to listen on?

nodejs_generate_boxfile() {
  nos_template \
    "boxfile.mustache" \
    "-" \
    "$(nodejs_boxfile_payload)"
}

nodejs_boxfile_payload() {
  cat <<-END
{
  "can_exec": $(nodejs_can_exec),
  "exec_cmd": $(nodejs_exec_cmd),
  "asset_lib_dirs": ${nodejs_asset_lib_dirs}
}
END
}

nodejs_report_boxfile() {
  nos_print_bullet "Generating Boxfile"

  # if this isn't dev mode, let's scan the web configuration
  if [[ "$(nos_payload "run")" = "true" ]]; then
    nodejs_report_boxfile_web
  fi
}

# report to the user how we will run their app
nodejs_report_boxfile_web() {
  # short-circuit early if they have a Boxfile and it has a web1.exec
  # since that will be used anyway
  if [[ ! ( -f $(nos_code_dir/Boxfile) \
           && "$(cat $(nos_code_dir)/Boxfile | shon)" =~ web1_exec ) ]]; then

    if [[ "$(nodejs_exec_cmd)" != "false" ]]; then
      nos_print_bullet_sub  "web1 service will be started with:"
      nos_print_bullet_info "   $(nodejs_exec_cmd)"
    else
      nos_print_bullet_sub  "web1 service cannot be auto-generated"
      nos_print_bullet_info "   We're unable to determine a suitable way to run this app."
      nos_print_bullet_info "   Please provide a web1 configuration in the Boxfile."
      nos_print_bullet_info "   For additional information, please consult the documentation:"
      nos_print_bullet_info "      http://engines.nanobox.io/engines/0754ca2d-70bd-45b3-996e-c96e5ef882ce"
    fi
  fi
}

# Determine the nodejs runtime to install. This will first check
# within the Boxfile, then will rely on nodejs_default_runtime to
# provide a sensible default
nodejs_runtime() {
  echo $(nos_validate \
    "$(nos_payload "boxfile_nodejs_runtime")" \
    "string" "$(nodejs_default_runtime)")
}

# Provide a default nodejs version.
# todo: this should include an idiomatic check
nodejs_default_runtime() {
  echo "nodejs-4.2"
}

# Install the nodejs runtime.
# todo: this will be called twice if the asset build requests it.
#       We need to find a way to idempotently install nodejs.
nodejs_install_runtime() {
  nos_install "$(nodejs_runtime)"
}

# set the runtime in a file inside of node_modules so that if the
# runtime changes between deploys, we can blast the node_modules
# cache and build fresh.
nodejs_set_runtime() {
  [[ -d $(nos_code_dir)/node_modules ]] \
    && echo "$(nodejs_runtime)" > $(nos_code_dir)/node_modules/runtime
}

# check the runtime that was set at the last deploy, and ensure it
# hasn't changed. If it has changed, we'll return false.
nodejs_check_runtime() {
  [[ ! -d $(nos_code_dir)/node_modules ]] \
    && echo "true" && return

  [[ "$(cat $(nos_code_dir)/node_modules/runtime)" =~ ^$(nodejs_runtime)$ ]] \
    && echo "true" || echo "false"
}

# If the package.json has changed since the previous deploy it should
# be rebuilt to ensure unused packages are purged.
nodejs_npm_rebuild() {
  if [[ "$(nodejs_check_runtime)" = "false" ]]; then
    ( cd $(nos_code_dir)
      nos_run_subprocess "rebuilding npm modules" "npm rebuild" )
  fi
}

# Installing dependencies from the package.json is done with npm install.
# Todo: This should drop a timestamp in the node_modules that can be used
# to ensure we don't run npm_install twice on the same deploy. That can
# happen if static assets request an npm install
nodejs_npm_install() {
  if [[ -f $(nos_code_dir)/package.json ]]; then
    ( cd $(nos_code_dir)
      nos_run_subprocess "installing npm modules" "npm install" )
  fi
}

# determine if we can provide an exec command for a web service to run
nodejs_can_exec() {
  if [[ "$(nodejs_can_npm_start)" = "true" \
        || "$(nodejs_can_server_js)" = "true" \
        || "$(nodejs_can_app_js)" = "true" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

# Determine if we can start the app with npm
nodejs_can_npm_start() {
  # if we don't have a package.json, let's short-circuit early
  if [[ ! -f $(nos_code_dir)/package.json ]]; then
    echo "false"
    return
  fi

  # parse package.json and see if a script start value exists
  if [[ "$(cat $(nos_code_dir)/package.json | shon)" =~ scripts_start_value ]]; then
    echo "true"
  else
    echo "false"
  fi
}

# Determine if there is a server.js to run
nodejs_can_server_js() {
  if [[ -f $(nos_code_dir)/server.js ]]; then
    echo "true"
  else
    echo "false"
  fi
}

# Determine if there is an app.js to run
nodejs_can_app_js() {
  if [[ -f $(nos_code_dir)/app.js ]]; then
    echo "true"
  else
    echo "false"
  fi
}

# The command to provide for the web service to run the app
nodejs_exec_cmd() {
  if [[ "$(nodejs_can_npm_start)" = "true" ]]; then
    echo "npm start"
  elif [[ "$(nodejs_can_server_js)" = "true" ]]; then
    echo "node server.js"
  elif [[ "$(nodejs_can_app_js)" = "true" ]]; then
    echo "node app.js"
  else
    echo "false"
  fi
}
