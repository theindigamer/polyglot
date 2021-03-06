#!/usr/bin/env sh

set -e
set pipefail

getTarget() {
    if [ "$(uname)" = "Darwin" ]
    then
        echo "poly-$(uname -m)-apple-darwin"
    else
        echo "poly-$(uname -m)-unknown-linux"
    fi
}

main() {

    latest="$(curl -s https://github.com/vmchale/polyglot/releases/latest/ | cut -d'"' -f2 | rev | cut -d'/' -f1 | rev)"
    binname=$(getTarget)
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share/man/man1/"
    mkdir -p "$HOME/.compleat"
    dest=$HOME/.local/bin/poly
    man_dest=$HOME/.local/share/man/man1/poly.1
    compleat_dest=$HOME/.compleat/poly.usage
    if which duma > /dev/null ; then
        duma https://github.com/vmchale/polyglot/releases/download/"$latest"/"$binname" -O "$dest"
        duma https://github.com/vmchale/polyglot/releases/download/"$latest"/poly.1 -O "$man_dest"
        duma https://github.com/vmchale/polyglot/releases/download/"$latest"/poly.usage -O "$compleat_dest"
    else
        wget https://github.com/vmchale/polyglot/releases/download/"$latest"/"$binname" -O "$dest"
        wget https://github.com/vmchale/polyglot/releases/download/"$latest"/poly.1 -O "$man_dest"
        wget https://github.com/vmchale/polyglot/releases/download/"$latest"/poly.usage -O "$compleat_dest"
    fi
    chmod +x "$dest"

}

main
