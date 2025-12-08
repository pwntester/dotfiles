# Devcontainer Setup
Command-line devcontainer workflow for neovim users.

## Prerequisites

- Docker installed and running
- Node.js (for devcontainer CLI)
- `@devcontainers/cli` installed globally (already done)

## Quick Start

### 1. Initialize a devcontainer in your project

```bash
cd your-project
dc-init
```

This will create a `.devcontainer/` directory with configuration files.

### 2. Start the devcontainer

```bash
dcu
```

The container will build and start in the background.

### 3. Open neovim in the container

```bash
dc-nvim .
# or just
nv .
```

This automatically detects if a devcontainer is running and uses it.

## Available Commands

This setup uses the official `@devcontainers/cli` with convenient aliases. All commands should be run from your project directory (where `.devcontainer/` exists):

### Main Commands

- **`dc`** - Main devcontainer CLI (alias for `devcontainer`)
- **`dci`** - Initialize devcontainer config from template
- **`dcu`** - Start the devcontainer (`devcontainer up --workspace-folder .`)
- **`dcd`** - Stop the devcontainer
- **`dcr`** - Rebuild container (use after config changes)
- **`dce <cmd>`** - Execute command in container (`devcontainer exec --workspace-folder . <cmd>`)
- **`dcs`** - Open interactive bash shell in container
- **`dcn [file]`** or **`nv [file]`** - Smart neovim launcher (uses container if running, host otherwise)

### Advanced Usage

Since `dc` is an alias for `devcontainer`, you have access to all devcontainer CLI features:

```bash
# View all available commands
dc --help

# Read container configuration
dc read-configuration

# Run with specific options
dc up --workspace-folder . --remove-existing-container --log-level debug
```

## Templates

### Node.js/TypeScript

Location: `~/dotfiles/devcontainer/.config/devcontainer/templates/nodejs-typescript/`

Includes:
- Node.js LTS
- pnpm, yarn, npm
- neovim with your host config mounted (`~/dotfiles/nvim/.config/nvim`)
- ripgrep, fd
- eslint, prettier
- git, GitHub CLI
- SSH key mounting
- Shell history persistence
- Neovim plugins persist across container rebuilds (Docker volumes)

## How It Works

### Smart Neovim Launcher (`dc-nvim`)

The `nv` command intelligently detects your environment:

1. If no `.devcontainer/` exists → uses host neovim
2. If `.devcontainer/` exists but container not running → asks if you want to use host
3. If container is running → executes neovim inside container

Files are mounted at `/workspaces/<project-name>` inside the container.

### Claude Code Integration

Claude Code runs on your host machine and operates on the workspace directory. Since the directory is mounted into the container, changes from Claude Code are immediately visible to neovim running in the container.

This gives you:
- ✅ Claude Code with full host capabilities (git, tools, etc.)
- ✅ Neovim with container's language servers and dependencies
- ✅ Seamless file synchronization

## Workflow Example

```bash
# Create new project
mkdir my-app && cd my-app
git init

# Initialize devcontainer
dci  # Select Node.js/TypeScript template

# Start container
dcu

# Open neovim in container
nv .

# In another terminal: use Claude Code on host
claude

# Execute commands in container if needed
dce pnpm test

# Stop when done
dcd
```

## Git Worktrees Integration

Devcontainers work seamlessly with git worktrees. Each worktree can have its own isolated container while sharing the devcontainer configuration.

### Recommended Approach

**One container per worktree** - Each worktree gets its own container, sharing the `.devcontainer` config from the main repo.

```
main-repo/
  .devcontainer/          ← Single source of truth

worktree-feature-a/
  .devcontainer -> ../main-repo/.devcontainer  ← Symlink

worktree-feature-b/
  .devcontainer -> ../main-repo/.devcontainer  ← Symlink
```

**Benefits:**
- ✅ Isolated environments per worktree
- ✅ Run multiple worktrees simultaneously
- ✅ Share devcontainer config (DRY)
- ✅ Share neovim plugin volumes (efficient)

### Worktrunk Integration

