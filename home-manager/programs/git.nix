_: {
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "Trouble-Truffle";
      user.email = "perigordtruffle7318@gmail.com";
    };
  };
}
