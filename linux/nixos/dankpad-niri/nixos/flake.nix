{
	description = "dankpad - NixOS 26.05 Niri";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
		niri = { url = "github:sodiboo/niri-flake"; inputs.nixpkgs.follows = "nixpkgs"; };
		noctalia = {
		  url = "github:noctalia-dev/noctalia-shell";
		};
		sysc-greet = { url = "github:Nomadcxx/sysc-greet"; inputs.nixpkgs.follows = "nixpkgs"; };	
	};

	outputs = inputs@{ self, nixpkgs, home-manager, niri, noctalia, sysc-greet, ... }: {
	  nixosConfigurations.dankpad = nixpkgs.lib.nixosSystem {
	    system = "x86_64-linux";
	    specialArgs = { inherit inputs; };
	    modules = [
	      ./configuration.nix
	      ./hardware-configuration.nix
	      niri.nixosModules.niri
	      sysc-greet.nixosModules.default
	      home-manager.nixosModules.home-manager
	      {
	        home-manager.useGlobalPkgs = true;
	        home-manager.useUserPackages = true;
	        home-manager.extraSpecialArgs = { inherit inputs; };
	        home-manager.users.amata = import ./home.nix;
	        home-manager.sharedModules = [
	          noctalia.homeModules.default
	        ];
	      }
	    ];
	  };
	};
}
