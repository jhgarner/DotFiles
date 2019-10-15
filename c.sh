c () {
  if [ "$#" -ne 1 ]; then
    echo Use like \"c name\".
  else
    line=$(cat ~/projlist.txt | grep ".* $1")
    echo $line
    name=$(echo $line | cut -d' ' -f2)
    tPath=$(echo $line | cut -d' ' -f1)
    if [ ! -d "$tPath/$name" ]; then
      echo Could not find project with name \"$name\".
    elif [ ! -f "$tPath/onenter" ]; then
      echo Could not find an onenter file
    else
      cd "$tPath/$name"
      if ../onenter "$tPath" "$name"; then
        echo $name > ~/activeProject
        echo Successfully entered project
      else
        echo Onenter failed. You environment may be in an unstable state.
        echo Please fix that manually before doing anything else.
      fi
    fi
  fi
}
