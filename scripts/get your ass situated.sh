if [ -d "scripts/" ]; then
	if [ -d ".haxelib/" ]; then
		echo ".haxelib found"
	else
		echo ".haxelib not found, creating directory..."
		haxelib newrepo
	fi
	echo "installing dependencies..."
	haxelib install scripts/dependencies.hxml --always --quiet --skip-dependencies
else
	echo "haxelibs.sh should be run from the project root, ran from $PWD"
fi