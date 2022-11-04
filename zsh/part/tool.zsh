# GnuPGでPassphraseを使う際のTTYを設定
if [ "$NVIM_TERMINAL" = "1" ]; then
    : # in nvim
else
    export GPG_TTY="$(tty)"
fi

# Java
function java() {
    unset -f java
    eval "export JAVA_HOME=system('/usr/libexec/java_home')"
    eval "export PATH=\$JAVA_HOME.'/bin:'.\$PATH"
    java $@
}

# mongoshでのファイル実行: 常に--nodbで始めるオプション
# mongorun hoge.js のように使う
alias mongorun='mongosh --nodb --quiet'
