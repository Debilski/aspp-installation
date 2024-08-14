
__conda_ps1() {
        if [ -z "$CONDA_PROMPT_MODIFIER" ] ; then
                echo ""
        else
                echo "${CONDA_PROMPT_MODIFIER}"
        fi
}
__virtualenv_ps1() {
        if [ -z "$VIRTUAL_ENV" ] ; then
                echo ""
        else
                # If the $VIRTUAL_ENV_PROMPT is equal to "(venv) ", we will use
                # our own heuristic
                local prompt="${VIRTUAL_ENV_PROMPT:-(venv) }"
                if [ "$prompt" == "(venv) " ] ; then
                        echo "($(basename "$(dirname "$VIRTUAL_ENV")")) "
                else
                        echo "$VIRTUAL_ENV_PROMPT"
                fi

        fi
}

# These escape codes and characters may be changed

PROMPT_CHAR='❯'
PROMPT_COL_OK='\[\033[38;5;199m\]'
PROMPT_COL_HOST='\[\033[00;33m\]'
PROMPT_COL_HOST='\[\033[38;5;172m\]'
PROMPT_COL_GRAY='\001\e[38;5;246m\002'
PROMPT_COL_PATH='\[\033[00;34m\]'
PROMPT_COL_PATH_FINAL='\[\033[01;34m\]'
PROMPT_COL_BAD='\[\033[38;5;196m\]'
PROMPT_COL_ROOT='\[\033[1;38;5;196m\]'
PROMPT_SHOW_HOST=1
PROMPT_PATH_SEPARATOR=" "

# This should not be overwritten
PROMPT_COL_RESET='\[\033[0m\]'

# slightly adapt the default colours for git
__git_ps1_colorize_gitstring ()
{
        if [[ -n ${ZSH_VERSION-} ]]; then
                local c_red='%F{red}'
                local c_green='%F{green}'
                local c_lblue='%F{blue}'
                local c_clear='%f'
        else
                # Using \001 and \002 around colors is necessary to prevent
                # issues with command line editing/browsing/completion!
                local c_red=$'\001\e[31m\002'
                local c_green=$'\001\e[32m\002'
                local c_lblue=$'\001\e[1;34m\002'
                local c_clear=$'\001\e[0m\002'
        fi
        local bad_color=$c_red
        local ok_color=$c_green
        local flags_color="$c_lblue"

        local branch_color=""
        if [ $detached = no ]; then
                branch_color="$PROMPT_COL_GRAY"
        else
                branch_color="$bad_color"
        fi
        if [ -n "$c" ]; then
                c="$branch_color$c$c_clear"
        fi
        b="$branch_color$b$c_clear"

        if [ -n "$w" ]; then
                w="$bad_color$w$c_clear"
        fi
        if [ -n "$i" ]; then
                i="$ok_color$i$c_clear"
        fi
        if [ -n "$s" ]; then
                s="$flags_color$s$c_clear"
        fi
        if [ -n "$u" ]; then
                u="$bad_color$u$c_clear"
        fi
}

__prompt_command() {
        local exit=$?

        if [ "$exit" == "0" ]; then
                local prompt_char="$PROMPT_COL_OK$PROMPT_CHAR$PROMPT_COL_RESET";
        else
                local prompt_char="$PROMPT_COL_BAD$PROMPT_CHAR$PROMPT_COL_RESET";
        fi

        local short_pwd="${PWD/#${HOME}/\~}"
        # Edge cases:
        if [ "$short_pwd" == "/" ]; then
                local prompt_path="$PROMPT_COL_PATH_FINAL${short_pwd}$PROMPT_COL_RESET"
        elif [ "$short_pwd" == "~" ]; then
                local prompt_path="$PROMPT_COL_PATH_FINAL${short_pwd}$PROMPT_COL_RESET"
        else
                # bolden the segment after the last /
                local prompt_path="$PROMPT_COL_PATH${short_pwd%/*}/$PROMPT_COL_PATH_FINAL${short_pwd##*/}$PROMPT_COL_RESET"
        fi

        if [ "$USER" == "root" ]; then
                local prompt_user="$PROMPT_COL_ROOT\u$PROMPT_COL_RESET"
        else
                local prompt_user="\u"
        fi

        __git_ps1 "\n${PROMPT_SHOW_HOST+$PROMPT_COL_HOST$prompt_user$PROMPT_COL_HOST@\h$PROMPT_COL_RESET$PROMPT_PATH_SEPARATOR}$prompt_path" "\n$(__conda_ps1)$(__virtualenv_ps1)$prompt_char " " [%s]"
        return $exit
}

PROMPT_COMMAND=__prompt_command
