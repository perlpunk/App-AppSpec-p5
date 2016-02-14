#!bash

# http://stackoverflow.com/questions/7267185/bash-autocompletion-add-description-for-possible-completions

_appspec() {

    COMPREPLY=()
    local program=appspec
    local cur=${COMP_WORDS[$COMP_CWORD]}
#    echo "COMP_CWORD:$COMP_CWORD cur:$cur" >>/tmp/comp

    case $COMP_CWORD in

    1)
        _appspec_compreply '_complete  -- Generate self completion'$'\n''completion -- Generate completion for a specified spec file'$'\n''help       -- Show command help'$'\n''pod        -- Generate pod'$'\n''validate   -- Validate spec file'

    ;;
    *)
    # subcmds
    case ${COMP_WORDS[1]} in
      _complete)
        case $COMP_CWORD in
        *)
        case ${COMP_WORDS[$COMP_CWORD-1]} in
          --color|-C)
          ;;
          --help|-h)
          ;;
          --name)
          ;;
          --zsh)
          ;;
          --bash)
          ;;

          *)
            _appspec_compreply "'--color -- output colorized'"$'\n'"'-C      -- output colorized'"$'\n'"'--help  -- Show command help'"$'\n'"'-h      -- Show command help'"$'\n'"'--name  -- name of the program'"$'\n'"'--zsh   -- for zsh'"$'\n'"'--bash  -- for bash'"
          ;;
        esac
        ;;
        esac
      ;;
      completion)
        case $COMP_CWORD in
        *)
        case ${COMP_WORDS[$COMP_CWORD-1]} in
          --color|-C)
          ;;
          --help|-h)
          ;;
          --spec)
          ;;
          --stdin)
          ;;
          --name)
          ;;
          --zsh)
          ;;
          --bash)
          ;;

          *)
            _appspec_compreply "'--color -- output colorized'"$'\n'"'-C      -- output colorized'"$'\n'"'--help  -- Show command help'"$'\n'"'-h      -- Show command help'"$'\n'"'--spec  -- Path to the spec file'"$'\n'"'--stdin -- Spec as STDIN'"$'\n'"'--name  -- name of the program'"$'\n'"'--zsh   -- for zsh'"$'\n'"'--bash  -- for bash'"
          ;;
        esac
        ;;
        esac
      ;;
      help)
        case $COMP_CWORD in

        2)
            _appspec_compreply '_complete '$'\n''completion'$'\n''pod       '$'\n''validate  '

        ;;
        *)
        # subcmds
        case ${COMP_WORDS[2]} in
          _complete)
          ;;
          completion)
          ;;
          pod)
          ;;
          validate)
          ;;
        esac

        ;;
        esac
      ;;
      pod)
        case $COMP_CWORD in
        *)
        case ${COMP_WORDS[$COMP_CWORD-1]} in
          --color|-C)
          ;;
          --help|-h)
          ;;
          --spec)
          ;;
          --stdin)
          ;;

          *)
            _appspec_compreply "'--color -- output colorized'"$'\n'"'-C      -- output colorized'"$'\n'"'--help  -- Show command help'"$'\n'"'-h      -- Show command help'"$'\n'"'--spec  -- Path to the spec file'"$'\n'"'--stdin -- Spec as STDIN'"
          ;;
        esac
        ;;
        esac
      ;;
      validate)
        case $COMP_CWORD in
        *)
        case ${COMP_WORDS[$COMP_CWORD-1]} in
          --color|-C)
          ;;
          --help|-h)
          ;;
          --spec)
          ;;
          --stdin)
          ;;

          *)
            _appspec_compreply "'--color -- output colorized'"$'\n'"'-C      -- output colorized'"$'\n'"'--help  -- Show command help'"$'\n'"'-h      -- Show command help'"$'\n'"'--spec  -- Path to the spec file'"$'\n'"'--stdin -- Spec as STDIN'"
          ;;
        esac
        ;;
        esac
      ;;
    esac

    ;;
    esac

}

_appspec_compreply() {
    IFS=$'\n' COMPREPLY=($(compgen -W "$1" -- ${COMP_WORDS[COMP_CWORD]}))
    if [[ ${#COMPREPLY[*]} -eq 1 ]]; then # Only one completion
        COMPREPLY=( ${COMPREPLY[0]%% -- *} ) # Remove ' -- ' and everything after
        COMPREPLY="$(echo -e "$COMPREPLY" | sed -e 's/[[:space:]]*$//')"
    fi
}



complete -o default -F _appspec appspec
