function filter()
{
    GREEN="\033[32m"
    YELLOW="\033[33m"
    RESET="\033[0m"

    filters=""
    for arg in "$@"
    do
        param=""
        if [ "${arg:0:1}" == "-" ]; then
            arg="${arg:1}"
            param="-v"
        elif [ "${arg:0:1}" == "+" ]; then
            arg="${arg:1}"
        fi

        filters="${filters} | grep ${param} -i -- \"${arg}\""
    done

    total=0
    found=0
    blank=0
    while read line; do
        if [[ "${line}" == "" ]]; then
            blank=$((blank + 1))
        else
            result=`eval "echo '${line}' ${filters}"`

            if [[ "${result}" != "" ]]; then
                echo "${line}"
                found=$((found + 1))
            fi
        fi
        total=$((total + 1))
    done

    if [[ ${FILTER_STATS} != false ]]; then
        blank="${blank} blank lines"

        if [[ ${FILTER_COLORS} != false ]]; then
            total="${GREEN}${total}${RESET}"
            found="${GREEN}${found}${RESET}"
            blank="${YELLOW}${blank}${RESET}"
        fi

        echo
        echo -e "Found ${found} of ${total} (${blank})"
    fi
}