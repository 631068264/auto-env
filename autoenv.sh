#!/bin/bash

#!/bin/bash


auto_active(){
    _dir="$PWD"
    _env_path=$(find "$_dir" -maxdepth 2 -type d -name 'bin' -exec find {} -name 'activate' \; 2> /dev/null)

    if [[ -e "${_env_path}" ]]
    then
        # stop activate repeatedly
        if [[ "$VIRTUAL_ENV" != "${_env_path%/bin/activate}" ]];then
            source $_env_path
        fi
    else
        if [[ -n "$VIRTUAL_ENV" &&  "$_dir" != $(dirname "$VIRTUAL_ENV")/* ]]
        then
            deactivate 2>/dev/null
        fi
    fi
}

auto_env(){
    env_cd()
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
        env_cd "$@"
    }
    cd .
}


auto_env

