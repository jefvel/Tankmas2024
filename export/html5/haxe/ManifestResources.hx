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
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_newgrounds_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		data = '{"name":null,"assets":"aoy4:pathy41:assets%2Fart%2FDailyArt%2Fthedyingsun.pngy4:sizei4292431y4:typey5:IMAGEy2:idR1y7:preloadtgoR0y48:assets%2Fart%2FDailyArt%2Fthedyingsun.png.importR2i779R3y4:TEXTR5R7R6tgoR0y41:assets%2Fdata%2Fanims%2Fgeneral-anims.xmlR2i155R3R8R5R9R6tgoR0y46:assets%2Fdata%2Fconfig%2Fcontrols%2Fplyrc1.txtR2i38R3R8R5R10R6tgoR0y46:assets%2Fdata%2Fconfig%2Fcontrols%2Fplyrc2.txtR2i27R3R8R5R11R6tgoR0y46:assets%2Fdata%2Fconfig%2Fcontrols%2Fplyrc3.txtR2i27R3R8R5R12R6tgoR0y46:assets%2Fdata%2Fconfig%2Fcontrols%2Fplyrc4.txtR2i32R3R8R5R13R6tgoR0y34:assets%2Fdata%2Fdata-goes-here.txtR2zR3R8R5R14R6tgoR2i20936R3y4:FONTy9:classNamey36:__ASSET__assets_fonts_newgrounds_ttfR5y31:assets%2Ffonts%2Fnewgrounds.ttfR6tgoR0y40:assets%2Ffonts%2Fpixelmplus10-bitmap.pngR2i74611R3R4R5R19R6tgoR0y36:assets%2Fimages%2Fimages-go-here.txtR2zR3R8R5R20R6tgoR0y36:assets%2Fmusic%2Fmusic-goes-here.txtR2zR3R8R5R21R6tgoR2i3005383R3y5:MUSICR5y54:assets%2Fmusic%2Frudolftehrednosereindeer_littlbox.mp3y9:pathGroupaR23hR6tgoR2i2910110R3R22R5y47:assets%2Fmusic%2Fsadgamertime_ninjamuffin99.mp3R24aR25hR6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R8R5R26R6tgoR2i8220R3R22R5y26:flixel%2Fsounds%2Fbeep.mp3R24aR27y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i39706R3R22R5y28:flixel%2Fsounds%2Fflixel.mp3R24aR29y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i6840R3y5:SOUNDR5R28R24aR27R28hgoR2i33629R3R31R5R30R24aR29R30hgoR2i15744R3R15R16y35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R15R16y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i277R3R4R5R36R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i505R3R4R5R37R6tgoR0y42:flixel%2Fimages%2Ftransitions%2Fcircle.pngR2i824R3R4R5R38R6tgoR0y53:flixel%2Fimages%2Ftransitions%2Fdiagonal_gradient.pngR2i3812R3R4R5R39R6tgoR0y43:flixel%2Fimages%2Ftransitions%2Fdiamond.pngR2i788R3R4R5R40R6tgoR0y42:flixel%2Fimages%2Ftransitions%2Fsquare.pngR2i383R3R4R5R41R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
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
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_anims_general_anims_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_config_controls_plyrc1_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_config_controls_plyrc2_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_config_controls_plyrc3_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_config_controls_plyrc4_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_newgrounds_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_pixelmplus10_bitmap_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_rudolftehrednosereindeer_littlbox_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_sadgamertime_ninjamuffin99_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_circle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_diagonal_gradient_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_diamond_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_square_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:image("assets/art/DailyArt/thedyingsun.png") @:noCompletion #if display private #end class __ASSET__assets_art_dailyart_thedyingsun_png extends lime.graphics.Image {}
@:keep @:file("assets/art/DailyArt/thedyingsun.png.import") @:noCompletion #if display private #end class __ASSET__assets_art_dailyart_thedyingsun_png_import extends haxe.io.Bytes {}
@:keep @:file("assets/data/anims/general-anims.xml") @:noCompletion #if display private #end class __ASSET__assets_data_anims_general_anims_xml extends haxe.io.Bytes {}
@:keep @:file("assets/data/config/controls/plyrc1.txt") @:noCompletion #if display private #end class __ASSET__assets_data_config_controls_plyrc1_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/config/controls/plyrc2.txt") @:noCompletion #if display private #end class __ASSET__assets_data_config_controls_plyrc2_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/config/controls/plyrc3.txt") @:noCompletion #if display private #end class __ASSET__assets_data_config_controls_plyrc3_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/config/controls/plyrc4.txt") @:noCompletion #if display private #end class __ASSET__assets_data_config_controls_plyrc4_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/data-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/newgrounds.ttf") @:noCompletion #if display private #end class __ASSET__assets_fonts_newgrounds_ttf extends lime.text.Font {}
@:keep @:image("assets/fonts/pixelmplus10-bitmap.png") @:noCompletion #if display private #end class __ASSET__assets_fonts_pixelmplus10_bitmap_png extends lime.graphics.Image {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/music/rudolftehrednosereindeer_littlbox.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_rudolftehrednosereindeer_littlbox_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/music/sadgamertime_ninjamuffin99.mp3") @:noCompletion #if display private #end class __ASSET__assets_music_sadgamertime_ninjamuffin99_mp3 extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/5,8,0/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-addons/3,2,3/assets/images/transitions/circle.png") @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_circle_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-addons/3,2,3/assets/images/transitions/diagonal_gradient.png") @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_diagonal_gradient_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-addons/3,2,3/assets/images/transitions/diamond.png") @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_diamond_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel-addons/3,2,3/assets/images/transitions/square.png") @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_square_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__assets_fonts_newgrounds_ttf') @:noCompletion #if display private #end class __ASSET__assets_fonts_newgrounds_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/newgrounds"; #else ascender = 2633; descender = -877; height = 3510; numGlyphs = 150; underlinePosition = 153; underlineThickness = 102; unitsPerEM = 2048; #end name = "Newgrounds Logo Regular"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__assets_fonts_newgrounds_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_newgrounds_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_newgrounds_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__assets_fonts_newgrounds_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_newgrounds_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_newgrounds_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end