If using [worktrunk](https://github.com/max-sixty/worktrunk) for worktree management, you can automate the setup with hooks.

Create `.config/wt.toml` in your project root:

```toml
# Worktrunk configuration for devcontainer integration

[post-create]
# Symlink .devcontainer from main repo to new worktree
"setup-devcontainer" = """
MAIN_REPO=$(git rev-parse --path-format=absolute --git-common-dir | sed 's|/.git||')
if [ -d "$MAIN_REPO/.devcontainer" ]; then
  ln -sf "$MAIN_REPO/.devcontainer" .devcontainer
  echo "✅ Devcontainer config linked from main repo"
else
  echo "⚠️  No .devcontainer found in $MAIN_REPO"
fi
"""

[post-start]
# Start devcontainer in background (optional - remove for manual start)
"start-devcontainer" = """
if [ -d ".devcontainer" ]; then
  echo "🚀 Starting devcontainer in background..."
  devcontainer up --workspace-folder . > /tmp/devcontainer-$(basename $(pwd)).log 2>&1 &
  echo "📝 Logs: /tmp/devcontainer-$(basename $(pwd)).log"
  echo "💡 Run 'nv .' when container is ready (check with 'docker ps')"
else
  echo "⚠️  No .devcontainer config found"
fi
"""
```

### Usage with Worktrunk

```bash
# Create new worktree - devcontainer setup happens automatically
wt feature-auth

# Wait ~30-60s for container to build (first time)
cd feature-auth

# Check container status
docker ps | grep feature-auth

# Start coding
nv .
```

**What happens automatically:**
1. Worktree created
2. `.devcontainer` symlinked from main repo
3. Container starts building in background (if `post-start` enabled)
4. Ready to code when build completes

### Manual Worktree Setup

Without worktrunk, manually create symlinks:

```bash
# Create worktree
git worktree add ../my-feature

# Link devcontainer config
cd ../my-feature
ln -s ../main-repo/.devcontainer .devcontainer

# Start container
dcu

# Start coding
nv .
```

### Resource Management

Each worktree container shares:
- Container images (efficient)
- Neovim plugin volumes (`devcontainer-nvim-data`)
- Only workspace directory is unique

**Typical resource usage:**
- 3 active worktrees = 3 containers (~1-2GB RAM each)

**Stop unused containers:**
```bash
cd unused-worktree
dcd
```

**Or stop all devcontainers:**
```bash
docker ps --filter "label=devcontainer.local_folder" -q | xargs docker stop
```

## Customizing Templates

Templates are in `~/dotfiles/devcontainer/.config/devcontainer/templates/`.

Each template contains:
- `.devcontainer/devcontainer.json` - Main configuration
- `.devcontainer/postCreate.sh` - Setup script run after container creation

To create a new template:

1. Create directory: `templates/my-template/.devcontainer/`
2. Add `devcontainer.json` and optionally `postCreate.sh`
3. Update `dc-init` script to include your template

## Configuration Tips

### Forward Environment Variables

Edit `.devcontainer/devcontainer.json`:

```json
{
  "remoteEnv": {
    "MY_VAR": "${localEnv:MY_VAR}"
  }
}
```

### Add More Features

See available features: https://containers.dev/features

```json
{
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  }
}
```

### Mount Additional Directories

```json
{
  "mounts": [
    "source=/host/path,target=/container/path,type=bind,consistency=cached"
  ]
}
```

## Neovim Configuration

Your neovim config from `~/dotfiles/nvim/.config/nvim` is automatically mounted into the container. This means:

- **Config changes sync immediately** - Edit your config on the host, see changes in the container
- **Plugins persist** - Lazy.nvim plugins are stored in Docker volumes and persist across container rebuilds
- **First startup is slower** - Plugins install on first container creation (via `postCreate.sh`)
- **Subsequent startups are fast** - Plugins are cached in the volume

Plugin storage locations:
- Config (mounted): `/home/node/.config/nvim` ← `~/dotfiles/nvim/.config/nvim`
- Data (volume): `/home/node/.local/share/nvim` (lazy.nvim plugins)
- State (volume): `/home/node/.local/state/nvim` (shada, undo history)

## Troubleshooting

### Container won't start
```bash
# Check Docker is running
docker ps

# Rebuild from scratch
dcr
```

### Plugins not installing
```bash
# Manually sync plugins from inside container
dcs
nvim --headless "+Lazy! sync" +qa
```

### Want to use a different neovim config
Edit `.devcontainer/devcontainer.json` and change the mount path:

```json
{
  "mounts": [
    "source=${localEnv:HOME}/path/to/your/nvim,target=/home/node/.config/nvim,type=bind,consistency=cached"
  ]
}
```

### Changes not reflecting
Ensure the workspace is mounted. Check `docker inspect <container-id>` for mounts.

## Resources

- [Development Containers Spec](https://containers.dev/)
- [devcontainer CLI Docs](https://github.com/devcontainers/cli)
- [Available Features](https://containers.dev/features)
- [VS Code Devcontainer Docs](https://code.visualstudio.com/docs/devcontainers/containers) (concepts apply to CLI usage)
