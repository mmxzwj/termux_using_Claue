#!/bin/bash

version="Ver2.9.6"
clewd_version="$(grep '"version"' "clewd/package.json" | awk -F '"' '{print $4}')($(grep "Main = 'clewd修改版 v'" "clewd/lib/clewd-utils.js" | awk -F'[()]' '{print $3}'))"
st_version=$(grep '"version"' "SillyTavern/package.json" | awk -F '"' '{print $4}')
echo "hoping：卡在这里了？...说明有小猫没开魔法喵~"
latest_version=$(curl -s https://raw.githubusercontent.com/hopingmiao/termux_using_Claue/main/VERSION)
clewd_latestversion=$(curl -s https://raw.githubusercontent.com/teralomaniac/clewd/test/package.json | grep '"version"' | awk -F '"' '{print $4}')
clewd_subversion=$(curl -s https://raw.githubusercontent.com/teralomaniac/clewd/test/lib/clewd-utils.js | grep "Main = 'clewd修改版 v'" | awk -F'[()]' '{print $3}')
clewd_latest="$clewd_latestversion($clewd_subversion)"
st_latest=$(curl -s https://raw.githubusercontent.com/SillyTavern/SillyTavern/release/package.json | grep '"version"' | awk -F '"' '{print $4}')
 saclinkemoji=$(curl -s https://raw.githubusercontent.com/hopingmiao/termux_using_Claue/main/secret_saclink | awk -F '|' '{print $3 }')
# hopingmiao=hotmiao
#

# ANSI Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 检查是否存在git指令
if command -v git &> /dev/null; then
    echo "git指令存在"
    git --version
else
    echo "git指令不存在，建议回termux下载git喵~"
fi

# 检查是否存在node指令
if command -v node &> /dev/null; then
    echo "node指令存在"
    node --version
else
    echo "node指令不存在，正在尝试重新下载喵~"
    curl -O https://nodejs.org/dist/v20.10.0/node-v22.14.0-linux-arm64.tar.xz
    tar xf node-v22.14.0-linux-arm64.tar.xz
    echo "export PATH=\$PATH:/root/node-v22.14.0-linux-arm64/bin" >>/etc/profile
    source /etc/profile
    if command -v node &> /dev/null; then
        echo "node成功下载"
        node --version                                                
    else
        echo "node下载失败，╮(︶﹏︶)╭，自己尝试手动下载吧"
        exit 1

  fi
fi

#添加termux上的Ubuntu/root软链接
if [ ! -d "/data/data/com.termux/files/home/root" ]; then
    ln -s /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu/root /data/data/com.termux/files/home
fi

echo "root软链接已添加，可直接在mt管理器打开root文件夹修改文件"

if [ ! -d "SillyTavern" ]; then
    echo "SillyTavern不存在，正在通过git下载..."
    git clone https://github.com/SillyTavern/SillyTavern SillyTavern
    cd /root
fi

if [ ! -d "clewd" ]; then
	echo "clewd不存在，正在通过git下载..."
	git clone -b test https://github.com/teralomaniac/clewd
	cd clewd
	bash start.sh
        cd /root
elif [ ! -f "clewd/config.js" ]; then
    cd clewd
    bash start.sh
    cd /root
fi

if [ ! -d "SillyTavern" ]; then
	echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因网络波动文件下载失败了，更换网络后再试喵~\n\033[0m"
	exit 2
fi

if  [ ! -d "clewd" ] || [ ! -f "clewd/config.js" ]; then
	echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因网络波动文件下载失败了，更换网络后再试喵~\n\033[0m"
  	rm -rf clewd
	exit 3
fi

function clewdSettings { 
    # 3. Clewd设置
    if grep -q '"sactag"' "clewd/config.js"; then
        sactag_value=$(grep '"sactag"' "clewd/config.js" | sed -E 's/.*"sactag": *"([^"]+)".*/\1/')
    else
        sactag_value="默认"
    fi
    clewd_dir=clewd
    echo -e "\033[0;36mhoping：选一个执行喵~\033[0m
\033[0;33m当前:\033[0m$clewd_version \033[0;33m最新:\033[0m\033[5;36m$clewd_latest\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;33m选项1 查看 config.js 配置文件\033[0m
\033[0;33m选项3 添加 Cookies\033[0m
\033[0;37m选项6 修改 Cookiecounter\033[0m
\033[0;33m选项9 修改 PassParams状态\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;31m选项0 更新 clewd\033[0m
\033[0;33m--------------------------------------\033[0m
"
    read -n 1 option
    echo
    case $option in 
        0)
            cd /root/clewd
            echo -e "\033[0;33m正在更新clewd，请稍等...\033[0m"
            git pull
            echo -e "\033[0;32mclewd更新完成喵~\033[0m"
            cd /root
            clewd_version="$(grep '"version"' "clewd/package.json" | awk -F '"' '{print $4}')($(grep "Main = 'clewd修改版 v'" "clewd/lib/clewd-utils.js" | awk -F'[()]' '{print $3}'))"
            ;;
        1) 
            # 查看 config.js
            cat $clewd_dir/config.js
            ;;
        3) 
            # 添加 Cookies
            echo "hoping：请输入你的cookie文本喵~(回车进行保存，如果全部输入完后按一次ctrl+D即可退出输入):"
            while IFS= read -r line; do
                cookies=$(echo "$line" | grep -E -o '"?sessionKey=[^"]{100,120}AA"?' | tr -d "\"'")
                echo "$cookies"
                if [ -n "$cookies" ]; then
                    echo -e "喵喵猜你的cookies是:\n"
                    echo "$cookies"
                    # Format cookies, one per line with quotes
                    cookies=$(echo "$cookies" | tr ' ' '\n' | sed -e 's/^/"/; s/$/"/g')
                    # Join into array
                    cookie_array=$(echo "$cookies" | tr '\n' ',' | sed 's/,$//')
                    # Update config.js
                    sed -i "/\"CookieArray\"/s/\[/\[$cookie_array\,/" ./$clewd_dir/config.js
                    echo "Cookies成功被添加到config.js文件了喵~"
                else
                    echo "没有找到cookie喵~o(╥﹏╥)o，要不检查一下cookie是不是输错了吧？(如果要退出输入请按Ctrl+D)"
                fi
            done
            echo "cookies成功输入了(*^▽^*)"
            ;;
        6)  
            # 修改 Cookiecounter
            echo "切换Cookie的频率, 默认为3(每3次切换), 改为-1进入测试Cookie模式"
            read -p "是否要修改Cookiecounter?(y/n)" choice
            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入Cookiecounter
                read -p "请输入需要设置的数值:" cookiecounter

                # 更新配置文件的Cookiecounter
                sed -i 's/"Cookiecounter": .*,/"Cookiecounter": '$cookiecounter',/g' $clewd_dir/config.js
                echo "Cookiecounter已修改为$cookiecounter"
            else
                echo "未修改Cookiecounter"
            fi
            ;;
        9)
            PassParams_value=$(grep -oP '"PassParams": \K[^,]*' clewd/config.js)
            echo -e "当前PassParams值为\033[0;33m $PassParams_value \033[0m喵~"
            read -p "是否进行更改[y/n]" PassParams_choice
            if [ $PassParams_choice == "Y" ] || [ $PassParams_choice == "y" ]; then
                if [ $PassParams_value == 'false' ];
    then
                    #将false替换为true
                    sed -i 's/"PassParams": false,/"PassParams": true,/g' $clewd_dir/config.js
                    echo -e "hoping：'PassParams'已经被修改成\033[0;33m true \033[0m喵~."
                elif [ $PassParams_value == 'true' ];
    then
                    #将true替换为false
                    sed -i 's/"PassParams": true,/"PassParams": false,/g' $clewd_dir/config.js
                    echo -e "hoping：'PassParams'值已经被修改成\033[0;33m false \033[0m喵~."
                else
                    echo -e "呜呜X﹏X\nhoping喵未能找到'PassParams'."
                fi
            else
                echo "未进行修改喵~"
            fi
            ;;
        *)
            echo "什么都没有执行喵~"
            ;;
    esac
}

function sillyTavernSettings {
    # 4. SillyTavern设置
	echo -e "\033[0;36mhoping：选一个执行喵~\033[0m
\033[0;33m当前版本:\033[0m$st_version \033[0;33m最新版本:\033[0m\033[5;36m$st_latest\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;33m选项3 修改 酒馆端口\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;31m选项0 更新酒馆\033[0m
\033[0;33m--------------------------------------\033[0m
"
    read -n 1 option
    echo
    case $option in 
        0)
            cd /root/SillyTavern
            echo -e "\033[0;33m正在更新酒馆，请稍等...\033[0m"
            git pull
            echo -e "\033[0;32m酒馆更新完成喵~\033[0m"
            cd /root
            st_version=$(grep '"version"' "SillyTavern/package.json" | awk -F '"' '{print $4}')
            ;;
		3)
			if [ ! -f "SillyTavern/config.yaml" ]; then
				echo -e "当前酒馆版本过低，请更新酒馆版本后重试"
				exit
			fi
            read -p "是否要修改开放端口?(y/n)" choice

            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入的端口号
                read -p "请输入开放的端口号:" custom_port
                # 更新配置文件的端口号
                sed -i 's/port: [0-9]*/port: '$custom_port'/g' SillyTavern/config.yaml
                echo "端口已修改为$custom_port"
            else
                echo "未修改端口号"
            fi
            ;;
        *)
            echo "什么都没有执行喵~"
            ;;
    esac
}

# 主菜单
echo -e "                                              
喵喵一键脚本-江南精简版
作者：hoping喵(懒喵~)，水秋喵(苦等hoping喵起床)
版本：酒馆:$st_version clewd:$clewd_version 脚本:$version
最新：\033[5;36m酒馆:$st_latest\033[0m \033[5;32mclewd:$clewd_latest\033[0m \033[0;33m脚本:$latest_version\033[0m
来自：Claude先行破限组
群号：704819371，910524479，304690608
类脑Discord(角色卡发布等): https://discord.gg/HWNkueX34q
此程序完全免费，不允许对脚本/教程进行盗用/商用。运行时需要稳定的魔法网络环境。"
while :
do 
    echo -e "\033[0;36mhoping喵~让你选一个执行（输入数字即可），懂了吗？\033[0;38m(｡ì _ í｡)\033[0m\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;31m选项0 退出脚本\033[0m
\033[0;33m选项1 启动Clewd\033[0m
\033[0;37m选项2 启动酒馆\033[0m
\033[0;33m选项3 Clewd设置\033[0m
\033[0;37m选项4 酒馆设置\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;31m选项6 更新脚本\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;35m不准选其他选项，听到了吗？
\033[0m\n(⇀‸↼‶)"
    read -n 1 option
    echo 
    case $option in 
        0) 
            break ;; 
        1) 
            #启动Clewd
            port=$(grep -oP '"Port":\s*\K\d+' clewd/config.js)
            echo "端口为$port, 出现 (x)Login in {邮箱} 代表启动成功, 后续出现AI无法应答等报错请检查本窗口喵。"
			ps -ef | grep clewd.js | awk '{print$2}' | xargs kill -9
            cd clewd
            bash start.sh
            echo "Clewd已关闭, 即将返回主菜单"
            cd ../
            ;; 
        2) 
            #启动SillyTavern
			ps -ef | grep server.js | awk '{print$2}' | xargs kill -9
            cd SillyTavern
            echo -e "\033[0;33m正在安装依赖，请稍等...\033[0m"
	        npm install
            echo -e "\033[0;32m依赖安装完成，正在启动酒馆...\033[0m"
	        npm start
            echo "酒馆已关闭, 即将返回主菜单"
            cd ../
            ;; 
        3) 
            #Clewd设置
            clewdSettings
            ;; 
        4) 
            #SillyTavern设置
            sillyTavernSettings
            ;; 
        6)
            # 更新脚本
            curl -O https://raw.githubusercontent.com/mmxzwj/termux_using_Claue/refs/heads/main/sac.sh
	    echo -e "重启终端或者输入bash sac.sh重新进入脚本喵~"
            break ;;
        *) 
            echo -e "m9( ｀д´ )!!!! \n\033[0;36m坏猫猫居然不听话，存心和我hoping喵~过不去是吧？\033[0m\n"
            ;;
    esac
done 
echo "已退出喵喵一键脚本，输入 bash sac.sh 可重新进入脚本喵~"
exit
