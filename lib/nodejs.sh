# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# Copy the code into the live directory which will be used to run the app
publish_release() {
  nos_print_bullet "Moving code into app directory..."
  rsync -a $(nos_code_dir)/ $(nos_app_dir)
}

# Determine the nodejs runtime to install. This will first check
# within the Boxfile, then will rely on default_runtime to
# provide a sensible default
runtime() {
  echo $(nos_validate \
    "$(nos_payload "config_runtime")" \
    "string" "$(default_runtime)")
}

# Provide a default nodejs version.
default_runtime() {
  packagejs_runtime=$(package_json_runtime)

  if [[ "$packagejs_runtime" = "false" ]]; then
    echo "nodejs-6.11"
  else
    echo $packagejs_runtime
  fi
}

# Determine the python runtime to install. This will first check
# within the boxfile.yml, then will rely on python_default_runtime to
# provide a sensible default
python_version() {
  echo $(nos_validate \
    "$(nos_payload "config_python_version")" \
    "string" "$(default_python_version)")
}

# Provide a default python version.
default_python_version() {
  echo "python-3.6"
}

# todo: extract the contents of package.json
#   Will need https://stedolan.github.io/jq/
#   https://github.com/heroku/heroku-buildpack-nodejs/blob/master/lib/json.sh#L17
#   https://github.com/heroku/heroku-buildpack-nodejs/blob/master/bin/compile#L73
package_json_runtime() {
  echo "false"
}

# Determine which dependency manager to use (yarn/npm)
dep_manager() {
  echo $(nos_validate \
    "$(nos_payload "config_dep_manager")" \
    "string" "$(default_dep_manager)")
}

# Use yarn as the default dep manager
default_dep_manager() {
  echo "yarn"
}

# Install the nodejs runtime along with any dependencies.
install_runtime_packages() {
  pkgs=("$(runtime)" "$(python_version)")
  
  # add any client dependencies
  pkgs+=("$(query_dependencies)")

  nos_install ${pkgs[@]}
}

# Uninstall build dependencies
uninstall_build_dependencies() {
  # pkgin doesn't removing packages with partial version numbers.
  nos_uninstall "python"
}

# compiles a list of dependencies that will need to be installed
query_dependencies() {
  deps=()

  # mysql
  if [[ `grep 'mysql' $(nos_code_dir)/package.json` ]]; then
    deps+=(mysql-client)
  fi
  # memcache
  if [[ `grep 'memcache' $(nos_code_dir)/package.json` ]]; then
    deps+=(libmemcached)
  fi
  # postgres
  if [[ `grep 'postgres' $(nos_code_dir)/package.json` ]]; then
    deps+=(postgresql94-client)
  fi
  # redis
  if [[ `grep 'redis\|spade\|rebridge' $(nos_code_dir)/package.json` ]]; then
    deps+=(redis)
  fi
  
  echo "${deps[@]}"
}

# installs npm deps via yarn or npm
install_npm_deps() {
  # if yarn is available, let's use that
  if [[ "$(dep_manager)" = "yarn" ]]; then
    yarn_install
  else # fallback to npm (slow)
    npm_install
  fi
}

# install dependencies via yarn
yarn_install() {
  if [[ -f $(nos_code_dir)/package.json ]]; then

    cd $(nos_code_dir)
    nos_run_process "Installing npm modules" "yarn"
    cd - > /dev/null
  fi
}

# Installing dependencies from the package.json is done with npm install.
npm_install() {
  if [[ -f $(nos_code_dir)/package.json ]]; then

    cd $(nos_code_dir)
    nos_run_process "Installing npm modules" "npm install"
    cd - > /dev/null
  fi
}
