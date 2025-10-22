fish_add_path $HOME/.local/bin

if status is-interactive
  set -g fish_key_bindings fish_vi_key_bindings
  fish_config theme choose "Catppuccin Mocha"

  set -g fish_greeting
  set -gx EDITOR vim
  set -gx VISUAL vim
  set -gx BROWSER /usr/bin/firefox
end

