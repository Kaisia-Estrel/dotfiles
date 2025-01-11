{
  programs.kitty = {
    enable = true;

    settings = {
      tab_bar_style = "powerline";
      disable_ligatures = "cursor";
      dynamic_background_opacity = true;
      allow_remote_control = true;

      shell_integration = true;
    };
    keybindings = {
      "kitty_mod+x" = "close_window";
      "kitty_mod+enter" = "launch --cwd=current";
      "kitty_mod+j" = "next_window";
      "kitty_mod+k" = "previous_window";
      "kitty_mod+h" = "move_window_forward";
      "kitty_mod+l" = "move_window_backward";
      "kitty_mod+`" = "move_window_to_top";
      "kitty_mod+r" = "start_resizing_window";
      "kitty_mod+alt+l" = "next_tab";
      "kitty_mod+alt+h" = "previous_tab";
    };
  };
}
