# Github repo switcher
# Based on https://github.com/jdxcode/gh/blob/master/zsh/gh/gh.plugin.zsh

GH_BASE_DIR=${GH_BASE_DIR:-$HOME/src}
function cdr () {
  typeset +x account=$GITHUB[user]
  typeset +x repo=""

  if (( ${+argv[2]} )); then
    repo=$argv[2]
    account=$argv[1]
  elif (( ${+argv[1]} )); then
    repo=$argv[1]
  else
    echo "USAGE: cdr [user] [repo]"
    return 127
  fi
  typeset +x directory=$GH_BASE_DIR/github.com/$account/$repo
  if [[ ! -a $directory ]]; then
    gh repo clone $account/$repo $directory
    if [[ ! -a $directory ]]; then
      return 127
    fi
  fi

  cd $directory
}
