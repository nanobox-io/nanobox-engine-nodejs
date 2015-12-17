# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# Most other engines depend on the nodejs engine to provide a javascript
# asset compilation process if the application needs it.
#
# The asset build process is broken into 3 distinct phases:
#
#   1) Runtime Installation (called during prepare)
#   2) Environment Configuration (called during prepare)
#   3) Asset Compilation (called during build)
#
#   Runtime Installation is where nodejs will be installed, and then any
#   of the frameworks or build tools will be installed via npm
#
#   Environment configuration is where we allow any of the frameworks or
#   build tools prepare the environment. That may mean installing dependencies
#   for bower, or any other preparation for the build.
#
#   Asset Compilation is the final phase, where the assets are compiled. This
#   phase will be deferred to the build tools as well.
#
# In this way, the engine can pick and choose which of the aforementioned
# steps will be required. In the case of rails, for example, the first
# nodejs_prepare_asset_runtime function will be the only requirement as
# rails handles the rest. For other engines, all of the steps might
# be necessary.

nodejs_asset_plugins=(
  bower
  broccoli
  brunch
  grunt
  gulp
)

# Assets plugins will often need to leverage lib_dirs
# to store assets between deploys. Other engines will
# need to know what those are. This global will contain
# paths required by the given plugins.
#
# Calling nodejs_detect_asset_lib_dirs will cause the
# plugins to add their paths if the plugin is applicable.
nodejs_asset_lib_dirs=()

# source the plugin libraries
for plugin in "${nodejs_asset_plugins[@]}"; do
  . ${engine_lib_dir}/nodejs/assets/${plugin}.sh
done

# Runtime Installation
#
# First we install nodejs, then we'll defer the installation
# of specific frameworks and tools to the corresponding plugin.
nodejs_prepare_asset_runtime() {
  # First, we need to see if this app will require an asset compilation.
  # If not, let's exit early.
  [[ "$(_nodejs_is_asset_compilation_required)" = "false" ]] \
    && echo "false" && return

  # Well we'll certainly need nodejs, so let's install that now
  # todo: message about why we're installing nodejs
  nodejs_install_runtime

  # defer to the plugins for installation
  _nodejs_delegate_to_plugins "prepare"
}

# Environment Configuration
#
# First we'll run an npm install, then we'll defer the configuration
# of specific frameworks and tools to the corresponding plugin.
nodejs_configure_asset_environment() {
  # First, we need to see if this app will require an asset compilation.
  # If not, let's exit early.
  [[ "$(_nodejs_is_asset_compilation_required)" = "false" ]] \
    && echo "false" && return

  # npm install
  # todo: message about why we're running npm install
  nodejs_npm_install

  # defer to the plugins for configuration
  _nodejs_delegate_to_plugins "configure"
}

# Asset Compilation
#
# Defer the compilation process to the corresponding plugin.
nodejs_compile_assets() {
  # First, we need to see if this app will require an asset compilation.
  # If not, let's exit early.
  [[ "$(_nodejs_is_asset_compilation_required)" = "false" ]] \
    && echo "false" && return

  # defer to the plugins for compilation
  _nodejs_delegate_to_plugins "compile"
}

# Asset plugins will likely need to store dependencies between
# builds or deploys. Lib_dirs is the mechanism for this. We will
# need to inform the other engines of which lib_dirs are necessary.
nodejs_detect_asset_lib_dirs() {
  # first let check to see if package.json exists, if so we know
  # we'll need node_modules.
  if [[ -f $(nos_code_dir)/package.json ]]; then
    nodejs_asset_lib_dirs=+("node_modules")
  fi

  # now we'll defer the rest to to the specific plugins
  _nodejs_delegate_to_plugins "detect_lib_dirs"
}

# Determine if the application will even need an asset compilation
_nodejs_is_asset_compilation_required() {
  # first, let's check for a package.json. If we have that, we
  # know we'll need an asset compilation so we can exit early
  [[ -f $(nos_code_dir)/package.json ]] && echo "true" && return

  # If we don't have a package.json, then let's let the other
  # plugins determine if they are eligible for compilation.
  #
  # Once we find a match, return immediately
  for plugin in "${nodejs_asset_plugins[@]}"; do
    [[ "$(nodejs_is_${plugin}_required)" = "true" ]] \
      && echo "true" && return
  done

  # if we've made it this far without a match, then compilation
  # just isn't required for this particular app
  echo "false"
}

# Simple helper utility to iterate through plugins and call
# a function on all of them.
_nodejs_delegate_to_plugins() {
  function=$1

  for plugin in "${nodejs_asset_plugins[@]}"; do
    nodejs_${plugin}_${function}
  done
}
