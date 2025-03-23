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
\033[0;33m当前:\033[0m$clewd_version \033[0;33m最新:\033[0m\033[5;36m$clewd_latest\033[0m \033[0;33mconfig.js:\033[5;37m$sactag_value
\033[0;33m--------------------------------------\033[0m
\033[0;33m选项1 查看 config.js 配置文件\033[0m
\033[0;37m选项2 使用 Vim 编辑 config.js\033[0m
\033[0;33m选项3 添加 Cookies\033[0m
\033[0;37m选项4 修改 Clewd 密码\033[0m
\033[0;33m选项5 修改 Clewd 端口\033[0m
\033[0;37m选项6 修改 Cookiecounter\033[0m
\033[0;33m选项7 修改 rProxy\033[0m
\033[0;37m选项8 修改 PreventImperson状态\033[0m
\033[0;33m选项9 修改 PassParams状态\033[0m
\033[0;37m选项a 修改 padtxt\033[0m
\033[0;33m选项b 切换 config.js配置\033[0m
\033[0;37m选项c 定义 clewd接入模型\033[0m
\033[0;33m选项d 修改 api_rProxy(第三方接口)\033[0m
\033[0;33m--------------------------------------\033[0m
\033[0;31m选项0 更新 clewd(test分支)\033[0m
\033[0;33m--------------------------------------\033[0m
"
    read -n 1 option
    echo
    case $option in 
        1) 
            # 查看 config.js
            cat $clewd_dir/config.js
            ;;
        2)
            # 使用 Vim 编辑 config.js
            vim $clewd_dir/config.js
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
        4) 
            # 修改 Clewd 密码
            read -p "是否修改密码?(y/n)" choice
            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入的新密码
                read -p "请输入新密码\n（不是你本地部署设密码干哈啊？）:" new_pass

                # 修改密码
                sed -i 's/"ProxyPassword": ".*",/"ProxyPassword": "'$new_pass'",/g' $clewd_dir/config.js

                echo "密码已修改为$new_pass"
            else
                echo "未修改密码"
            fi
            ;; 
        5) 
            # 修改 Clewd 端口
            read -p "是否要修改开放端口?(y/n)" choice
            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入的端口号
                read -p "请输入开放的端口号:" custom_port

                # 更新配置文件的端口号
                sed -i 's/"Port": [0-9]*/"Port": '$custom_port'/g' $clewd_dir/config.js
                echo "端口已修改为$custom_port"
            else
                echo "未修改端口号"
            fi
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
        7)  
            # 修改 rProxy
            echo -e "\n1. 官网地址claude.ai\n2. 国内镜像地址finechat.ai\n3. 自定义地址\n0. 不修改"
            read -p "输入选择喵：" choice
            case $choice in 
                1)  
                    sed -i 's/"rProxy": ".*",/"rProxy": "",/g' $clewd_dir/config.js
                    ;; 
                2) 
                    sed -i 's#"rProxy": ".*",#"rProxy": "https://chat.finechat.ai",#g' $clewd_dir/config.js
                    ;; 
                3)
                    # 读取用户输入rProxy
                    read -p "请输入需要设置的数值:" rProxy
                    # 更新配置文件的rProxy
                    sed -i 's#"rProxy": ".*",#"rProxy": "'$rProxy'",#g' $clewd_dir/config.js
                    echo "rProxy已修改为$rProxy"
                    ;; 
                *) 
                    echo "不修改喵~"
                    break ;; 
            esac
            ;;
        8)
            PreventImperson_value=$(grep -oP '"PreventImperson": \K[^,]*' clewd/config.js)
            echo -e "当前PreventImperson值为\033[0;33m $PreventImperson_value \033[0m喵~"
            read -p "是否进行更改[y/n]" PreventImperson_choice
            if [ $PreventImperson_choice == "Y" ] || [ $PreventImperson_choice == "y" ]; then
                if [ $PreventImperson_value == 'false' ];
    then
                    #将false替换为true
                    sed -i 's/"PreventImperson": false,/"PreventImperson": true,/g' $clewd_dir/config.js
                    echo -e "hoping：'PreventImperson'已经被修改成\033[0;33m true \033[0m喵~."
                elif [ $PreventImperson_value == 'true' ];
    then
                    #将true替换为false
                    sed -i 's/"PreventImperson": true,/"PreventImperson": false,/g' $clewd_dir/config.js
                    echo -e "hoping：'PreventImperson'值已经被修改成\033[0;33m false \033[0m喵~."
                else
                    echo -e "呜呜X﹏X\nhoping喵未能找到'PreventImperson'."
                fi
            else
                echo "未进行修改喵~"
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
        a)
            current_values=$(grep '"padtxt":' clewd/config.js | sed -e 's/.*"padtxt": "\(.*\)".*/\1/')
            echo -e "当前的padtxt值为: \033[0;33m$current_values\033[0m"
            echo -e "请输入新的padtxt值喵，格式如：1000,1000,15000"
            read new_values
            sed -i "s/\"padtxt\": \([\"'][^\"']*[\"']\|[0-9]\+\)/\"padtxt\": \"$new_values\"/g" clewd/config.js
            echo -e "更新后的padtxt值: \033[0;36m$(grep '"padtxt":' clewd/config.js | sed -e 's/.*"padtxt": "\(.*\)".*/\1/')\033[0m"
            ;;
        b)
            # Check if 'sactag' is already in the Settings
            cd /root/clewd
            if grep -q '"sactag"' "config.js"; then
                sactag_value=$(grep '"sactag"' "config.js" | sed -E 's/.*"sactag": *"([^"]+)".*/\1/')
            else
                # Add 'sactag' to the Settings
                sed -i'' -e '/"Settings": {/,/}/{ /[^,]$/!b; /}/i\        ,"sactag": "默认"' -e '}' "config.js"
                sactag_value="默认"
            fi
            
            print_selected() {
            echo -e "\033[0;33m--------------------------------\033[0m"
            echo -e "\033[0;33m使用上↑，下↓进行控制\n\033[0m回车选择。"
            echo -e "喵喵当前正在使用: \033[5;36m$sactag_value\033[0m"
            }
            
            configbak=() # 初始化一个空数组
            for file in config_*.js; do
                # 提取每个文件名中的 * 部分，需要去掉 'config_' 和 '.js'
                config_string="${file#config_}"
                config_string="${config_string%.js}"
                # 将提取后的字符串添加到数组中
                configbak+=("$config_string")
            done
            # 输出数组内容以验证结果
            echo "${configbak[@]}"
            modules=("${configbak[@]}")
            modules+=(新建 删除 取消)
            
            declare -A selection_status
            for i in "${!modules[@]}"; do
                selection_status[$i]=0
            done
            
            show_menu() {
                print_selected
            	echo -e "\033[0;33m--------------------------------\033[0m"
            	for i in "${!modules[@]}"; do
            	    if [[ "$i" -eq "$current_selection" ]]; then
            		  # 当前选择中的选项使用绿色显示
            		  echo -e "${GREEN}${modules[$i]}${NC}"
            		else
            		  # 其他选项正常显示
            		  echo -e "${modules[$i]} (未选择)"
            		fi
            	done
            	echo -e "\033[0;33m--------------------------------\033[0m"
            }
            
            clear
            current_selection=1
            while true; do
                show_menu
            	# 读取用户输入
            	IFS= read -rsn1 key
            
            	case "$key" in
                    $'\x1b')
            		# 读取转义序列
            		read -rsn2 -t 0.1 key
            		case "$key" in
            	        '[A') # 上箭头
            			  if [[ $current_selection -eq 0 ]]; then
            				current_selection=$((${#modules[@]} - 1))
            			  else
            				((current_selection--))
            			  fi
            			  ;;
            			'[B') # 下箭头
            			  if [[ $current_selection -eq $((${#modules[@]} - 1)) ]]; then
            				current_selection=0
            			  else
            				((current_selection++))
            			  fi
            			  ;;
            		  esac
            		  ;;
            		"") # Enter键
            		  if [[ $current_selection -eq $((${#modules[@]} - 3)) ]]; then
            			#创建新配置
                        echo "给新的config.js命名喵~"
                        while :
                        do
                            read newsactag
                            [ -n "$newsactag" ] && break
                            echo "命名不能为空，快重新输入🐱喵~"
                        done
                        mv config.js "config_$sactag_value.js"
                        ps -ef | grep clewd.js | awk '{print$2}' | xargs kill -9
                        bash start.sh
                        sed -i'' -e "/\"Settings\": {/,/}/{ /[^,]$/!b; /}/i\\        ,\"sactag\": \"$newsactag\"" -e '}' "config.js"
                        cd /root
                        clewdSettings
                        break
                      elif [[ $current_selection -eq $((${#modules[@]} - 2)) ]]; then
                        #删除config.js
                        echo "输入需要删除的配置名称喵~"
                        echo "当前存在"
                        echo "${configbak[@]}"
                        while :
                        do
                            read delsactag
                            configfile=$(ls config_$delsactag.js 2>/dev/null)
                            [ -n "$configfile" ] && break
                            echo "没找到对应配置，检查一下名称是不是输错了喵~"
                        done
                        rm -rf $configfile
                        cd /root
                        break
            		  elif [[ $current_selection -eq $((${#modules[@]} - 1)) ]]; then
            			# 选择 "退出" 选项
            			echo "当前并未选择"
            			cd /root
            			break
            		  else
            			# 切换config.js
            			mv config.js "config_$sactag_value.js"
            			mv "config_${modules[$current_selection]}.js" config.js
            			echo -e "config文件成功切换为：\033[5;36m$(grep '"sactag"' "config.js" | sed -E 's/.*"sactag": *"([^"]+)".*/\1/')\033[0m"
            			sleep 2
            			cd /root
            			break
            		  fi
            		  ;;
            		'q') # 按 'q' 退出
            		  cd /root
            		  break
            		  ;;
            	esac
            	# 清除屏幕以准备下一轮显示
            	clear
            done
            cd ~
            ;;
        c)
            echo "是否添加自定义模型喵[y/n]？"
            read cuschoice
            if [[ "$cuschoice" == [yY] ]]; then
                echo "输入自定义的模型名称喵~"
                read model_name
                sed -i "/((name => ({ id: name }))), {/a\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ id: '$model_name'},{" clewd/clewd.js
            else
                echo "并未添加自定义模型喵~"
            fi
            ;;
        d)
            # 修改 api_rProxy
            echo -e "是否修改api_rProxy地址喵~?"[y/n]
            read  choice
            case $choice in  
                [yY])
                    # 读取用户输入rProxy
                    read -p "请输入需要设置代理地址喵~:" api_rProxy
                    # 更新配置文件的rProxy
                    sed -i 's#"api_rProxy": ".*",#"api_rProxy": "'$api_rProxy'",#g' $clewd_dir/config.js
                    echo "api_rProxy已修改为$api_rProxy"
                    ;; 
                *) 
                    echo "不修改喵~"
                    ;; 
            esac
            ;;
        0)
			echo -e "hoping：选择更新模式(两种模式都会保留重要数据)喵~\n\033[0;33m--------------------------------------\n\033[0m\033[0;33m选项1 使用git pull进行简单更新\n\033[0m\033[0;37m选项2 几乎重新下载进行全面更新\n\033[0m"
            read -n 1 -p "" clewdup_choice
			echo
			cd /root
			case $clewdup_choice in
				1)
					cd /root/clewd
					git checkout -b test origin/test
					git pull
					;;
				2)
					git clone -b test https://github.com/teralomaniac/clewd.git /root/clewd_new
					if [ ! -d "clewd_new" ]; then
						echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因为网络波动下载失败了，更换网络再试喵~\n\033[0m"
						exit 5
					fi
					cp -r clewd/config*.js clewd_new/
					if [ -f "clewd_new/config.js" ]; then
						echo "config.js配置文件已转移，正在删除旧版clewd"
						rm -rf /root/clewd
						mv clewd_new clewd
					fi
					;;
			esac
			clewd_version="$(grep '"version"' "clewd/package.json" | awk -F '"' '{print $4}')($(grep "Main = 'clewd修改版 v'" "clewd/lib/clewd-utils.js" | awk -F'[()]' '{print $3}'))"
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
喵喵一键脚本
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
\033[0;33m选项5 神秘小链接$saclinkemoji\033[0m
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
		5)
			saclinkname=$(curl -s https://raw.githubusercontent.com/hopingmiao/termux_using_Claue/main/secret_saclink | awk -F '|' '{print $1 }')
			echo -e "神秘小链接会不定期悄悄更新，这次的神秘小链接是..."
			sleep 2
			echo $saclinkname
			termux-open-url $(curl -s https://raw.githubusercontent.com/hopingmiao/termux_using_Claue/main/secret_saclink | awk -F '|' '{print $2 }')
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
