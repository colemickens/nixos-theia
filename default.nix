let
  pkgs = builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "0z1gx5mqsi0ny3lcdvq4rvjr3bnp84pkfz7mdpcza6b4vmigmpxx";
  };
  yarn__ = builtins.fetchTarball {
    url = "https://github.com/nix-community/yarn2nix/archive/master.tar.gz";
    sha256 = "0z1gx5mqsi0ny3lcdvq4rvjr3bnp84pkfz7mdpcza6b4vmigmpxn";
  };
  yarn_ = import yarn__ { inherit pkgs; };
in
rec {
  theia = yarn_.mkYarnPackage {
    name = "theia";
    src = ./.;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    # NOTE: this is optional and generated dynamically if omitted
    yarnNix = ./yarn.nix;
  };
}
