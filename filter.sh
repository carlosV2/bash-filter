function filter()
{
    # Based on https://github.com/ICanBoogie/Inflector project
    function singularify()
    {
        word=`echo "${1}" | tr "[A-Z]" "[a-z]"`

        regexes=(
            # Irregulars
            's/^leaves$/leaf/g'
            's/^loaves$/loaf/g'
            's/^octopuses$/octopus/g'
            's/^viruses$/virus/g'
            's/^people$/person/g'
            's/^men$/man/g'
            's/^children$/child/g'
            's/^sexes$/sex/g'
            's/^moves$/move/g'
            's/^zombies$/zombie/g'
            's/^geese$/goose/g'

            # Rules
            's/(database)s$/\1/g'
            's/(quiz)zes$/\1/g'
            's/(matr)ices$/\1ix/g'
            's/(vert|ind)ices$/\1ex/g'
            's/^(ox)en/\1/g'
            's/(alias|status)(es)?$/\1/g'
            's/^(a)x[ie]s$/\1xis/g'
            's/(cris|test)(is|es)$/\1is/g'
            's/(shoe)s$/\1/g'
            's/(o)es$/\1/g'
            's/(bus)(es)?$/\1/g'
            's/^(m|l)ice$/\1ouse/g'
            's/(x|ch|ss|sh)es$/\1/g'
            's/(m)ovies$/\1ovie/g'
            's/(s)eries$/\1eries/g'
            's/([^aeiouy]|qu)ies$/\1y/g'
            's/([lr])ves$/\1f/g'
            's/(tive)s$/\1/g'
            's/(hive)s$/\1/g'
            's/([^f])ves$/\1fe/g'
            's/(^analy)(sis|ses)$/\1sis/g'
            's/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$/\1sis/g'
            's/([ti])a$/\1um/g'
            's/(n)ews$/\1ews/g'
            's/(ss)$/\1/g'
            's/s$//g'
        )

        uncountables=" advice art coal baggage butter clothing cotton currency equipment experience feedback fish flour food furniture gas homework impatience information jeans knowledge leather love luggage money oil management patience police polish progress research rice series sheep staff silk soap species sugar talent toothpaste travel vinegar weather wood wool work "
        uncountable=`echo "${uncountables}" | grep " ${word} "`

        if [ "${uncountable}" != "" ]; then
            echo "${word}"
            return
        fi

        for regex in "${regexes[@]}"; do
            singular=`echo "${word}" | sed -E "${regex}"`
            if [ "${singular}" != "${word}" ]; then
                echo "${singular}"
                return
            fi
        done

        echo "${word}"
    }

    # Based on https://github.com/ICanBoogie/Inflector project
    function pluralify()
    {
        word=`echo "${1}" | tr "[A-Z]" "[a-z]"`

        regexes=(
            # Irregulars
            's/^leaves$/leaf/g'
            's/^loaves$/loaf/g'
            's/^octopuses$/octopus/g'
            's/^viruses$/virus/g'
            's/^people$/person/g'
            's/^men$/man/g'
            's/^children$/child/g'
            's/^sexes$/sex/g'
            's/^moves$/move/g'
            's/^zombies$/zombie/g'
            's/^geese$/goose/g'

            # Rules
            's/(quiz)$/\1zes/g'
            's/^(oxen)$/\1/g'
            's/^(ox)$/\1en/g'
            's/^(m|l)ice$/\1ice/g'
            's/^(m|l)ouse$/\1ice/g'
            's/(matr|vert|ind)(ix|ex)$/\1ices/g'
            's/(x|ch|ss|sh)$/\1es/g'
            's/([^aeiouy]|qu)y$/\1ies/g'
            's/(hive)$/\1s/g'
            's/(([^f])fe|([lr])f)$/\2\3ves/g'
            's/sis$/ses/g'
            's/([ti])a$/\1a/g'
            's/([ti])um$/\1a/g'
            's/(buffal|tomat)o$/\1oes/g'
            's/(bu)s$/\1ses/g'
            's/(alias|status)$/\1es/g'
            's/^(ax|test)is$/\1es/g'
            's/s$/s/g'
            's/$/s/g'
        )

        uncountables=" advice art coal baggage butter clothing cotton currency equipment experience feedback fish flour food furniture gas homework impatience information jeans knowledge leather love luggage money oil management patience police polish progress research rice series sheep staff silk soap species sugar talent toothpaste travel vinegar weather wood wool work "
        uncountable=`echo "${uncountables}" | grep " ${word} "`

        if [ "${uncountable}" != "" ]; then
            echo "${word}"
            return
        fi

        for regex in "${regexes[@]}"; do
            plural=`echo "${word}" | sed -E "${regex}"`
            if [ "${plural}" != "${word}" ]; then
                echo "${plural}"
                return
            fi
        done

        echo "${word}"
    }

    function filterify()
    {
        tildeFlag=false
        separator=""
        param=""
        search="${1}"

        if [ "${search:0:1}" == "=" ]; then
            search="${search:1}"
            separator=" "
        fi

        if [ "${search:0:1}" == "~" ]; then
            search="${search:1}"
            tildeFlag=true
        fi

        if [ "${search:0:1}" == "-" ]; then
            search="${search:1}"
            param="-v"
        elif [ "${search:0:1}" == "+" ]; then
            search="${search:1}"
        fi

        if [ "${tildeFlag}" == true ]; then
            singular=`singularify "${search}"`
            plural=`pluralify "${search}"`

            search="${singular}${separator}\|${separator}${plural}"
        fi

        echo " | grep ${param} -i -- \"${separator}${search}${separator}\""
    }

    function main()
    {
        GREEN="\033[32m"
        YELLOW="\033[33m"
        RESET="\033[0m"

        filters=""
        for arg in "$@"
        do
            filters="${filters} `filterify ${arg}`"
        done
        
        total=0
        found=0
        blank=0
        while read -r line; do
            if [[ "${line}" == "" ]]; then
                blank=$((blank + 1))
            else
                result=`eval "echo ' ${line//\'/\'\"'\"'} ' ${filters}"`

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

    main "$@"

    unset -f singularify
    unset -f pluralify
    unset -f filterify
}

UPDATE_PATH=`dirname ${BASH_SOURCE}`
$(cd ${UPDATE_PATH}; git submodule update --init -q) > /dev/null
source "${UPDATE_PATH}/lib/update/update.sh"
