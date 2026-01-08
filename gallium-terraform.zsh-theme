setopt promptsubst

# Depends on the git plugin for work_in_progress()
(( $+functions[work_in_progress] )) || work_in_progress() {}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[magenta]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_TF_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TF_PROMPT_SUFFIX="%{$reset_color%}"

# Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local branch=$(git_current_branch)
  [[ -n "$branch" ]] || return 0
  echo " $(parse_git_dirty)\
%{${fg_bold[yellow]}%}$(work_in_progress)%{$reset_color%}\
${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}


tf_prompt_info_custom() {
  [[ -d "${TF_DATA_DIR:-.terraform}" ]] || return
  local workspace
  if [[ -r "${TF_DATA_DIR:-.terraform}/environment" ]]; then
    workspace="$(< "${TF_DATA_DIR:-.terraform}/environment")"
  else
    workspace="default"
  fi
  
  local bracket_color="%{$fg[magenta]%}"
  local reset="%{$reset_color%}"
  local ws_color
  
  case "$workspace" in
    dev)     ws_color="%{$fg[green]%}" ;;
    staging) ws_color="%{$fg[yellow]%}" ;;
    prod)    ws_color="%{$fg[white]%}%{$bg[red]%}" ;;
    *)       ws_color="%{$fg[white]%}" ;;
  esac
  
  echo " ${bracket_color}{${reset}${ws_color}${workspace}${reset}${bracket_color}}${reset}"
}

# Combine it all into a final prompt
RPS1=''
PROMPT='%F{cyan}%B%n@%m%b %F{red}[%~% ]$(git_custom_status)$(tf_prompt_info_custom)%F{yellow}%B λ%b%f '
