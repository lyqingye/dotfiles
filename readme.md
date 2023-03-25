### 安装linux
```shell
# 调整时间
timedatectl set-ntp true 
timedatectl status

# 更换源
vim /etc/pacman.d/mirrorlist
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch

# 分区btrfs
cfdisk /dev/{你的磁盘}
mkfs.fat -F 32 /dev/{引导分区}
mkfs.btrfs -m single -L btrfs-arch /dev/{root分区}

# 挂载
mount /dev/{root分区} /mnt
mount --mkdir /dev/{引导分区} /mnt/boot

# 创建子卷
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var

# 挂载子卷
umount /mnt
mount -o noatime,nodiratime,subvol=@ /dev/{系统分区} /mnt
mount --mkdir -o noatime,nodiratime,subvol=@home /dev/{系统分区} /mnt/home
mount --mkdir -o noatime,nodiratime,subvol=@var /dev/{系统分区} /mnt/var

# 开始安装基本的操作系统
pacstrap -i /mnt base base-devel linux linux-firmware snapper

# 一些基础包
pacstrap -i /mnt networkmanager sddm neovim zsh git make 
systemctl enable NetworkManager # 网络管理器
systemctl enable sddm # 登陆会话

# 生成grub
genfstab -U /mnt > /mnt/etc/fstab

# 切换到新安装的系统
arch-chroot /mnt

# 设置时区
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

# 设置地区及语言
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# 主机名
echo "archlinux" > /etc/hostname

# 编辑hosts
nvim /etc/hosts

127.0.0.1       localhost
::1             localhost
127.0.1.1       archlinux

# 修改root密码
passwd root

# 安装微码
pacman -S amd-ucode # AMD

# 创建引导
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=archlinux

# 修改引导日志级别
nvim /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT 改为5

grub-mkconfig -o /boot/grub/grub.cfg

# 加载btrfs
nvim /etc/mkinitcpio.conf
添加 btrfs 到 MODULES=(...)行
找到 HOOKS=(...)行，更换fsck为btrfs
最终你看到的/etc/mkinitcpio.conf文件格式为
MODULES=(btrfs)
HOOKS=(base udev autodetect modconf block filesystems keyboard btrfs)
mkinitcpio -p linux

# 生成引导配置
grub-mkconfig -o /boot/grub/grub.cfg

# 创建新用户
useradd -m  -G wheel -s /bin/zsh USERNAME
passwd USERNAME

# sudo权限
nvim /etc/sudoers
找到如下这样的一行，把前面的注释符号 # 去掉：
sudoers
#%wheel ALL=(ALL:ALL) ALL

# 开启32位库
nvim /etc/pacman.conf
去掉 [multilib] 一节中两行的注释，来开启 32 位库支持

# 更新系统
pacman -Syyu

# 安装基本桌面软件
pacman -S plasma-meta konsole dolphin

# 重启
exit
reboot
```

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
- openssh ssh工具
- ouch 解压缩命令行
- fzf 模糊搜索工具
```shell
pacman -S zsh neovim git make neofetch htop kwalletmanager unzip xclip aria2 proxychains-ng docker wget partitionmanager ntfs-3g jq snap-pac grub-btrfs pavucontrol alsa-utils lazygit playerctl ripgrep inotify-tools openssh ouch fzf sof-firmware alsa-firmware alsa-ucm-conf adobe-source-han-serif-cn-fonts wqy-zenhei noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ark packagekit-qt5 packagekit appstream-qt appstream gwenview kate fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-zhwiki fcitx5-material-color
systemctl enable docker
systemctl start docker
systemctl enable sshd
# 注销后生效
sudo usermod -a -G docker lyqingye

/etc/environment
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
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

# gvm
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source /home/lyqingye/.gvm/scripts/gvm
go install go1.20
```

### 安装包管理器
https://github.com/Morganamilo/paru
```shell
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# 安装常用软件
paru -S google-chrome wezterm feishu-bin netease-cloud-music graftcp visual-studio-code-bin fcitx5-pinyin-moegirl
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

# 配置终端 alacritty
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

```

### vim
```shell
#uninstall lunarvim
bash ~/.local/share/lunarvim/lvim/utils/installer/uninstall.sh

# uninstall old vim configs
rm -rf ~/.config/nvim 
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim 

# install lazyvim
git clone https://github.com/LazyVim/starter ~/.config/nvim

# custom config
nvim  ~/.config/nvim/lua/plugins/custom.lua

return {
  { "navarasu/onedark.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    opts = {
      close_if_last_window = true,
      window = {
        mappings = {
          ["<space>"] = "none",
          ["o"] = "open",
        },
      },
    },
  },
}

```

### 用于替换unix命令
```shell
pacman -S zellij lsd bat hexyl skim fd dust xh zoxide duf

nvim ~/.zshrc
eval "$(zoxide init zsh)"
# 其它命令就不重命名了，以免影响其它脚本
alias ls=lsd
alias hex=hexyl
alias proxy=proxychains
alias decompress=ouch
alias cd=zoxide
alias df=duf
alias hs='print -z $(cat ~/.zsh_history | fzf | tr ";" "\n" | tail -n 1)'
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

# 第一次使用快照回滚需要输入
snapper --ambit classic rollback
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

### 终端复用工具
cargo install --locked zellij
mkdir ~/.config/zellij
zellij setup --dump-config > ~/.config/zellij/config.kdl

# 自动加载
echo 'eval "$(zellij setup --generate-auto-start zsh)"' >> ~/.zshrc

# 修改配置
nvim ~/.config/zellij/config.kdl

keybinds {
    // 新增
    unbind "Ctrl o"
// 注释
session {
    //bind "Ctrl o" { SwitchToMode "Normal"; }
    //bind "Ctrl s" { SwitchToMode "Scroll"; }
    //bind "d" { Detach; }
}

```

### dotfiles
```shell
ssh-keygen 
cat ~/.ssh/id_rsa.pub 
# add to your key to github profile

sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply lyqingye
sudo mv ./build/chezmoi /usr/local/bin/
chezmoi update
```

