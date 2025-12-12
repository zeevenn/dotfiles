autoload colors && colors

# Load datetime module for strftime and EPOCHSECONDS
zmodload zsh/datetime

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

# Cache for git prompt info to avoid slow git commands on every prompt
typeset -gA _git_prompt_cache
_git_prompt_cache=()

# Update git prompt cache (called asynchronously or on directory change)
# Fast version: only updates branch and basic info
_update_git_prompt_cache_fast() {
  local git_dir branch ref
  git_dir=$($git rev-parse --git-dir 2>/dev/null)
  
  if [[ -z "$git_dir" ]]; then
    _git_prompt_cache=()
    return
  fi
  
  # Get branch name (fast)
  ref=$($git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -z "$ref" ]]; then
    _git_prompt_cache=()
    return
  fi
  
  branch="$ref"
  
  # Quick dirty check (fast)
  local dirty
  dirty=$($git diff --quiet --exit-code 2>/dev/null && $git diff --quiet --cached --exit-code 2>/dev/null && echo "clean" || echo "dirty")
  
  _git_prompt_cache[branch]="$branch"
  _git_prompt_cache[dirty]="$dirty"
  _git_prompt_cache[git_dir]="$git_dir"
  # Set unpushed to 0 initially, will be updated asynchronously
  _git_prompt_cache[unpushed]="0"
}

# Full update including slow operations (unpushed commits)
_update_git_prompt_cache_full() {
  local git_dir branch ref unpushed_count dirty
  git_dir=$($git rev-parse --git-dir 2>/dev/null)
  
  if [[ -z "$git_dir" ]]; then
    _git_prompt_cache=()
    return
  fi
  
  ref=$($git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -z "$ref" ]]; then
    _git_prompt_cache=()
    return
  fi
  
  branch="$ref"
  
  # Check for unpushed commits (slower operation)
  local upstream
  upstream=$($git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
  if [[ -n "$upstream" ]]; then
    # Use --count with limit for better performance
    unpushed_count=$($git rev-list --count @{u}..HEAD 2>/dev/null | head -1)
    [[ -z "$unpushed_count" ]] && unpushed_count=0
  else
    unpushed_count=0
  fi
  
  # Check dirty status
  dirty=$($git diff --quiet --exit-code 2>/dev/null && $git diff --quiet --cached --exit-code 2>/dev/null && echo "clean" || echo "dirty")
  
  _git_prompt_cache[branch]="$branch"
  _git_prompt_cache[unpushed]="$unpushed_count"
  _git_prompt_cache[dirty]="$dirty"
  _git_prompt_cache[git_dir]="$git_dir"
}

git_prompt_info() {
  local current_git_dir branch unpushed_count branch_color
  
  # Quick check if we're in a git repo
  current_git_dir=$($git rev-parse --git-dir 2>/dev/null)
  if [[ -z "$current_git_dir" ]]; then
    return
  fi
  
  # Check if cache needs update (git dir changed or cache empty)
  if [[ "$current_git_dir" != "${_git_prompt_cache[git_dir]}" ]] || [[ -z "${_git_prompt_cache[branch]}" ]]; then
    # Fast update first (non-blocking)
    _update_git_prompt_cache_fast
    # Trigger full update in background
    (_update_git_prompt_cache_full) &!
  fi
  
  branch="${_git_prompt_cache[branch]}"
  unpushed_count="${_git_prompt_cache[unpushed]:-0}"
  
  if [[ -z "$branch" ]]; then
    return
  fi
  
  # Set branch color based on unpushed commits
  if [[ $unpushed_count -gt 0 ]]; then
    branch_color="%{$fg[red]%}"
  else
    branch_color="%{$fg[green]%}"
  fi
  
  # Output git prompt
  if [[ $unpushed_count -gt 0 ]]; then
    echo " %{$fg_bold[blue]%}git:(${branch_color}${branch} +${unpushed_count}%{$fg_bold[blue]%})%{$reset_color%}"
  else
    echo " %{$fg_bold[blue]%}git:(${branch_color}${branch}%{$fg_bold[blue]%})%{$reset_color%}"
  fi
}

