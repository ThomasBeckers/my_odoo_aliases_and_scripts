##############################################
##############  misc  stuffs  ################
##############################################


alias c='clear'
alias e="vim"

alias reload_zshrc='source $AP/alias_loader.sh'

eza(){
    # edit and reload alias
    local file_to_load=" "
    case $1 in
        zsh)
            file_to_load="zsh_alias.sh"
            ;;
        loader)
            file_to_load="alias_loader.sh"
            ;;
        odoo)
            file_to_load="odoo_alias.sh"
            ;;
        git)
            file_to_load="python_scripts/git_odoo.py"
            ;;
        start)
            file_to_load="python_scripts/start_odoo.py"
            ;;
        psql)
            file_to_load="python_scripts/psql_odoo.py"
            ;;
        drop)
            file_to_load="drop_protected_dbs.txt"
            ;;
        typo)
            file_to_load="typo.sh"
            ;;
        "")
            #default
            file_to_load="odoo_alias.sh"
            ;;
        *)
            echo "zsh_alias.sh --> eza zsh"
            echo "alias_loader.sh --> eza loader"
            echo "odoo_alias.sh --> eza odoo   or   eza"
            echo "drop_protected_dbs.txt --> eza drop"
            echo "git_odoo.py --> eza git"
            echo "psql_odoo.py --> eza psql"
            echo "start_odoo.py --> eza start"
            echo "typo.py --> eza typo"
            return
            ;;
    esac

    e $AP/$file_to_load &&
    reload_zshrc
}



#history analytics
history_count(){
    history -n | cut -d' ' -f1 | sort | uniq -c | trim | sort -gr | less
}
trim(){
    awk '{$1=$1};1'
}


#########################################
######## system specific stuffs #########
#########################################

if [ "$OSTYPE" = "darwin18.0" ]
then
    # macos
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    alias gedit='/usr/local/Cellar/gedit/3.30.2/bin/gedit'
    alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'

    #monitoring
    alias netdata="netdata_start > /dev/null && open http://localhost:19999"
    alias netdata_start="brew services start netdata"
    alias netdata_stop="brew services stop netdata"

    # end of macos stuffs
else
    # linux

    maj(){
        sudo apt-get update &&
        sudo apt-get upgrade -y &&
        sudo apt-get autoclean &&
        sudo apt-get autoremove -y
    }

    fullmaj(){
        sudo apt-get update &&
        sudo apt-get upgrade -y &&
        sudo apt-get dist-upgrade -y &&
        sudo apt-get autoclean &&
        sudo apt-get autoremove -y
    }


    alias cya='systemctl suspend -i'

    clear_ram(){
        echo "This is going to take a while ..." &&
        echo "Droppping cache" &&
        sudo su -c "echo 3 > /proc/sys/vm/drop_caches" root &&
        echo "Cache dropped" &&
        echo "turning swap off" &&
        sudo swapoff -a &&
        echo "turning swap back on" &&
        sudo swapon -a &&
        echo "Aaaaaand... done!"
    }

    noweb(){
            sg no_web $@[1,-1]
    }
    alias ni='noweb'

    # end of linux stuff
fi



##############################################
##############  typo  stuffs  ################
##############################################

new_typo(){
    local typo=$1
    local correct_command=$2
    echo "alias '$typo'='$correct_command'" >> $AP/typo.sh
    reload_zshrc
}

commit_typos(){
    git -C $AP add $AP/typo.sh
    git -C $AP commit -m "[AUTOMATIC] update typos file"
}
