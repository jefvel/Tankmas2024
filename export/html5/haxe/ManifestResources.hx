package;

import haxe.io.Bytes;
import haxe.io.Path;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

#if disable_preloader_assets
@:dox(hide) class ManifestResources {
	public static var preloadLibraries:Array<Dynamic>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;

	public static function init (config:Dynamic):Void {
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
	}
}
#else
@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

			if(!StringTools.endsWith (rootPath, "/")) {

				rootPath += "/";

			}

		}

		if (rootPath == null) {

			#if (ios || tvos || webassembly)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif (console || sys)
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		data = '{"name":null,"assets":"aoy4:pathy41:assets%2Fart%2FDailyArt%2Fthedyingsun.pngy4:sizei4292431y4:typey5:IMAGEy2:idR1y7:preloadtgoR0y48:assets%2Fart%2FDailyArt%2Fthedyingsun.png.importR2i779R3y4:TEXTR5R7R6tgoR0y34:assets%2Fdata%2Fdata-goes-here.txtR2zR3R8R5R9R6tgoR0y36:assets%2Fimages%2Fimages-go-here.txtR2zR3R8R5R10R6tgoR0y36:assets%2Fmusic%2Fmusic-goes-here.txtR2zR3R8R5R11R6tgoR2i3005383R3y5:MUSICR5y54:assets%2Fmusic%2Frudolftehrednosereindeer_littlbox.mp3y9:pathGroupaR13hR6tgoR2i2910110R3R12R5y47:assets%2Fmusic%2Fsadgamertime_ninjamuffin99.mp3R14aR15hR6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R8R5R16R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FBackground-Den_%28MelonJam%202022%29.pngR2i1573143R3R4R5R17R6tgoR0y84:assets%2FTest%20stuff%20from%20Shmood%2FBackground-Outside_%28MelonJam%202022%29.pngR2i2323754R3R4R5R18R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010001.pngR2i16372R3R4R5R19R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010002.pngR2i16372R3R4R5R20R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010003.pngR2i22732R3R4R5R21R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010004.pngR2i22732R3R4R5R22R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010005.pngR2i24552R3R4R5R23R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010006.pngR2i24552R3R4R5R24R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010007.pngR2i22732R3R4R5R25R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010008.pngR2i22732R3R4R5R26R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010009.pngR2i24552R3R4R5R27R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010010.pngR2i24552R3R4R5R28R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010011.pngR2i22732R3R4R5R29R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010012.pngR2i22732R3R4R5R30R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010013.pngR2i24552R3R4R5R31R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010014.pngR2i24552R3R4R5R32R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010015.pngR2i24552R3R4R5R33R6tgoR0y135:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D%2FTimeline%2010016.pngR2i24552R3R4R5R34R6tgoR0y116:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FHazards%2FHazard%20-%20Clock%20%5BMelonJam%5D.zipR2i365038R3y6:BINARYR5R35R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0001.pngR2i11111R3R4R5R37R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0002.pngR2i21827R3R4R5R38R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0003.pngR2i68050R3R4R5R39R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0004.pngR2i22349R3R4R5R40R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0005.pngR2i58092R3R4R5R41R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0006.pngR2i154306R3R4R5R42R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0007.pngR2i15498R3R4R5R43R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0008.pngR2i29785R3R4R5R44R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0009.pngR2i27735R3R4R5R45R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0010.pngR2i33389R3R4R5R46R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0011.pngR2i8992R3R4R5R47R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0012.pngR2i13576R3R4R5R48R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0013.pngR2i81246R3R4R5R49R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0014.pngR2i70092R3R4R5R50R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0015.pngR2i28141R3R4R5R51R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0016.pngR2i38851R3R4R5R52R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0017.pngR2i34498R3R4R5R53R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0018.pngR2i19453R3R4R5R54R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0019.pngR2i13876R3R4R5R55R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0020.pngR2i83878R3R4R5R56R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0021.pngR2i17511R3R4R5R57R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0022.pngR2i141646R3R4R5R58R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0023.pngR2i157260R3R4R5R59R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0024.pngR2i57602R3R4R5R60R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0025.pngR2i39098R3R4R5R61R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0026.pngR2i27775R3R4R5R62R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0027.pngR2i103190R3R4R5R63R6tgoR0y141:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0028%20%5BPut%20it%20in%2C%20IF%20YOU%20DARE%5D.pngR2i7913R3R4R5R64R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0029.pngR2i160216R3R4R5R65R6tgoR0y98:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FSpace%20Debris%2FDebris0030.pngR2i193646R3R4R5R66R6tgoR0y96:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FBeach%20Ball.pngR2i57186R3R4R5R67R6tgoR0y96:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FBook%20Black.pngR2i18624R3R4R5R68R6tgoR0y95:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FBook%20Blue.pngR2i20057R3R4R5R69R6tgoR0y96:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FBook%20Green.pngR2i19346R3R4R5R70R6tgoR0y97:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FBook%20Purple.pngR2i19828R3R4R5R71R6tgoR0y94:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FBook%20Red.pngR2i19456R3R4R5R72R6tgoR0y97:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FBook%20Yellow.pngR2i19930R3R4R5R73R6tgoR0y89:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FCouch.pngR2i86693R3R4R5R74R6tgoR0y110:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FNew%20stuff%2FCoffee%20Mug.pngR2i14044R3R4R5R75R6tgoR0y94:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FPoster%201.pngR2i57950R3R4R5R76R6tgoR0y94:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FPoster%202.pngR2i59213R3R4R5R77R6tgoR0y94:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FPoster%203.pngR2i82537R3R4R5R78R6tgoR0y90:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FPoster.pngR2i223214R3R4R5R79R6tgoR0y92:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FTricycle.pngR2i25058R3R4R5R80R6tgoR0y91:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2Funknown.pngR2i18477R3R4R5R81R6tgoR0y99:assets%2FTest%20stuff%20from%20Shmood%2FObjects%20%5BMelonJam%5D%2FStealables%2FWelcome%20Matte.pngR2i60844R3R4R5R82R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0001.pngR2i34369R3R4R5R83R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0002.pngR2i34369R3R4R5R84R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0003.pngR2i34369R3R4R5R85R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0004.pngR2i34369R3R4R5R86R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0005.pngR2i34064R3R4R5R87R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0006.pngR2i34064R3R4R5R88R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0007.pngR2i34064R3R4R5R89R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0008.pngR2i34064R3R4R5R90R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0009.pngR2i32724R3R4R5R91R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0010.pngR2i32724R3R4R5R92R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0011.pngR2i32724R3R4R5R93R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0012.pngR2i32724R3R4R5R94R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0013.pngR2i34064R3R4R5R95R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0014.pngR2i34064R3R4R5R96R6tgoR0y80:assets%2FTest%20stuff%20from%20Shmood%2FWALK%20%5BHands%20Free%5D%2FWalk0015.pngR2i34064R3R4R5R97R6tgoR2i8220R3R12R5y26:flixel%2Fsounds%2Fbeep.mp3R14aR98y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i39706R3R12R5y28:flixel%2Fsounds%2Fflixel.mp3R14aR100y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i6840R3y5:SOUNDR5R99R14aR98R99hgoR2i33629R3R102R5R101R14aR100R101hgoR2i15744R3y4:FONTy9:classNamey35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R103R104y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i277R3R4R5R109R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i505R3R4R5R110R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

	}


}

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_art_dailyart_thedyingsun_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_art_dailyart_thedyingsun_png_import extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_rudolftehrednosereindeer_littlbox_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_sadgamertime_ninjamuffin99_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_background_den__melonjam_2022__png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_background_outside__melonjam_2022__png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10001_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10002_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10003_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10004_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10005_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10006_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10007_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10008_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10009_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10010_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10011_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10012_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10013_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10014_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10015_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10016_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__zip extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0001_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0002_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0003_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0004_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0005_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0006_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0007_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0008_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0009_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0010_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0011_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0012_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0013_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0014_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0015_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0016_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0017_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0018_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0019_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0020_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0021_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0022_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0023_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0024_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0025_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0026_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0027_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0028__put_it_in__if_you_dare__png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0029_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0030_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_beach_ball_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_black_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_blue_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_green_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_purple_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_red_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_yellow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_couch_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_new_stuff_coffee_mug_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_poster_1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_poster_2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_poster_3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_poster_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_tricycle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_unknown_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_welcome_matte_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0001_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0002_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0003_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0004_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0005_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0006_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0007_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0008_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0009_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0010_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0011_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0012_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0013_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0014_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0015_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:image("assets/art/DailyArt/thedyingsun.png") @:noCompletion #if display private #end class __ASSET__assets_art_dailyart_thedyingsun_png extends lime.graphics.Image {}
@:keep @:file("assets/art/DailyArt/thedyingsun.png.import") @:noCompletion #if display private #end class __ASSET__assets_art_dailyart_thedyingsun_png_import extends haxe.io.Bytes {}
@:keep @:file("assets/data/data-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/music/rudolftehrednosereindeer_littlbox.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_rudolftehrednosereindeer_littlbox_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/music/sadgamertime_ninjamuffin99.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_sadgamertime_ninjamuffin99_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/Test stuff from Shmood/Background-Den_(MelonJam 2022).png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_background_den__melonjam_2022__png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Background-Outside_(MelonJam 2022).png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_background_outside__melonjam_2022__png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10001.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10001_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10002.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10002_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10003.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10003_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10004.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10004_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10005.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10005_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10006.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10006_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10007.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10007_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10008.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10008_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10009.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10009_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10010.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10010_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10011.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10011_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10012.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10012_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10013.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10013_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10014.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10014_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10015.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10015_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam]/Timeline 10016.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__timeline_10016_png extends lime.graphics.Image {}
@:keep @:file("assets/Test stuff from Shmood/Objects [MelonJam]/Hazards/Hazard - Clock [MelonJam].zip") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__hazards_hazard___clock__melonjam__zip extends haxe.io.Bytes {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0001.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0001_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0002.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0002_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0003.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0003_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0004.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0004_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0005.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0005_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0006.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0006_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0007.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0007_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0008.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0008_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0009.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0009_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0010.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0010_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0011.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0011_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0012.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0012_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0013.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0013_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0014.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0014_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0015.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0015_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0016.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0016_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0017.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0017_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0018.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0018_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0019.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0019_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0020.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0020_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0021.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0021_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0022.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0022_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0023.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0023_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0024.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0024_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0025.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0025_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0026.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0026_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0027.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0027_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0028 [Put it in, IF YOU DARE].png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0028__put_it_in__if_you_dare__png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0029.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0029_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Space Debris/Debris0030.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__space_debris_debris0030_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Beach Ball.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_beach_ball_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Book Black.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_black_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Book Blue.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_blue_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Book Green.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_green_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Book Purple.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_purple_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Book Red.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_red_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Book Yellow.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_book_yellow_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Couch.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_couch_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/New stuff/Coffee Mug.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_new_stuff_coffee_mug_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Poster 1.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_poster_1_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Poster 2.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_poster_2_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Poster 3.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_poster_3_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Poster.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_poster_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Tricycle.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_tricycle_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/unknown.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_unknown_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/Objects [MelonJam]/Stealables/Welcome Matte.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_objects__melonjam__stealables_welcome_matte_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0001.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0001_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0002.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0002_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0003.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0003_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0004.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0004_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0005.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0005_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0006.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0006_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0007.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0007_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0008.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0008_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0009.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0009_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0010.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0010_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0011.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0011_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0012.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0012_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0013.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0013_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0014.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0014_png extends lime.graphics.Image {}
@:keep @:image("assets/Test stuff from Shmood/WALK [Hands Free]/Walk0015.png") @:noCompletion #if display private #end class __ASSET__assets_test_stuff_from_shmood_walk__hands_free__walk0015_png extends lime.graphics.Image {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end