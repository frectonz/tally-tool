{
  description = "Tally tool flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fu.url = "github:numtide/flake-utils";

    ruby-nix = {
      url = "github:inscapist/ruby-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # a fork that supports platform dependant gem
    bundix = {
      url = "github:inscapist/bundix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bob-ruby = {
      url = "github:bobvanderlinden/nixpkgs-ruby";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "fu";
      };
    };
  };

  outputs = { self, nixpkgs, fu, ruby-nix, bundix, bob-ruby }:
    with fu.lib;
    eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ bob-ruby.overlays.default ];
          config.allowUnfree = true;
        };
        rubyNix = ruby-nix.lib pkgs;
        gemset = import ./the-thing/gemset.nix;

        # See available versions here: https://github.com/bobvanderlinden/nixpkgs-ruby/blob/master/ruby/versions.json
        ignoringVulns = x: x // { meta = (x.meta // { knownVulnerabilities = [ ]; }); };
        ruby = pkgs."ruby-3.0.6".override {
          openssl = pkgs.openssl_1_1.overrideAttrs ignoringVulns;
        };
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
              ''
                export AWS_ACCESS_KEY_ID=$(pass tally-tool/access-key)
                export AWS_SECRET_ACCESS_KEY=$(pass tally-tool/access-key-secret)
                export AWS_DEFAULT_REGION=eu-west-3
                export AWS_DEFAULT_OUTPUT=table

                export RAILS_MASTER_KEY=$(cat the-thing/config/master.key)

                export APP_URL="https://tally-tool.frectonz.io"
              '';
          };
        };

        formatter = pkgs.nixpkgs-fmt;
      });
}
