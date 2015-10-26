# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_boxfile() {
  template \
    "boxfile.mustache" \
    "-" \
    "$(boxfile_payload)"
}

boxfile_payload() {
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

has_web() {
  [[ "$(use_npm_start)" = "true" || "$(use_server_js)" = "true" ]] && echo "true" || >&2 echo "Web not detected." && echo "false"
}

use_npm_start() {
  [[ -f $(code_dir)/package.json && "$(cat $(code_dir)/package.json | shon)" =~ ^scripts_start ]] && >&2 echo "Creating web from start script in package.json." && echo "true" || echo "false"
}

use_server_js() {
  [[ -f $(code_dir)/server.js && $(use_npm_start) = "false" ]] && >&2 echo "Creating web using server.js." && echo "true" || echo "false"
}
