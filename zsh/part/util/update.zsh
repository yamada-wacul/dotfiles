# update all

function update {
    set -e
    if (($# > 0)); then
        while (($# > 0)); do
            update_$1
            shift
        done
    else
        update_paru
        update_go
        update_yarn
        update_brew
        update_gordon
        update_asdf
        echo done
    fi
}

# update go/bin {{{
function update_go {
    echo updating go
    if command -v go >/dev/null 2>&1; then
        pushd ~
        local gobin="$(go env GOBIN)"
        local gobin="${gobin:-$(go env GOPATH)/bin}"
        print -rl ${gobin}/*(*) | while read file; do
            local pkg="$(go version -m "$file" | head -n2 | tail -n1 | awk '{print $2}')"
            go install $pkg@latest
        done
        popd
    fi
}
# }}}

# update yarn global {{{
function update_yarn {
    echo updating yarn
    pushd ~
    if command -v yarn >/dev/null 2>&1; then
        yarn global upgrade --latest
    fi
    popd
}
alias update_js=update_yarn
alias update_npm=update_yarn
# }}}

# update brew {{{
function update_brew {
    echo updating brew
    pushd ~
    if command -v brew >/dev/null 2>&1; then
        brew upgrade --fetch-HEAD
    fi
    popd
}
# }}}

# update paru {{{
function update_paru {
    set -e
    echo updating paru
    pushd ~
    if command -v paru >/dev/null 2>&1; then
        paru -Suuyy --cleanafter --rebuild --redownload --noconfirm
        if paru -Q neovim-nightly-bin >/dev/null 2>&1; then
            echo "neovim will be updated by paru if necessary"
        else
            eval "$(luarocks --lua-version=5.1 path)"
            nvim_tmpdir="$(mktemp -d)"
            trap "rm -rfv $nvim_tmpdir" EXIT
            git clone --depth 1 -b nightly https://github.com/neovim/neovim "$nvim_tmpdir/neovim"
            pushd "$nvim_tmpdir/neovim"
            if [ "$(find "$(command -v nvim)" -mtime +1 | wc -l)" != "0" ]; then
                make CMAKE_BUILD_TYPE=Release
                sudo make install
            fi
            sudo cp ./runtime/nvim.desktop /usr/local/share/applications/nvim.desktop
            popd
        fi
    fi
    popd
}
# }}}

# update asdf {{{
function update_asdf {
    echo updating asdf
    pushd ~
    if command -v asdf >/dev/null 2>&1; then
        asdf plugin-update --all
    fi
    popd
}
# }}}

# update gordon {{{
function update_gordon {
    echo updating gordon
    pushd ~
    if command -v gordon >/dev/null 2>&1; then
        gordon update --all
    fi
    popd
}
# }}}

# update rust {{{
function update_rust {
    echo updating rust
    pushd ~
    if command -v rustup >/dev/null 2>&1; then
        rustup update
    fi
    if command -v cargo >/dev/null 2>&1; then
        cargo install "$(cargo install --list | perl -ne'/^([\w-]+) v[\d.]+:$/&&print"$1\n"')"
    fi
    popd
}
# }}}
