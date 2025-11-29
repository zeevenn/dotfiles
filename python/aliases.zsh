# Python aliases

# Python shortcuts
alias py='python3'
alias python='python3'
alias pip='pip3'

# Virtual environment
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# uv shortcuts (if installed)
if command -v uv &> /dev/null; then
  alias venvuv='uv venv'
  alias pipi='uv pip install'
  alias pipu='uv pip uninstall'
fi

# Common Python commands
alias pyserver='python3 -m http.server'
alias pyjson='python3 -m json.tool'

