# Development Environment Bootstrap

This bootstrap script installs all dependencies required for the `.zshrc` configuration.

## Quick Start

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

## What Gets Installed

### Package Managers
- **Homebrew** - Package manager for macOS/Linux

### Shell Enhancements
- **oh-my-posh** - Shell prompt customization
- **zsh-autosuggestions** - Fish-like autosuggestions for zsh
- **fzf** - Fuzzy finder for command-line

### Development Tools
- **Git** - Version control
- **pyenv** - Python version management
- **nvm** - Node.js version management
- **Visual Studio Code** - Code editor

### Kubernetes Tools
- **kubectl** - Kubernetes CLI
- **kubecolor** - Colorized kubectl output

### Cloud & Infrastructure
- **AWS CLI** - Amazon Web Services CLI
- **Terraform** - Infrastructure as Code

### Utilities
- **eza** - Modern replacement for `ls`
- **tree** - Directory tree viewer

## Manual Steps After Installation

### 1. Copy Your .zshrc
```bash
cp /path/to/your/.zshrc ~/.zshrc
source ~/.zshrc
```

### 2. Set Up oh-my-posh Theme
Replace the default theme with your custom one:
```bash
# Copy your custom theme
cp /path/to/kushal.omp.json ~/.oh-my-posh/themes/kushal.omp.json
```

### 3. Configure AWS SSO (if needed)
```bash
aws configure sso
# Follow the prompts to set up your AWS SSO profiles
```

### 4. Configure Kubernetes Contexts
```bash
# Add your kubeconfig
kubectl config use-context <your-context>
```

### 5. Install Python Version
```bash
# Install your preferred Python version
pyenv install 3.12.0
pyenv global 3.12.0
```

### 6. Install Node.js Version
```bash
# Install your preferred Node version
nvm install 20
nvm use 20
```

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
If Homebrew installation fails, make sure you have the prerequisites:
```bash
sudo apt-get install build-essential procps curl file git
```

### zsh-autosuggestions Not Working
Make sure the Homebrew path is correct in your .zshrc. The script uses:
```bash
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
```

### VS Code 'code' Command Not Available
On macOS, open VS Code and run:
- Press `Cmd+Shift+P`
- Type "Shell Command: Install 'code' command in PATH"
- Press Enter

## Directory Structure Created

```
~/
├── .pyenv/                 # Python version manager
├── .nvm/                   # Node version manager
├── .oh-my-posh/           
│   └── themes/
│       └── kushal.omp.json # Custom theme
├── .local/
│   └── bin/               # Local binaries
├── repos/                 # Projects directory (for oprj function)
└── .zshrc                 # Your shell configuration
```

## Customization

### Adding More Tools
Edit `bootstrap.sh` and add:
```bash
brew install <package-name>
```

### Oh-My-Posh Themes
Browse available themes at: https://ohmyposh.dev/docs/themes

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

## Support

For issues with specific tools:
- Homebrew: https://docs.brew.sh/
- pyenv: https://github.com/pyenv/pyenv
- nvm: https://github.com/nvm-sh/nvm
- oh-my-posh: https://ohmyposh.dev/
