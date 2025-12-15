autoload colors && colors

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

# Use zsh hook system, so it won't overwrite VS Code's shell integration
autoload -U add-zsh-hook

# Build prompt in precmd (not dynamically in PROMPT)
# This avoids conflicts with atuin and other tools
_dotfiles_precmd() {
  # Status indicator (must use %? here, evaluated at render time)
  local status_indicator="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)%{$reset_color%}"
  
  # Current time
  local current_time="%{$fg_bold[green]%}$(date +%H:%M)%{$reset_color%}"
  
  # Directory
  local dir_name="%{$fg_bold[cyan]%}%1~%{$reset_color%}"
  
  # Git info
  local git_info=""
  local dirty_status=""
  
  if $git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch unpushed branch_color
    branch=$($git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
      # Check unpushed commits (faster than git cherry -v)
      unpushed=$($git rev-list --count origin/${branch}..HEAD 2>/dev/null)
      
      if [[ -n "$unpushed" && "$unpushed" -gt 0 ]]; then
        branch_color="%{$fg[red]%}"
        git_info=" %{$fg_bold[blue]%}git:(${branch_color}${branch} +${unpushed}%{$fg_bold[blue]%})%{$reset_color%}"
      else
        branch_color="%{$fg[green]%}"
        git_info=" %{$fg_bold[blue]%}git:(${branch_color}${branch}%{$fg_bold[blue]%})%{$reset_color%}"
      fi
    fi
    
    # Dirty check
    if [[ -n "$($git status --porcelain 2>/dev/null)" ]]; then
      dirty_status=" %{$fg[yellow]%}✗%{$reset_color%}"
    fi
  fi
  
  PROMPT="${status_indicator} ${current_time} ${dir_name}${git_info}${dirty_status} "
  
  title "zsh" "%m" "%55<...<%~"
}

add-zsh-hook precmd _dotfiles_precmd

# Initialize prompt
PROMPT="%{$fg_bold[green]%}➜%{$reset_color%} "
