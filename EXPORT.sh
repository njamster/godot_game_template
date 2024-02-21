#!/usr/bin/env bash

# ANSI escape codes for formatting
BOLDRED="\e[1;31m"
BOLD="\e[1m"
RED="\e[0;31m"
RESET="\e[0m"

# check for commandline arguments
[[ "$1" = "-v" || "$1" = "--verbose" ]] && VERBOSE=true

if [[ ! -f export_presets.cfg ]]; then
  # error check 1: no 'export_presets.cfg' file
  echo -e "${BOLDRED}ERROR:${RED} This project doesn't have an 'export_presets.cfg' file at its root."
  echo -e "Create an export preset from Godot's 'Project > Export' dialog and try again.${RESET}"
  exit
elif [[ ! $(grep "^name=" export_presets.cfg) ]]; then
  # error check 2: empty or corrupted 'export_presets.cfg' file
  echo -e "${BOLDRED}ERROR:${RED} This project's 'export_presets.cfg' contains no named export presets."
  echo -e "Create an export preset from Godot's 'Project > Export' dialog and try again.${RESET}"
  exit
fi

OUTPUT_PATH="builds/" # where the exported builds will be stored

export () {
  # print function name and all provided arguments
  echo -en "\n${BOLD}> EXPORT \"${1:-<preset>}\" \"${2:-<path>}\""
  for (( i=3; i<=$#; i++)); do
    echo -en " \"${!i}\""
  done
  echo -e "${RESET}"

  # error check 1: invalid number of arguments
  if [ $# -ne 2 ]; then
    echo -e "${BOLDRED}ERROR:${RED} Function expected 2 arguments, but called with $#."
    echo -e "Make sure to provide both a valid preset name and an existing output path.${RESET}"
    return
  fi

  # error check 2: invalid export preset name
  if ! grep -q "name=\"$1\"" export_presets.cfg; then
    echo -e "${BOLDRED}ERROR:${RED} Invalid export preset name: \"$1\"."
    echo -e "The following presets were detected in this project's 'export_presets.cfg':"
    echo -e "$(awk 'sub(/^name=/,"  - ")' export_presets.cfg)${RESET}"
    return
  fi

  # create all non-existent directories in the output path...
  dirname "${OUTPUT_PATH}$2" | xargs mkdir -p
  # ... and make sure Godot ignores the folder (i.e. it does not show
  # up in Godot's FileSystem tab and won't be included in exports)
  touch $OUTPUT_PATH/.gdignore

  if [ "$VERBOSE" = true ]; then
    godot --headless --export-release "$1" "${OUTPUT_PATH}$2"
  else
    godot --headless --export-release --quiet "$1" "${OUTPUT_PATH}$2"
  fi
}

# each of the following lines will try to create an export build
export "Web" "web/index.html"
export "Linux/X11" "linux.x86_64"
export "Windows Desktop" "windows.exe"
export "macOS" "mac_os.zip"
