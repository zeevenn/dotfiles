autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty_status() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    if [[ -n "$(git status --porcelain)" ]]; then
      echo " %{$fg[yellow]%}✗%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    ref=$($git symbolic-ref HEAD 2>/dev/null) || return
    branch="${ref#refs/heads/}"
    
    number=$($git cherry -v origin/$(git symbolic-ref --short HEAD) 2>/dev/null | wc -l | bc)
    if [[ $number -gt 0 ]]; then
      echo "%{$fg_bold[blue]%}git:(%{$fg[red]%}${branch} +${number}%{$fg_bold[blue]%})%{$reset_color%}"
    else
      echo "%{$fg_bold[blue]%}git:(%{$fg[red]%}${branch}%{$fg_bold[blue]%})%{$reset_color%}"
    fi
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%{$reset_color%}"
}

current_time() {
  echo "\033[1;92m$(date +%H:%M)\033[0m"
}

# Prompt status indicator: changes color based on last command exit code
prompt_status() {
  echo "%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)%{$reset_color%}"
}

export PROMPT='$(prompt_status) $(current_time) $(directory_name) $(git_prompt_info)$(git_dirty_status) '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
