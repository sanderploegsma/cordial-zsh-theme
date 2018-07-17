function collapse_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

function parse_git_dirty {
  local SUBMODULE_SYNTAX=''
  if [[ $POST_1_7_2_GIT -gt 0 ]]; then
    SUBMODULE_SYNTAX="--ignore-submodules=dirty"
  fi
  branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ -n $(git status -s ${SUBMODULE_SYNTAX}  2> /dev/null) ]]; then
    echo "${branch}*"
  else
    echo "${branch}"
  fi
}

function git_prompt_info {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "($(parse_git_dirty)) "
}

function k8s_info {
  ctx=$(kubectl config current-context 2> /dev/null) || return
  ns=$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${ctx}\")].context.namespace}") || return
  echo "(${ctx}:${ns}) "
}

local ret_status="%(?:%{$fg_bold[green]%}»:%{$fg_bold[red]%}»%s)"
local newline=$'\n'
PROMPT='%{$fg[green]%}$(collapse_pwd) %{$fg[yellow]%}$(k8s_info)%{$fg[cyan]%}$(git_prompt_info)${newline}${ret_status} %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

