#!/bin/sh

# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/


# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする
# bindkey -e

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
PROMPT="%{${fg[$prompt_color]}%}%n@%M:%{${reset_color}%}%~
%{%(?.$fg[white].$fg[red])%}%#%{$reset_color%} "


# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
# autoload -Uz compinit
# compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

zstyle ':completion:*' menu select interactive
setopt menu_complete

zmodload zsh/complist                                         # "bindkey -M menuselect"設定できるようにするためのモジュールロード
bindkey -v '^a' beginning-of-line                             # 行頭へ(menuselectでは補完候補の先頭へ)
bindkey -v '^b' backward-char                                 # 1文字左へ(menuselectでは補完候補1つ左へ)
bindkey -v '^e' end-of-line                                   # 行末へ(menuselectでは補完候補の最後尾へ)
bindkey -v '^f' forward-char                                  # 1文字右へ(menuselectでは補完候補1つ右へ)
bindkey -v '^h' backward-delete-char                          # 1文字削除(menuselectでは絞り込みの1文字削除)
bindkey -v '^i' expand-or-complete                            # 補完開始
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
bindkey -M menuselect '^g' .send-break                        # send-break2回分の効果
bindkey -M menuselect '^i' forward-char                       # 補完候補1つ右へ
bindkey -M menuselect '^j' .accept-line                       # accept-line2回分の効果
bindkey -M menuselect '^k' accept-and-infer-next-history      # 次の補完メニューを表示する
bindkey -M menuselect '^n' down-line-or-history               # 補完候補1つ下へ
bindkey -M menuselect '^p' up-line-or-history                 # 補完候補1つ上へ
bindkey -M menuselect '^r' history-incremental-search-forward # 補完候補内インクリメンタルサーチ

########################################
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:git:*' formats "%F{$prompt_color}[%b]%f"
zstyle ':vcs_info:git:*' actionformats '%F{red}[%b|%a]%f'

# kube-ps1
if [ -e /opt/homebrew/opt/kube-ps1/share/kube-ps1.sh ]; then
  . /opt/homebrew/opt/kube-ps1/share/kube-ps1.sh
fi

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    # kubectl context and vcs info
    RPROMPT="$(kube_ps1 2>/dev/null) ${vcs_info_msg_0_} %*"
}
add-zsh-hook precmd _update_vcs_info_msg

########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
# setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
# setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
# setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

########################################
# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
# if which pbcopy >/dev/null 2>&1 ; then
#     # Mac
#     alias -g C='| pbcopy'
# elif which xsel >/dev/null 2>&1 ; then
#     # Linux
#     alias -g C='| xsel --input --clipboard'
# elif which putclip >/dev/null 2>&1 ; then
#     # Cygwin
#     alias -g C='| putclip'
# fi


########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        # [zshでもgitの補完機能使えるようにする設定]
        # (http://qiita.com/ryomits/items/8abbcc683457b5e9ca34)
        fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac
