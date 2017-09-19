_bim() {
  COMPREPLY=()
  local cur prev
  _get_comp_words_by_ref -n : cur prev

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(bim help | tail -n +2 | awk '{ print $2}')" -- "$cur") )
  elif [ $COMP_CWORD -eq 2 ]; then
    if [ $prev = "ssl" ] || [ $prev = "meta" ] || [ $prev = "sync" ]; then
      COMPREPLY=( $(compgen -W "$(bim $prev help | tail -n +2 | awk '{ print $3}')" -- $cur) )
    fi
  fi
}

complete -F _bim bim
