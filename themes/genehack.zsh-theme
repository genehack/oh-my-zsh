function precmd {
  local load vcs base_dir sub_dir ref P1 P2 P3 P4

  P1="%{$fg_bold[light_grey]%}%*%{$reset_color%}"
  P2="%{$fg[green]%}%m%{$reset_color%}"

  if [ -e /proc/loadavg ]; then
      load=( $(</proc/loadavg) )
  else
      load=""
  fi

  P3=""
  if [ $load ]; then
      if [ ${load%.*} -ge 2 ]; then
          P3="\[%{$bg[white]%}%{$fg[red]%}$load%{$reset_color%}\]"
      else
	  P3="\[%{$fg[blue]$load%{$reset_color%}\]"
      fi
  fi

  P4="%(?,%{$fg[green]%}☺%{$reset_color%},%{$fg[red]%}☹ [ $? ]%{$reset_color%})"
  
  ZSH_THEME_GIT_PROMPT_PREFIX=""
  ZSH_THEME_GIT_PROMPT_SUFFIX=""
  ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%} "
  ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}•%{$reset_color%} "
  ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%}✭%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✹%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[white]%}➜%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}═%{$reset_color%}"

  STATUS=""
  CHERRY=$(git cherry 2> /dev/null)
  if [ -n "$CHERRY" ]; then
      STATUS="%{$fg[cyan]%}↑%{$reset_color%}"
  fi

  STASH=$(git stash list 2> /dev/null | tail -n1)
  if [ -n "$STASH" ]; then
      STATUS="%{$fg[red]%}%{$bg[white]%}↓%{$reset_color%}"
  fi
  
  PROMPT="
$P2:%{$fg_bold[yellow]%}%~%{$reset_color%}$P3
$P4 %# "

  RPROMPT="$(git_prompt_info)$(git_prompt_status)$STATUS $P1"
}
