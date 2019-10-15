mk () {
  if [ "$#" -ne 2 ]; then
    echo Use like \"mk type name\".
  else
    tPath=~/$(cat ~/aliases.txt | grep "$1 .*" | cut -d' ' -f2)
    if [ tPath = "" ]; then
      echo No project alias found
    elif [ ! -f "$tPath/mkfile" ]; then
      echo No mkfile found at ~"/$tPath/mkfile"
    elif [ -d "$tPath/$2/" ]; then
      echo Project already exists.
    else
      cd "$tPath"
      if "$tPath/mkfile" "$tPath" "$2"; then
        echo $tPath $2 >> ~/projlist.txt
        cd "$2"
        git init .
        git push --set-upstream git@gitlab.com:jhgarner/$(git rev-parse --show-toplevel | xargs basename).git $(git rev-parse --abbrev-ref HEAD)
        echo $name > ~/activeProject
        echo Created project successfully.
      else
        echo Failed to create file. You folders may be in a broken state.
        echo Any partially created folders or files will need to be removed manually.
      fi
    fi
  fi
}
