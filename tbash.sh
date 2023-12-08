#!/usr/bin/env bash

shopt -s expand_aliases

alias str='declare'
alias int='declare -i'
alias bool='declare'
alias array='declare -a'
alias dict='declare -A'

const() {
    if [[ "$1" == "int" ]]; then
        echo "declare -r -i"
    elif [[ "$1" == "str" ]]; then
        echo "declare -r"
    fi
}

str GREEN=$'\e[1;32m'
str YELLOW=$'\e[1;33m'
str RED=$'\e[1;31m'
str DEFAULT=$'\e[0m'

bool TRUE=true
bool FALSE=false

bool DEBUG=TRUE

int TYPE_STRING=0
int TYPE_INTEGER=1
int TYPE_ARRAY=2
int TYPE_ASSOC_ARRAY=3
int TYPE_NONE=4

ok()    { printf "${GREEN}$1${DEFAULT}\n";   }
debug() { [[ $DEBUG ]] && printf "$1\n" >&2; }
warn()  { printf "${YELLOW}$1${DEFAULT}\n";  }
err()   { printf "${RED}$1${DEFAULT}\n" >&2; }

panic() { err "$1" && exit; }

#################################### Utils ####################################

get_type() {
    local -r VAR_TYPE=$(declare -p "$1" 2>/dev/null)

    debug "$1 has type $VAR_TYPE"
    case "$VAR_TYPE" in
        *"declare -- "*) return $TYPE_STRING ;;
        *"declare -i"*)  return $TYPE_INTEGER ;;
        *"declare -a"*)  return $TYPE_ARRAY ;;
        *"declare -A"*)  return $TYPE_ASSOC_ARRAY ;;
        *) return $TYPE_NONE ;;
    esac
}

# int: [[ $1 -eq $2 ]]
# str: [[ $1 == $2 ]]
equal() {
    local -r FIRST="$1"
    local -r FIRST_TYPE=$(get_type FIRST)
    local -r SECOND="$2"
    local -r SECOND_TYPE=$(get_type SECOND)

    if [[ "$FIRST_TYPE" -eq "$TYPE_NONE" \
       || "$SECOND_TYPE" -eq "$TYPE_NONE" ]]; then
        panic "Var(s) not typed"
    fi

    if [[ "$FIRST_TYPE" -ne "$SECOND_TYPE" ]]; then
        panic "Comparing different types"
    fi

    if [[ "$FIRST_TYPE" -eq "$TYPE_STRING" ]]; then
        [[ "$FIRST" == "$SECOND" ]] && $TRUE || $FALSE
    fi

    if [[ "$FIRST_TYPE" -eq "$TYPE_INTEGER" ]]; then
        [[ "$FIRST" -eq "$SECOND" ]] && $TRUE || $FALSE
    fi
}

len() {
    local -r VAR_TYPE=$(get_type $1)

    if [[ "$VAR_TYPE" -eq "$TYPE_INTEGER" ]]; then
        panic "$1 not string nor array"
    fi

    if [[ "$VAR_TYPE" -eq "$TYPE_STRING" ]]; then
        printf "${#1}"
    elif [[ "$VAR_TYPE" -eq "$TYPE_ARRAY" \
         || "$VAR_TYPE" -eq "$TYPE_ASSOC_ARRAY" ]]; then
        printf ${#1[@]}
    fi
}

#################################### Array ####################################

# This function is missing input validation: you may pass
create_array() {
    array a=( "${@}" )
    echo "${a[@]}"
}

find_in_array() {
    local findme="$1"

}

pop_from_array() {
    local deleteme="$1"
}
