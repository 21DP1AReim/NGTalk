{ pkgs }: {
	deps = [
        pkgs.yarn
        pkgs.nodejs-16_x
        pkgs.nano
        pkgs.ruby_3_0
        pkgs.rubyPackages_3_0.solargraph
        pkgs.rufo
        pkgs.sqlite
	];
}