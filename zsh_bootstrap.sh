#!/usr/bin/env bash

echo "Starting bootstrap installation..."

OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo "📱 Detected OS: $MACHINE"

# Install Homebrew (if on macOS or Linux)
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    if [[ "$MACHINE" == "Mac" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    elif [[ "$MACHINE" == "Linux" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add Homebrew to PATH for Linux
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed"
fi

echo "Updating Homebrew..."
brew update

echo "Installing core packages..."

brew install git
brew install fzf
brew install eza
brew install tree
brew install kubecolor
brew install kubectl
brew install terraform
brew install awscli
brew install jandedobbeleer/oh-my-posh/oh-my-posh
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

echo "Installing pyenv..."
if [[ ! -d "$HOME/.pyenv" ]]; then
    brew install pyenv
    
    # Install Python build dependencies (especially important on Linux)
    if [[ "$MACHINE" == "Mac" ]]; then
        brew install openssl readline sqlite3 xz zlib
    elif [[ "$MACHINE" == "Linux" ]]; then
        echo "Note: You may need to install Python build dependencies manually on Linux"
        echo "For Ubuntu/Debian: sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"
    fi
else
    echo "pyenv already installed"
fi

# Install nvm (Node Version Manager)
echo "Installing nvm..."
if [[ ! -d "$HOME/.nvm" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    
    # Load nvm for this script
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    echo "nvm already installed"
fi

# Install VS Code (if not already installed)
echo "Installing Visual Studio Code..."
if ! command -v code &> /dev/null; then
    if [[ "$MACHINE" == "Mac" ]]; then
        brew install --cask visual-studio-code
    elif [[ "$MACHINE" == "Linux" ]]; then
        brew install --cask visual-studio-code || echo "⚠️  VS Code installation via brew failed. Install manually from https://code.visualstudio.com/"
    fi
else
    echo "VS Code already installed"
fi

# Create oh-my-posh themes directory
echo "Setting up oh-my-posh theme directory..."
mkdir -p "$HOME/.oh-my-posh/themes"

# Download a default oh-my-posh theme (you'll need to add your custom kushal.omp.json)
DEST="$HOME/.oh-my-posh/themes/kushal.omp.json"

[ -f "$DEST" ] || \
curl -sL https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/kushal.omp.json -o "$DEST"

# Create local bin directory
mkdir -p "$HOME/.local/bin"

# Install a default Python version with pyenv
echo "Installing Python 3.11 via pyenv..."
if command -v pyenv &> /dev/null; then
    if ! pyenv versions | grep -q "3.11"; then
        pyenv install 3.11
        pyenv global 3.11
    else
        echo "Python 3.11 already installed"
    fi
fi

# Install a default Node version with nvm
echo "Installing Node LTS via nvm..."
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
    echo "Node LTS installed"
fi

# Setup zsh as default shell (if not already)
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "Setting zsh as default shell..."
    if [[ "$MACHINE" == "Mac" ]]; then
        chsh -s "$(which zsh)"
    elif [[ "$MACHINE" == "Linux" ]]; then
        sudo chsh -s "$(which zsh)" "$USER" || echo "⚠️  Could not set zsh as default. Run manually: chsh -s \$(which zsh)"
    fi
else
    echo "zsh is already the default shell"
fi

# Install Caskaydia Cove Nerd Font
echo "Installing Caskaydia Cove Nerd Font..."
brew install --cask font-caskaydia-cove-nerd-font

# Create repos directory for oprj/oprjt functions
mkdir -p "$HOME/repos"

# AWS SSO setup reminder
echo ""
echo "Post-installation notes:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Configure terminal to use nerd font: cmd+, > profiles > text > Font > CaskaydiaCove Nerd Font Mono SemiBold 12"
echo "2. Configure AWS CLI with 'aws configure sso' if you use AWS"
echo "3. Configure kubectl contexts for Kubernetes access"
echo "4. Copy your .zshrc to ~/.zshrc (if not already done)"
echo "5. Restart your terminal or run: source ~/.zshrc"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Bootstrap installation complete!"
echo "Your development environment is ready!"

