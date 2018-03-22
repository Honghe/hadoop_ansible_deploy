#!/usr/bin/env bash

set -e
set -u
#set -x
set -o pipefail

usage="
Usage:
    $0 user password hosts_file"

copy_ssh_id(){
    if [ -f "/$HOME/.ssh/known_hosts" ]; then
         # 防止存储的对方host key变化导致校验出错，先删除以让其自动添加新的host key
         ssh-keygen -f "/$HOME/.ssh/known_hosts" -R "$3"
    fi
    # 进入expect
    # 使用环境变量传递参数
    user="$1" password="$2" host="$3" expect << 'EOS'
        set timeout 5;
        spawn ssh-copy-id $::env(user)@$::env(host);
        expect {
          "(yes/no)?" { send yes\n; exp_continue; }
          "password:" { send $::env(password)\n; exp_continue; }
        }
        exit
EOS
}

main() {
    while getopts ':h' option; do
        case "$option" in
            h) echo "$usage"
                exit
                ;;
        esac
    done

    if [[ "$#" -lt 3 ]]
    then
        echo "$usage"
        exit
    elif [[ "$#" -eq 3 ]]
    then
        user="$1"
        password="$2"
        hostsfile="$3"
    fi

    # TODO 目前是对hosts文件中所有主机操作，只过滤出非注释行的IP,不分组
    for host in $(cat hosts|
        grep -v "^#" |
        awk '{match($0,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/); ip = substr($0,RSTART,RLENGTH); print ip}')
    do
        copy_ssh_id $user $password $host
    done

    exit
}

main "$@"