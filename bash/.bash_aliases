#!/bin/bash

unalias -a
alias ls='ls --color'
alias ll='ls -lA --color'
alias grep='grep --color'

function cd () {

  command cd "$@"

  if [ $? -eq 0 ]; then

    OUT=$(timeout 0.1 bash -c \
\ \ \ 'SZ=0;'\
\ \ \ 'DSZ=$(( (('${LINES}' / 2) * ('${COLUMNS}' / ((('\
\ \ \ '  $(command ls -Ul'\
\ \ \ '    | awk "{printf \"%s %s %s\n\", \$9, \$10, \$11}"'\
\ \ \ '    | wc -L) / 8) + 1) * 8))) + 1 ));'\
\ \ \ 'SZ=$(command ls -U'\
\ \ \ '     | (while read -r file && [ ${SZ} -lt ${DSZ} ]; do'\
\ \ \ '          ((SZ+=1));'\
\ \ \ '        done; echo ${SZ}));'\
\ \ \ 'NC="$(tput sgr0)";'\
\ \ \ 'if [ ${SZ} -eq 0 ]; then'\
\ \ \ '  COL="$(tput bold)$(tput setaf 6)";'\
\ \ \ '  echo -e "${COL}No regular files found in this directory.${NC}";'\
\ \ \ 'elif [ ${SZ} -lt ${DSZ} ]; then'\
\ \ \ '  ls -l --color | tail -n+2'\
\ \ \ '    | awk "{printf \"%s %s %s\n\", \$9, \$10, \$11}";'\
\ \ \ 'else'\
\ \ \ '  COL="$(tput bold)$(tput setaf 3)";'\
\ \ \ '  echo -e "${COL}Huge current directory."'\
\ \ \ \ '"Use listing commands carrefully.${NC}";'\
\ \ \ 'fi')

    if [ $? -eq 124 ]; then
      local COL="$(tput bold)$(tput setaf 9)"
      local NC="$(tput sgr0)"
      echo -e "${COL}Timeout occured."\
        "Avoid listing commands in current directory.${NC}"
      exit 1
    fi

    HID=$(timeout 0.1 bash -c \
\ \ \ 'if [ $(ls -d .??* 2> /dev/null | wc -m) -gt 0 ]; then'\
\ \ \ ' COL="$(tput bold)$(tput setaf 13)";'\
\ \ \ ' NC="$(tput sgr0)";'\
\ \ \ ' echo -e "${COL}Hidden file(s) detected."'\
\ \ \ \ '"Use ls -d .??* | column to see them.${NC}";'\
\ \ \ 'fi')

    if [ $? -eq 124 ]; then
      local COL="$(tput bold)$(tput setaf 9)"
      local NC="$(tput sgr0)"
      echo -e "${COL}Timeout occured."\
        "Avoid listing commands in current directory.${NC}"
      exit 1
    fi

    [ $(echo "${HID}" | wc -L) -gt 0 ] && echo -e "${HID}"
    echo -e "${OUT}" | column
  fi
}

# change directories easily
for I in $(seq 2 1 10); do
  ALIAS=$(printf '.%.0s' $(seq 1 ${I}))
  DIR=$(printf '../%.0s' $(seq 1 $(( ${I} - 1 ))))
  alias "${ALIAS}"='cd '${DIR}
done

function mkdir () {
  command mkdir -pv "$@"
  if [ $? -eq 0 ]; then
    for DIR in $(echo "$@"); do
      echo -n "mkdir: change directory for '$(realpath ${DIR})' ? " \
        && read Y && [[ ${Y,,} == 'y' ]] && cd ${DIR} && break
    done
  fi
}

alias vi='vim'
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias hs='history | grep -i'
alias f?='find . | grep -E'
alias ps?='ps -ax | grep -E'
alias sudo='sudo '
alias update='sudo apt-get update && sudo apt-get upgrade '\
\ '&& sudo apt-get autoremove && sudo apt-get autoclean'
alias executor='gnome-extensions prefs executor@raujonas.github.io'

