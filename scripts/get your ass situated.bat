if exist scripts\dependencies.hxml (
	haxelib newrepo
	haxelib install scripts/dependencies.hxml --always --quiet --skip-dependencies
) else (
	echo "haxelibs.bat should be run from the project root"
)