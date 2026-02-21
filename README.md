# Development Environment Bootstrap

This bootstrap script installs all dependencies required for the `.zshrc` configuration and sets up a clean development environment for macOS and Linux.

## Quick Start

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

## What Gets Installed

### Package Managers
- **Homebrew** - Package manager for macOS/Linux
- **pyenv** - Python version management
- **nvm** - Node.js version management
- **Miniconda** - Python environment manager (`conda`) installed under `$HOME/miniconda3`
- **pipx** - Isolated Python CLI tool manager

### Shell Enhancements
- **oh-my-posh** - Shell prompt customization
- **zsh-autosuggestions** - Fish-like autosuggestions for zsh
- **zsh-syntax-highlighting** - Syntax highlighting in zsh
- **fzf** - Fuzzy finder for command-line

### Development Tools
- **Git** - Version control
- **Visual Studio Code** - Code editor

### VS Code Configuration
- **VS Code Extension Pack** - Custom extension pack located in `swft-vscode/`
- **VS Code User Settings** - Preconfigured `vscode_settings.json` automatically applied to your local VS Code profile

### Kubernetes Tools
- **kubectl** - Kubernetes CLI
- **kubecolor** - Colorized kubectl output

### Cloud & Infrastructure
- **AWS CLI** - Amazon Web Services CLI
- **Terraform** - Infrastructure as Code

### Utilities
- **eza** - Modern replacement for `ls`
- **tree** - Directory tree viewer
- **Caskaydia Cove Nerd Font** - For terminal customization

### Python & Node CLI Tools
- **Poetry** - Python project and dependency manager (installed via `pipx`)
- **Black, Ruff, httpie** (optional) - Python CLI tools via `pipx`

---

## Directory Structure Created

```
~/
├── .pyenv/                 # Python version manager
├── .nvm/                   # Node version manager
├── miniconda3/             # Conda installation
├── .oh-my-posh/           
│   └── themes/
│       └── kushal.omp.json # Custom theme
├── .local/
│   └── bin/               # Local binaries
├── repos/                 # Projects directory (for oprj function)
└── .zshrc                 # Your shell configuration
```

---

## VS Code Setup Details

### Extension Pack

The bootstrap script installs a local VS Code extension pack by copying:

```
swft-vscode/ → ~/.vscode/extensions/
```

This ensures your preferred extensions are available immediately after installation.

### User Settings

The script:

1. Replaces any hardcoded `/Users/<name>/` paths with your current `$HOME`
2. Moves `vscode_settings.json` to:

**macOS:**
```
~/Library/Application Support/Code/User/settings.json
```

**Linux:**
```
~/.config/Code/User/settings.json
```

This applies your predefined editor configuration automatically.

---

## Manual Steps After Installation

### 1. Copy Your .zshrc
```bash
cp /path/to/your/.zshrc ~/.zshrc
source ~/.zshrc
```

### 2. Set Up oh-my-posh Theme
Replace the default theme with your custom one:
```bash
cp /path/to/kushal.omp.json ~/.oh-my-posh/themes/kushal.omp.json
```

### 3. Configure AWS SSO (if needed)
```bash
aws configure sso
# Follow the prompts to set up your AWS SSO profiles
```

### 4. Configure Kubernetes Contexts
```bash
kubectl config use-context <your-context>
```

### 5. Install Python Version
```bash
# Install your preferred Python version via pyenv
pyenv install 3.12.0
pyenv global 3.12.0
```

### 6. Install Node.js Version
```bash
nvm install 20
nvm use 20
```

### 7. Initialize Conda
```bash
# Disable auto-activation of base environment
conda config --set auto_activate_base false
```

### 8. Install Python CLI Tools via pipx
```bash
# Example: Poetry
pipx install poetry
pipx ensurepath
```

---

## Troubleshooting

### pyenv Build Issues (Linux)
If Python builds fail, install build dependencies:

**Ubuntu/Debian:**
```bash
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
libffi-dev liblzma-dev
```

**Fedora/CentOS/RHEL:**
```bash
sudo dnf install -y make gcc zlib-devel bzip2 bzip2-devel readline-devel \
sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
```

### Homebrew on Linux
If Homebrew installation fails, ensure prerequisites:
```bash
sudo apt-get install build-essential procps curl file git
```

### VS Code 'code' Command Not Available
On macOS:
- Open VS Code
- Press `Cmd+Shift+P`
- Type "Shell Command: Install 'code' command in PATH"
- Press Enter

---

## Features Enabled by .zshrc

### Kubernetes Aliases
- `k` - kubectl alias
- `kgp` - Get pods
- `kpl()` - Interactive pod log viewer
- `kdp()` - Interactive pod describer

### Git Aliases
- `s` - Git status
- `gc()` - Git commit with checks
- `gp` - Git push
- And many more...

### Utilities
- `oprj()` - Open project in VS Code
- `awssso()` - AWS SSO login helper
- History search with arrow keys

---

## Customization

### Adding More Tools
Edit `bootstrap.sh` and add:
```bash
brew install <package-name>
```
or for Python CLI tools:
```bash
pipx install <tool>
```

### Oh-My-Posh Themes
Browse available themes at: [oh-my-posh themes](https://ohmyposh.dev/docs/themes)

---

## Recommended Tool Ownership

| Tool        | Owner       | Notes |
|------------|------------|------|
| Homebrew   | System-level | Non-Python binaries and utilities |
| pyenv      | Python versions | Project Python management |
| pipx       | Python CLI tools | Isolated per tool, survives Python upgrades |
| Conda      | Python environments | Data science / ML isolation |
| Node/npm   | nvm        | Node.js version management |

---

## Support

For issues with specific tools:
- Homebrew: https://docs.brew.sh/
- pyenv: https://github.com/pyenv/pyenv
- nvm: https://github.com/nvm-sh/nvm
- pipx: https://pypa.github.io/pipx/
- Miniconda: https://docs.conda.io/en/latest/miniconda.html
- oh-my-posh: https://ohmyposh.dev/
