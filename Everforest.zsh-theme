# Catppuccin.zsh-theme
# Note that some elements have been taken from the bira theme

local user_symbol='%(!.#.$)'
local error_code="%(?..%{$fg[red]%}%?%{$reset_color%})"

PROMPT='%{$fg[green]%}┌[%{$fg_bold[white]%}%n%{$reset_color%}%{$fg_bold[white]%}-%{$fg_bold[white]%}%M%{$reset_color%}%{$fg[green]%}]%{$fg[green]%}-%{$fg[green]%}[%{$fg_bold[white]%}%~%{$reset_color%}%{$fg[green]%}]$(git_prompt_info)
└%B${user_symbol}%b % %{$reset_color%}'
RPROMPT="%B${error_code}%b"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}-[%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[green]%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}%{$reset_color%}"
