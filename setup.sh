#!/bin/bash
set -euo pipefail
############################################################
# Author    : Your Name
# Website   : https://github.com/YOURUSERNAME/velox-iso
############################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
############################################################

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

############################################################
# Colors
############################################################
if command -v tput >/dev/null 2>&1 && [[ -t 1 ]]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    CYAN="$(tput setaf 6)"
    RESET="$(tput sgr0)"
else
    RED="" GREEN="" YELLOW="" BLUE="" CYAN="" RESET=""
fi

############################################################
# Logging
############################################################
log_section() {
    echo
    echo "${GREEN}############################################################${RESET}"
    echo "$1"
    echo "${GREEN}############################################################${RESET}"
    echo
}

log_info() {
    echo
    echo "${BLUE}############################################################${RESET}"
    echo "$1"
    echo "${BLUE}############################################################${RESET}"
    echo
}

log_warn() {
    echo
    echo "${YELLOW}############################################################${RESET}"
    echo "$1"
    echo "${YELLOW}############################################################${RESET}"
    echo
}

log_error() {
    echo
    echo "${RED}############################################################${RESET}"
    echo "$1"
    echo "${RED}############################################################${RESET}"
    echo
}

log_success() {
    echo
    echo "${GREEN}############################################################${RESET}"
    echo "$1"
    echo "${GREEN}############################################################${RESET}"
    echo
}

############################################################
# Error handling
############################################################
on_error() {
    local lineno="$1"
    local cmd="$2"
    echo
    echo "${RED}ERROR on line ${lineno}: ${cmd}${RESET}"
    echo
    sleep 10
}

trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

############################################################
# Functions
############################################################
configure_git() {
    local project
    project="$(basename "${SCRIPT_DIR}")"

    log_section "Configuring git for project: ${project}"

    git config --global pull.rebase false
    if [[ "$(git config --system --get core.editor 2>/dev/null)" != "nano" ]]; then
        sudo git config --system core.editor nano
    fi
    git config --global push.default simple

    if [[ "${SCRIPT_DIR}" == *"/VELOX"* || "${SCRIPT_DIR}" == *"/velox"* ]]; then
        log_info "https://github.com/YOURUSERNAME/${project}"
        git -C "${SCRIPT_DIR}" config --local user.name "Alex Torrella"
        git -C "${SCRIPT_DIR}" config --local user.email "thelinuxtube@gmail.com"
        git -C "${SCRIPT_DIR}" remote set-url origin "git@github.com:thelinuxtubetltos/${project}"
        log_success "Git configured — remote set to git@github.com:thelinuxtubetltos/${project}"
    else
        log_error "Cannot determine identity — path does not contain VELOX: ${SCRIPT_DIR}"
        exit 1
    fi
}

############################################################
# Main
############################################################
main() {
    configure_git

    log_success "$(basename "$0") done"
}

main "$@"
