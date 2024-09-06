$env.NVIM_LOCAL_CFG = (pwd | path join ".nvim.lua")

let pkgs = [
	nixpkgs#lua-language-server
]

print "Packages:"
print $pkgs

let cmd = "nix"

let args = [
	shell
	...$pkgs
	-c nu
]

^$"($cmd)" ...$args
