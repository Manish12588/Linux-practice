#!/bin/bash

# ─────────────────────────────────────────────
#   Interactive Command Explorer
#   Navigate with ↑ ↓ arrows, Enter to select
#   Press 'q' to quit
# ─────────────────────────────────────────────

# ── Color codes ──────────────────────────────
RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[1;31m"
DIM="\033[2m"
HIGHLIGHT="\033[1;7;36m"   # bold + reverse + cyan  (selected row)

# ── Command definitions ───────────────────────
# Each entry: "label|actual_command|description"
COMMANDS=(
    "pwd        | pwd                   | Print current working directory"
    "mkdir      | mkdir demo_folder     | Create a new directory called demo_folder"
    "ls         | ls                    | List files in current directory"
    "ls -a      | ls -a                 | List ALL files including hidden ones"
    "touch      | touch demo_file.txt   | Create a new empty file called demo_file.txt"
)

TOTAL=${#COMMANDS[@]}
selected=0   # currently highlighted index

# ── Helper: parse a field from a COMMANDS entry ─
get_field() {
    # $1 = index, $2 = field number (1-based)
    echo "${COMMANDS[$1]}" | awk -F'|' "{print \$$2}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# ── Draw the menu ────────────────────────────
draw_menu() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "  ╔══════════════════════════════════════════════════════╗"
    echo "  ║          🖥️   Interactive Command Explorer            ║"
    echo "  ║     ↑ ↓ to navigate  •  Enter to run  •  q to quit  ║"
    echo "  ╚══════════════════════════════════════════════════════╝"
    echo -e "${RESET}"

    for i in "${!COMMANDS[@]}"; do
        label=$(get_field $i 1)
        desc=$(get_field $i 3)

        if [[ $i -eq $selected ]]; then
            # Highlighted row
            printf "  ${HIGHLIGHT}  ▶  %-12s   %s  ${RESET}\n" "$label" "$desc"
        else
            printf "  ${DIM}     %-12s${RESET}   ${DIM}%s${RESET}\n" "$label" "$desc"
        fi
    done

    echo ""
    echo -e "  ${DIM}─────────────────────────────────────────────────────${RESET}"
}

# ── Show result after running a command ──────
show_result() {
    local label=$(get_field $selected 1)
    local cmd=$(get_field $selected 2)
    local desc=$(get_field $selected 3)

    clear
    echo -e "${CYAN}${BOLD}"
    echo "  ╔══════════════════════════════════════════════════════╗"
    echo "  ║                   Command Result                     ║"
    echo "  ╚══════════════════════════════════════════════════════╝"
    echo -e "${RESET}"

    echo -e "  ${YELLOW}${BOLD}Command   :${RESET}  ${GREEN}${cmd}${RESET}"
    echo -e "  ${YELLOW}${BOLD}Info      :${RESET}  ${desc}"
    echo ""
    echo -e "  ${BLUE}${BOLD}── Output ──────────────────────────────────────────${RESET}"
    echo ""

    # Run the command and capture output
    output=$(eval "$cmd" 2>&1)
    exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        echo -e "${GREEN}"
        echo "$output" | sed 's/^/    /'   # indent output
        echo -e "${RESET}"
        echo ""
        echo -e "  ${GREEN}✔  Command exited successfully (code 0)${RESET}"
    else
        echo -e "${RED}"
        echo "$output" | sed 's/^/    /'
        echo -e "${RESET}"
        echo ""
        echo -e "  ${RED}✘  Command exited with error (code $exit_code)${RESET}"
    fi

    echo ""
    echo -e "  ${DIM}─────────────────────────────────────────────────────${RESET}"
    echo -e "  Press ${BOLD}any key${RESET} to go back to the menu..."
    read -rsn1   # wait for keypress
}

# ── Main loop ────────────────────────────────
while true; do
    draw_menu

    # Read a single keypress (handle escape sequences for arrows)
    read -rsn1 key

    if [[ $key == $'\x1b' ]]; then
        # Escape sequence — read 2 more chars
        read -rsn2 -t 0.1 key2
        case "$key2" in
            '[A')   # Up arrow
                ((selected--))
                [[ $selected -lt 0 ]] && selected=$((TOTAL - 1))
                ;;
            '[B')   # Down arrow
                ((selected++))
                [[ $selected -ge $TOTAL ]] && selected=0
                ;;
        esac
    elif [[ $key == "" ]]; then
        # Enter key
        show_result
    elif [[ $key == "q" || $key == "Q" ]]; then
        clear
        echo -e "${CYAN}${BOLD}  Goodbye! 👋${RESET}"
        echo ""
        exit 0
    fi
done
