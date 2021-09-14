{
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let 
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      packages.x86_64-linux.example = pkgs.writeShellScriptBin "example" ''
        ${pkgs.julia_16-bin}/bin/julia --startup-file=no --project=${./Example} -e 'using Example; Example.greet()'
      '';
      packages.x86_64-linux.run-example = pkgs.writeShellScriptBin "example" ''
        shopt -s globstar

        tmp="$(mktemp -d)"
        cd $tmp

        cp -r ${./.}/* .
        
        chmod a+w ./**/*
        touch -c ./**/*
        
        ./example.sh
      '';
    };
}
