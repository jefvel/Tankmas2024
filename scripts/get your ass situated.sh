if [ -d "scripts/" ]; then
	if [ -d ".haxelib/" ]; then
		echo ".haxelib found"
	else
		echo ".haxelib not found, creating directory..."
		mkdir .haxelib
	fi
	echo "installing dependencies..."
	haxelib install scripts/dependencies.hxml --always --quiet
else
	echo "haxelibs.sh should be run from the project root, ran from $PWD"
fi