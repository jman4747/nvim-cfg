$env.NVIM_LOCAL_CFG = (pwd | path join ".nvim.lua")

let pkgs = [
	"nixpkgs#lua-language-server"
	# gcc for treesitter
	"nixpkgs#gcc"
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
