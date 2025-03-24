#!/bin/bash

# 基础系统更新和安装
yes | pkg update
yes | pkg upgrade
yes | pkg install git
yes | pkg install nodejs

echo "                                              
喵喵一键安卓脚本
作者: hoping喵，坏水秋
来自: Claude2.1先行破限组
群号: 704819371 / 910524479 / 304690608
类脑Discord: https://discord.gg/HWNkueX34q
"

echo -e "\033[0;31m开魔法！开魔法！开魔法！\033[0m\n"

read -p "确保开了魔法后按回车继续"

current=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu

yes | apt update

yes | apt upgrade

# 安装proot-distro
DEBIAN_FRONTEND=noninteractive pkg install proot-distro -y

# 创建并安装Ubuntu
DEBIAN_FRONTEND=noninteractive proot-distro install ubuntu

# Check Ubuntu installed successfully
 if [ ! -d "$current" ]; then
   echo "Ubuntu安装失败了，请更换魔法或者手动安装Ubuntu喵~"
    exit 1
 fi

    echo "Ubuntu成功安装到Termux"

echo "正在安装相应软件喵~"

DEBIAN_FRONTEND=noninteractive pkg install git vim curl tar xz-utils python3 zip -y

if [ -d "SillyTavern" ]; then
  cp -r SillyTavern $current/root/
fi

cd $current/root

echo "正在为Ubuntu安装node喵~"
if [ ! -d node-v22.14.0-linux-arm64.tar.xz ]; then
    curl -O https://nodejs.org/dist/v22.14.0/node-v22.14.0-linux-arm64.tar.xz

tar xf node-v22.14.0-linux-arm64.tar.xz

echo "export PATH=\$PATH:/root/node-v22.14.0-linux-arm64/bin" >>$current/etc/profile
fi

if [ ! -d "SillyTavern" ]; then
git clone https://github.com/SillyTavern/SillyTavern
fi

git clone -b test https://github.com/teralomaniac/clewd

curl -O https://raw.githubusercontent.com/mmxzwj/termux_using_Claue/refs/heads/main/sac.sh

if [ ! -f "$current/root/sac.sh" ]; then
   echo "启动文件下载失败了，换个魔法或者手动下载试试吧"
   exit
fi

echo "bash /root/sac.sh" >>$current/root/.bashrc

echo "proot-distro login ubuntu" >>/data/data/com.termux/files/home/.bashrc

source /data/data/com.termux/files/home/.bashrc

exit
