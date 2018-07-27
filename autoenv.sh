#!/bin/bash

get_env_path(){
    _find_env_dir(){
        result=$(find $1 -maxdepth 2 -type d -name 'bin' -exec find {} -name 'activate' \; 2> /dev/null)
        echo ${result}
    }
    _dir="$PWD"
    _env_path=$(_find_env_dir ${_dir})
    echo $_env_path
}

auto_active(){
    _env_path=$(get_env_path)
    if [[ -e "${_env_path}" ]]
    then
        # stop activate repeatedly
        if [[ "$VIRTUAL_ENV" != "${_env_path%/bin/activate}" ]];then
            source $_env_path
        fi
    else
        if [[ -n "$VIRTUAL_ENV" &&  "$PWD" != $(dirname "$VIRTUAL_ENV")/* ]]
        then
            deactivate 2>/dev/null
        fi
    fi
}

auto_env(){
    autoenv_cd()
    {
      if builtin cd "$@"
      then
        auto_active
        return 0
      else
        return $?
      fi
    }
    cd() {
        autoenv_cd "$@"
    }
    cd .
}


auto_env

