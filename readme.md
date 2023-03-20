

### 基本包
- zsh 
- neovim
- git
- make
- neofetch
- htop
- kdwalletmanager （用于管理密码）
- unzip  
- xclip (剪切板)
- aria2 (一个简单的下载工具)
- proxychains-ng (命令行走代理)
- docker
- wget
- partitionmanager (分区工具)
- ntfs-3g (用于访问ntfs)
- jq
- snap-pac (pacman 执行后自动创建快照)
- grub-btrfs (快照后自动生成grub启动项)
- inotify-tools (grub-btrfs依赖)
- pavucontrol (音频控制)
- alsa-utils (音频控制)
- playerctl (多媒体控制)
- lazygit (git-ui 命令行版)
- ripgrep (搜索工具)
```shell
pacman -S zsh neovim git make neofetch htop kdwalletmanager unzip xclip aria2 proxychains-ng docker wget partitionmanager ntfs-3g jq snap-pac grub-btrfs pavucontrol alsa-utils lazygit playerctl ripgrep inotify-tools
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
registry = "https://mirrors.ustc.edu.cn/crates.io-index/"

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
paru -S google-chrome wezterm feishu-bin netease-cloud-music graftcp visual-studio-code-bin
# 启动golang代理程序服务
systemctl enable graftcp-local

# 设置网易云音乐缩放
--force-device-scale-factor=1.4
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
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

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

# vim依赖这个
npm install -g prettier
```

### 定时快照备份
```shell
# 先开启snapper定时器
systemctl enable --now snapper-timeline.timer
systemctl enable --now snapper-cleanup.timer

sudo snapper -c root create-config /
sudo snapper -c home create-config /home

# 保存4份快照
NUMBER_LIMIT="4"
# 每周快照一次
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="0"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"

# 开启系统滚动更新前备份
# 自动检测快照并且加入到启动项
systemctl enable grub-btrfsd
```

### 美化 
#### eww安装
```shell
git clone https://github.com/elkowar/eww && cd eww  && cargo install cd .. && rm -rf eww
```

#### polybar
```shell
sudo pacman -S polybar
```

#### picom
```shell
# 多媒体以及合成器
sudo pacman -S picom mpd ncmpcpp
systemctl enable mpd
# 天气插件
paru -S weather
```

### 字体
```shell
https://aur.archlinux.org/packages/ttf-weather-icons
https://aur.archlinux.org/packages/ttf-material-icons-git

paur -S ttf-weather-icons ttf-material-icons-git
```