function extract () {

  if [[ "$#" -lt 1 ]]; then
    echo "Usage: extract <path/file_name>"\
      ".<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    return 1 #not enough args
  fi

  if [[ ! -e "$1" ]]; then
    echo -e "File does not exist!"
    return 2 # File not found
  fi

  local DESTDIR="."

  local FILE=$(basename "$1")

  case "${FILE##*.}" in
    tar)
      echo -e "Extracting $1 to $DESTDIR: (uncompressed tar)"
      tar xvf "$1" -C "$DESTDIR"
      ;;
    gz)
      echo -e "Extracting $1 to $DESTDIR: (gip compressed tar)"
      tar xvfz "$1" -C "$DESTDIR"
    ;;
    tgz)
      echo -e "Extracting $1 to $DESTDIR: (gip compressed tar)"
      tar xvfz "$1" -C "$DESTDIR"
      ;;
    xz)
      echo -e "Extracting  $1 to $DESTDIR: (gip compressed tar)"
      tar xvf -J "$1" -C "$DESTDIR"
      ;;
    bz2)
      echo -e "Extracting $1 to $DESTDIR: (bzip compressed tar)"
      tar xvfj "$1" -C "$DESTDIR"
      ;;
    tbz2)
      echo -e "Extracting $1 to $DESTDIR: (tbz2 compressed tar)"
      tar xvjf "$1" -C "$DESTDIR"
      ;;
    zip)
      echo -e "Extracting $1 to $DESTDIR: (zip compressed file)"
      unzip "$1" -d "$DESTDIR"
      ;;
    lzma)
      echo -e "Extracting $1 : (lzma compressed file)"
      unlzma "$1"
      ;;
    rar)
      echo -e "Extracting $1 to $DESTDIR: (rar compressed file)"
      unrar x "$1" "$DESTDIR"
      ;;
    7z)
      echo -e  "Extracting $1 to $DESTDIR: (7zip compressed file)"
      7za e "$1" -o "$DESTDIR"
      ;;
    xz)
      echo -e  "Extracting $1 : (xz compressed file)"
      unxz  "$1"
      ;;
    exe)
      cabextract "$1"
      ;;
    *)
      echo -e "Unknown format!"
      return
      ;;
  esac
}

git config --global --replace-all alias.podium "!git ls-files \
  | xargs -n1 git blame --line-porcelain | sed -n 's/^author //p' \
  | sort -f | uniq -ic | sort -nr"

git config --global --replace-all alias.tree "!bash -c \"
function git-tree () {
  git log --graph --color --abbrev-commit --date=relative \
    --pretty=format:'%Cred%h%Creset %C(cyan)%an%Creset: %s\
%C(yellow)%d%Creset (%cr)' \$* | sed 's/\((.\+\) et\(.\+)\)$/\1,\2/g' \
    | sed 's/\((.\+\) ans\?\(.*)\)$/\1Y\2/g' \
    | sed 's/\((.\+\) mois\(.*)\)$/\1M\2/g' \
    | sed 's/\((.\+\) semaines\?\(.*)\)$/\1W\2/g' \
    | sed 's/\((.\+\) jours\?\(.*)\)$/\1d\2/g' \
    | sed 's/\((.\+\) heures\?\(.*)\)$/\1h\2/g' \
    | sed 's/\((.\+\) minutes\?\(.*)\)$/\1m\2/g' \
    | sed 's/\((.\+\) secondes\?\(.*)\)$/\1s\2/g' \
    | sed 's/(il y a \(.\+\))$/$(tput setaf 2)(\1)$(tput sgr0)/' \
    | less -R -S
}
git-tree\""

git config --global --replace-all alias.undo "!bash -c \"
function git-undo () {
  if [ \$(git diff --cached --name-only | wc -l) -gt 0 ]; then
    git reset --mixed
  elif [ \$(git log --pretty=oneline origin/master..master | wc -l) -gt 0 ] \
    && [ \$(git status -s | wc -l) -eq 0 ]; then
      git reset --soft HEAD^
  fi
}
git-undo\""

alias ga='git add'
alias gA='git add -A'
alias gam='git add -A && git commit -m'
alias gb='git branch'
alias gh='git checkout'
alias gm='git commit -m'
alias go='git podium'
alias gp='git pull'
alias gP='git push'
alias gs='git status -s'
alias gt='git tree'
alias gu='git undo'

function gc () {
  git clone "$1" && command cd "$(basename "$1" .git)"
  [ $? -eq 0 ] && [ -f "${GIT_TEMPLATE_DIR}/.gitignore" ] \
    && echo -e "\n$(cat ${GIT_TEMPLATE_DIR}/.gitignore)" >> .gitignore
  [ $? -eq 0 ] && [ -d "${GIT_TEMPLATE_DIR}/.hooks" ] \
    && command cp ${GIT_TEMPLATE_DIR}/.hooks/* .git/hooks
}

function gd () {
  git diff --color-words "$@" | less -R -S
}

function gamP () {
  git add -A && git commit -m "$@" && git pull && git push
}
