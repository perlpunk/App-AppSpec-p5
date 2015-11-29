#!bash

# http://stackoverflow.com/questions/7267185/bash-autocompletion-add-description-for-possible-completions

_app-spec() {

    COMPREPLY=()
    local program=app-spec
    local cur=${COMP_WORDS[$COMP_CWORD]}
#    echo "COMP_CWORD:$COMP_CWORD cur:$cur" >>/tmp/comp

    case $COMP_CWORD in

    1)
        _app-spec_compreply "_complete -- Generate self completion"$'\n'"completion -- Generate completion for a specified spec file"$'\n'"help -- Show command help"

    ;;
    *)
    # subcmds
    case ${COMP_WORDS[1]} in
      _complete)
        case $COMP_CWORD in

        2)
            _app-spec_compreply "bash -- for bash"$'\n'"zsh -- for zsh"

        ;;
        *)
        # subcmds
        case ${COMP_WORDS[2]} in
          bash)
            case $COMP_CWORD in
            *)
            case ${COMP_WORDS[$COMP_CWORD-1]} in
              --without-description)
              ;;

              *)
                _app-spec_compreply "'--without-description -- generate without description'"
              ;;
            esac
            ;;
            esac
          ;;
          zsh)
          ;;
        esac

        ;;
        esac
      ;;
      completion)
        case $COMP_CWORD in

        2)
            _app-spec_compreply "bash -- for bash"$'\n'"zsh -- for zsh"

        ;;
        *)
        # subcmds
        case ${COMP_WORDS[2]} in
          bash)
            case $COMP_CWORD in
            3)
            ;;
            *)
            case ${COMP_WORDS[$COMP_CWORD-1]} in
              --without-description)
              ;;

              *)
                _app-spec_compreply "'--without-description -- generate without description'"
              ;;
            esac
            ;;
            esac
          ;;
          zsh)
            case $COMP_CWORD in
            3)
            ;;
            esac
          ;;
        esac

        ;;
        esac
      ;;
      help)
        case $COMP_CWORD in

        2)
            _app-spec_compreply "_complete"$'\n'"completion"

        ;;
        *)
        # subcmds
        case ${COMP_WORDS[2]} in
          _complete)
            case $COMP_CWORD in

            3)
                _app-spec_compreply "bash"$'\n'"zsh"

            ;;
            *)
            # subcmds
            case ${COMP_WORDS[3]} in
              bash)
              ;;
              zsh)
              ;;
            esac

            ;;
            esac
          ;;
          completion)
            case $COMP_CWORD in

            3)
                _app-spec_compreply "bash"$'\n'"zsh"

            ;;
            *)
            # subcmds
            case ${COMP_WORDS[3]} in
              bash)
              ;;
              zsh)
              ;;
            esac

            ;;
            esac
          ;;
        esac

        ;;
        esac
      ;;
    esac

    ;;
    esac

}

_app-spec_compreply() {
    IFS=$'\n' COMPREPLY=($(compgen -W "$1" -- ${COMP_WORDS[COMP_CWORD]}))
    if [[ ${#COMPREPLY[*]} -eq 1 ]]; then #Only one completion
        COMPREPLY=( ${COMPREPLY[0]%% -- *} ) #Remove ' -- ' and everything after
    fi
}



complete -o default -F _app-spec app-spec

