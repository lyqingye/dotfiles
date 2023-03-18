

### 基本包
```shell
pacman -S zsh neovim git make neofetch htop kdwalletmanager unzip xlip aria2 proxychains-ng docker
systemctl enable docker
systemctl start docker
# 注销后生效
sudo usermo -a -G docker lyqingye

```

### 安装rust
```shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 切换源
nvim $HOME/.cargo/config

[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"

# 设置cargo/bin到环境变量
export PATH="$HOME/.cargo/bin:$PATH"
```

### 安装go
```shell
export GO_VERSION=1.18
aria2c "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
rm -rf "go${GO_VERSION}.linux-amd64.tar.gz"
# ~/.zshrc
export PATH=$PATH:/usr/local/go/bin
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
export GOPRIVATE=github.com/marginxio/*
```

### 安装包管理器
https://github.com/Morganamilo/paru
```shell
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# 安装常用软件
paru -S google-chrome wezterm feishu-bin netease-cloud-music graftcp
# 启动golang代理程序服务
systemctl enable graftcp-local
```

### 终端相关

```shell
# 安装字体
aria2c https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.2/Hack.zip
mkdir -p ~/.local/share/fonts/
unzip Hack.zip -d ~/.local/share/fonts/
rm -rf Hack.zip
fc-cache

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装starship
curl -sS https://starship.rs/install.sh | sh

# 修改 ~/.zshrc
eval "$(starship init zsh)"

# zsh插件管理器
curl -L git.io/antigen > antigen.zsh
# 修改 ~/.zshrc
source "$HOME/antigen.zsh"
antigen bundle git
antigen bundle pip
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen apply

# 配置终端 wezterm
mkdir -p $HOME/.config/wezterm
touch $HOME/.config/wezterm/wezterm.lua
nvim $HOME/.config/wezterm/wezterm.lua

```

### vim
```shell
```

### 用于替换unix命令
```shell
pacman -S zellij lsd bat hexyl skim fd dust xh

nvim ~/.zshrc

# 其它命令就不重命名了，以免影响其它脚本
alias ls=lsd
alias hex=hexyl
alias proxy=proxychains
```

### node 包管理器
```shell
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "./.fnm" --skip-shell
source ~/.zshrc
fnm list-remote
fnm install ${version}
```
