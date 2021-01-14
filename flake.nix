{
  description = "nixos-theia";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    yarn2nix = { url = "github:nix-community/yarn2nix"; flake = false; };
  };

  outputs = inputs:
    let
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      forAllSystems = genAttrs [ "x86_64-linux" "i686-linux" "aarch64-linux" ];

      pkgsFor = pkgs: sys:
        import pkgs {
          system = sys;
          config = { allowUnfree = true; };
        };

    in rec {
      devShell = forAllSystems (system:
        (pkgsFor inputs.nixpkgs system).mkShell {
          nativeBuildInputs = with (pkgsFor inputs.nixpkgs system); [
            bash cacert curl git jq mercurial
            nettools openssh ripgrep rsync
            nixFlakes nix-build-uncached nix-prefetch-git
            packet-cli
            sops oil
            nodePackages.node2nix
            yarn yarn2nix
          ];
        }
      );

      packages = forAllSystems (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
          };

          theia_node2nix = (import ./node2nix/default.nix { pkgs = pkgs; }).package;

          overridden = (
            let
              nodePackages = import ./node2nix/default.nix {
                inherit pkgs system;
              };
            in
            nodePackages // {
              package = nodePackages.package.overrideAttr(old: {
                nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.ripgrep ];
                preRebuild = ''
                  ${builtins.trace "foo" "echo test"}
                  echo "**************"
                  echo "**************"
                  echo "**************"
                  echo "**************"
                  ls -R .
                  echo "**************"
                  echo "**************"
                  ln -s ${pkgs.ripgrep}/bin/rg $out/lib/node_modules/vscode-ripgrep/bin/rg
                  ln -s ${pkgs.ripgrep}/bin/rg $out/bin/rg
                '';
              });
            });

          y2n = (import "${inputs.yarn2nix}/default.nix" { pkgs = pkgs; });
        in with y2n; {
          theia = builtins.trace
            #(builtins.attrNames overridden.shell.nodeDependencies.all)
            overridden
            overridden.package;
          theia2 = pkgs.yarn2nix-moretea.mkYarnPackage {
            name = "theia";
            src = ./yarn2nix;
            packageJSON = ./yarn2nix/package.json;
            yarnLock = ./yarn2nix/yarn.lock;
            yarnNix = ./yarn2nix/yarn.nix;
          };
        }
      );
    };
}

