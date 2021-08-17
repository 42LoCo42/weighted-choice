$(shell basename "$$PWD"): src/main.zig
	zig build -Drelease-fast
	cp "zig-out/bin/$@" "$@"
	strip "$@"