git_dirty_status() {
  local current_git_dir dirty
  
  # Quick check if we're in a git repo
  current_git_dir=$($git rev-parse --git-dir 2>/dev/null)
  if [[ -z "$current_git_dir" ]]; then
    return
  fi
  
  # Use cached dirty status if available and git dir matches
  if [[ "$current_git_dir" == "${_git_prompt_cache[git_dir]}" ]] && [[ -n "${_git_prompt_cache[dirty]}" ]]; then
    dirty="${_git_prompt_cache[dirty]}"
  else
    # Fallback: quick check
    dirty=$($git diff --quiet --exit-code 2>/dev/null && $git diff --quiet --cached --exit-code 2>/dev/null && echo "clean" || echo "dirty")
  fi
  
  if [[ "$dirty" == "dirty" ]]; then
    echo " %{$fg[yellow]%}✗%{$reset_color%}"
  fi
}

# Pre-computed prompt string (updated in precmd hook)
typeset -g _prompt_string=""

# Build prompt string from cached data (no git commands executed)
_build_prompt_string() {
  local status_color current_time dir_name git_info dirty_status
  
  # Status indicator (green or red based on last exit code)
  status_color="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)%{$reset_color%}"
  
  # Current time (cached, updated in precmd)
  current_time="%{$fg_bold[green]%}${_prompt_time}%{$reset_color%}"
  
  # Directory name (using zsh built-in, very fast)
  dir_name="%{$fg_bold[cyan]%}%1~%{$reset_color%}"
  
  # Git info (from cache, no git commands)
  git_info=""
  if [[ -n "${_git_prompt_cache[branch]}" ]]; then
    local branch="${_git_prompt_cache[branch]}"
    local unpushed_count="${_git_prompt_cache[unpushed]:-0}"
    local branch_color
    
    if [[ $unpushed_count -gt 0 ]]; then
      branch_color="%{$fg[red]%}"
      git_info=" %{$fg_bold[blue]%}git:(${branch_color}${branch} +${unpushed_count}%{$fg_bold[blue]%})%{$reset_color%}"
    else
      branch_color="%{$fg[green]%}"
      git_info=" %{$fg_bold[blue]%}git:(${branch_color}${branch}%{$fg_bold[blue]%})%{$reset_color%}"
    fi
  fi
  
  # Dirty status (from cache)
  dirty_status=""
  if [[ "${_git_prompt_cache[dirty]}" == "dirty" ]]; then
    dirty_status=" %{$fg[yellow]%}✗%{$reset_color%}"
  fi
  
  _prompt_string="${status_color} ${current_time} ${dir_name}${git_info}${dirty_status} "
}

# Use zsh hook system, so it won't overwrite VS Code's shell integration
autoload -U add-zsh-hook

# Track current directory to detect changes
typeset -g _git_prompt_last_dir=""
typeset -g _prompt_time=""

# Update git cache and build prompt string in precmd hook
_dotfiles_precmd() {
  local current_dir
  current_dir=$(pwd)
  
  # Update time (fast, no external command needed in zsh)
  _prompt_time=$(strftime "%H:%M" $EPOCHSECONDS)
  
  # Update cache if directory changed
  if [[ "$current_dir" != "$_git_prompt_last_dir" ]]; then
    _git_prompt_last_dir="$current_dir"
    # Fast update first, then full update in background
    _update_git_prompt_cache_fast
    (_update_git_prompt_cache_full) &!
  fi
  
  # Build prompt string from cache (no git commands, instant)
  _build_prompt_string
  
  # Set PROMPT to pre-computed string
  PROMPT="$_prompt_string"
  
  title "zsh" "%m" "%55<...<%~"
}

add-zsh-hook precmd _dotfiles_precmd

# Initialize cache and prompt on first load
_update_git_prompt_cache_fast
_prompt_time=$(strftime "%H:%M" $EPOCHSECONDS)
_build_prompt_string
PROMPT="$_prompt_string"
