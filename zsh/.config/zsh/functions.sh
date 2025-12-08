function load_sdkman() {
  export SDKMAN_DIR="/Users/pwntester/.sdkman"
  [[ -s "/Users/pwntester/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/pwntester/.sdkman/bin/sdkman-init.sh"
}

function load_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi
}

function load_rbenv() {
  export RBENV_ROOT="$HOME/.rbenv"
  export PATH="$RBENV_ROOT/bin:$PATH"
  eval "$(rbenv init -)"
}

function load_nvm() {
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  export PATH="/usr/local/opt/node@16/bin:$PATH"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
}

function cdr() {
  cd "$(gh cdr "$@")" || return
}

function sarif() {
  nvim -c "QL sarif load $1"
}

# XBOW
function get_bm_compose() {
  bm get benchmark $1 | jq -r '.dockerCompose' | yq --output-format=yaml 'del(.services.attack) | del(.services."xb-hosting")'
}

function bb() {
  if [[ -z "$1" ]]; then
    echo "Error: domain required"
    echo "Usage: bb <domain>"
    return 1
  fi
  curl -s -H 'Authorization: Bearer asdf' "172.27.209.218:8080/api/v1/scope/from-host?host=$1" | jq -r '.[0].source'
}

bbs() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        echo "Error: File '$file' not found" >&2
        return 1
    fi
    
    while IFS= read -r url; do
        # Skip empty lines
        [[ -z "$url" ]] && continue
        
        # Extract host from URL
        host=$(echo "$url" | sed -E 's|^https?://([^/]+).*|\1|')
        
        # Call API and extract source, fallback to ??? if curl fails
        program=$(curl -s -H 'Authorization: Bearer asdf' "172.27.209.218:8080/api/v1/scope/from-host?host=$host" | jq -r '.[0].source' 2>/dev/null)
        
        # If curl failed or jq returned null/empty, use ???
        if [[ -z "$program" || "$program" == "null" ]]; then
            program="???"
        fi
        
        echo "$program"
    done < "$file"
}

function bbi-search-string() {
  curl -s \
    -H 'Authorization: Bearer asdf' \
    -H 'content-type: application/json' \
    '172.27.209.218:8080/api/v1/query/query' \
    -d "{\"query\":\"values.header.set_cookie:*${1}* OR values.raw_header:*${1}* OR values.body:*${1}* OR values.body_preview:*${1}*\"}" |
    jq 'select(.kind=="task.httpx") | .values.url'
}

function bm() {
  export XBOW_BM_ENDPOINT="https://xbow-bm-$1.eng.xbow.com"
  export XBOW_BM_URL="https://xbow-bm-$1.eng.xbow.com"
  xbow-bm login-aws
  export XBOW_TOKEN=$(cat "$HOME/.xbow/xbow-bm/cli/idToken-httpsxbow-bm-$1.eng.xbow.comapi")
  export XBOW_BM_TOKEN=$(cat "$HOME/.xbow/xbow-bm/cli/idToken-httpsxbow-bm-$1.eng.xbow.comapi")
  echo "BM Endpoint: $XBOW_BM_ENDPOINT"
  masked_token="${XBOW_TOKEN:0:16}****"
  echo "BM Token: $masked_token"
}

function get_run_logs() {
  # Log in to the ssh-host of an experimentRun's deployment, and cd to the logs
  # folder.
  #
  # Usage: run-logs <experimentRunId>

  RUNID=$1
  BM_CMD=xbow-bm
  DEPLOYMENT=$($BM_CMD get experimentRun $RUNID | jq -r '.deploymentId')
  if [ -z "$DEPLOYMENT" ]; then
    # Try on larch
    BM_CMD=larch-bm
    DEPLOYMENT=$($BM_CMD get experimentRun $RUNID | jq -r '.deploymentId')
    if [ -z "$DEPLOYMENT" ]; then
      echo "ExperimentRunId $RUNID not found on normal or larch BM; exiting"
      exit 1
    fi
  fi
  echo "SSH to $DEPLOYMENT"
  $BM_CMD ssh-host $DEPLOYMENT -- "cd /var/local/xbow/tmp/$RUNID/logs && bash"
}

# Devcontainer utilities
function load_devcontainer() {
  # Add devcontainer scripts to PATH (for dc-init and dc-nvim)
  export PATH="$HOME/dotfiles/devcontainer/.config/devcontainer/scripts:$PATH"

  # Main devcontainer CLI alias
  alias dc='devcontainer'

  # Convenience aliases for common operations
  alias dci='dc-init'                                                      # Initialize from template
  alias dcu='devcontainer up --workspace-folder .'                         # Start container
  alias dce='devcontainer exec --workspace-folder .'                       # Execute command in container
  alias dcr='devcontainer up --workspace-folder . --remove-existing-container'  # Rebuild container
  alias dcs='devcontainer exec --workspace-folder . bash'                  # Open shell in container
  alias dcc='devcontainer exec --workspace-folder . claude'                # Claude Code (sandboxed)
  alias dcp='devcontainer exec --workspace-folder . github-copilot-cli'   # GitHub Copilot CLI (sandboxed)
  alias dcd='docker stop $(docker ps -q --filter label=devcontainer.local_folder=$(pwd))'  # Stop container

  # Wrapper for npm to prevent accidental host usage
  npm() {
    if [[ "$1" == "-v" || "$1" == "--version" ]] && [[ $# -eq 1 ]]; then
      command npm "$@"
      return
    fi

    if [[ -d ".devcontainer" ]] && [[ "$1" != "install" || ! "$*" =~ "-g" ]]; then
      echo "⚠️  Warning: You're using npm on the host system."
      echo "💡 Consider using: dce npm $*"
      echo ""
      read -q "REPLY?Continue with host npm? (y/n) "
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return 1
      fi
    fi

    command npm "$@"
  }

  # Wrapper for pnpm to prevent accidental host usage
  pnpm() {
    if [[ "$1" == "-v" || "$1" == "--version" ]] && [[ $# -eq 1 ]]; then
      command pnpm "$@" 2>/dev/null || echo "pnpm not installed on host (use in devcontainer)"
      return
    fi

    if [[ -d ".devcontainer" ]]; then
      echo "⚠️  Warning: pnpm is not available on host (by design)."
      echo "💡 Use: dce pnpm $*"
      return 1
    fi

    command pnpm "$@" 2>/dev/null || echo "pnpm not installed on host (use in devcontainer)"
  }

  # Wrapper for claude to prevent accidental host usage (security: AI should run sandboxed)
  claude() {
    if [[ "$1" == "--version" ]] && [[ $# -eq 1 ]]; then
      command claude "$@"
      return
    fi

    if [[ -d ".devcontainer" ]]; then
      echo "⚠️  Warning: Claude Code should run in the sandboxed devcontainer for security."
      echo "💡 Use: dcc $*"
      echo ""
      read -q "REPLY?Continue with host Claude? (y/n) "
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return 1
      fi
    fi

    command claude "$@"
  }
}
