{
  description = "Tally tool flake";

  inputs = {
    nixpkgs.url = "nixpkgs";
    ruby-nix.url = "github:inscapist/ruby-nix";
    # a fork that supports platform dependant gem
    bundix = {
      url = "github:inscapist/bundix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fu.url = "github:numtide/flake-utils";
    bob-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";
    bob-ruby.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, fu, ruby-nix, bundix, bob-ruby }:
    with fu.lib;
    eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ bob-ruby.overlays.default ];
        };
        rubyNix = ruby-nix.lib pkgs;
        gemset = import ./the-thing/gemset.nix;
        # See available versions here: https://github.com/bobvanderlinden/nixpkgs-ruby/blob/master/ruby/versions.json
        ruby = pkgs."ruby-3.2";
        bundixcli = bundix.packages.${system}.default;

        # If you want to override gem build config, see
        #   https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/ruby-modules/gem-config/default.nix
        gemConfig = { };

        rubyEnv = (rubyNix {
          inherit gemset ruby;
          name = "tally-tool";
          gemConfig = pkgs.defaultGemConfig // gemConfig;
        }).env;
      in
      {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = (
              let
                railsInputs = [ rubyEnv bundixcli ] ++ (with pkgs; [ nodejs yarn rufo ]);

                nodeJsInputs = with pkgs; [
                  nodePackages.pnpm
                  nodePackages.typescript-language-server
                ];

                utilityInputs = with pkgs; [
                  httpie
                  nil
                  just
                  fzf
                  terraform
                  terraform-ls
                  awscli
                ];
              in
              railsInputs ++ nodeJsInputs ++ utilityInputs
            );

            shellHook =
              let
                aws = import ./aws.nix;
              in
              ''
                export AWS_ACCESS_KEY_ID=${aws.accessKeyId}
                export AWS_SECRET_ACCESS_KEY=${aws.secretAccessKey}
                export AWS_SESSION_TOKEN=${aws.sessionToken}
              '';
          };
        };

        formatter = pkgs.nixpkgs-fmt;
      });
}
