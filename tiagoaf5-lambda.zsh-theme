MNML_ELLIPSIS_CHAR="${MNML_ELLIPSIS_CHAR:-..}"

function mnml_cwd {
    local echar="$MNML_ELLIPSIS_CHAR"
    local segments="${1:-2}"
    local seg_len="${2:-0}"

    local _w="%{\e[0m%}"
    local _g="%{\e[38;5;244m%}"

    if [ "$segments" -le 0 ]; then
        segments=0
    fi
    if [ "$seg_len" -gt 0 ] && [ "$seg_len" -lt 4 ]; then
        seg_len=4
    fi
    local seg_hlen=$((seg_len / 2 - 1))

    local cwd="%${segments}~"
    cwd="${(%)cwd}"
    cwd=("${(@s:/:)cwd}")

    local pi=""
    for i in {1..${#cwd}}; do
        pi="$cwd[$i]"
        if [ "$seg_len" -gt 0 ] && [ "${#pi}" -gt "$seg_len" ]; then
            cwd[$i]="${pi:0:$seg_hlen}$_w$echar$_g${pi: -$seg_hlen}"
        fi
    done

    printf '%b' "$_g${(j:/:)cwd//\//$_w/$_g}$_w"
}

#local ret_status="%(?:%{$fg_bold[green]%}λ :%{$fg_bold[red]%}λ )" # with bold lambda
local ret_status="%(?:%{$fg[green]%}λ :%{$fg[red]%}λ )" # with normal lambda

PROMPT='$(mnml_cwd 10 20) ${ret_status}%f› '
