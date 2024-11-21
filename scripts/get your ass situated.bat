if exist scripts\dependencies.hxml (
	if exist .\.haxelib (
		echo ".haxelib found"
	) else (
		echo ".haxelib not found"
		mkdir .haxelib
	)
	haxelib install scripts/dependencies.hxml --always --quiet
) else (
	echo "haxelibs.bat should be run from the project root"
)