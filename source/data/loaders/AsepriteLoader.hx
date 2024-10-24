package data.loaders;

#if sys
import ase.Ase;
import ase.chunks.SliceChunk.SliceKey;
import ase.chunks.SliceChunk;
import ase.chunks.UserDataChunk;
import data.loaders.AsepriteDefs.AsepriteFrame;
import data.loaders.AsepriteDefs.AsepriteFrameTag;
import data.loaders.AsepriteDefs.AsepriteJSON;
import flixel.graphics.FlxAsepriteUtil;
import haxe.io.Bytes;
import json2object.JsonParser;
import openfl.Assets;
import sys.FileSystem;
import sys.io.File;

/**
 * Aseprite Loaders, moved from Lists.hx
 * 
**/
class AsepriteLoader
{
	static final LOOPING_COLOR:Int = -870057;
	static final NON_LOOPING_COLOR:Int = 6016362;
	static final VARIABLE_COLOR:Int = 4695543;

	static final LOOPING_COLOR_STRING:String = "#57b9f2ff";
	static final NON_LOOPING_COLOR_STRING:String = "#6acd5bff";
	static final VARIABLE_COLOR_STRING:String = "#f7a547";

	public static function load_anim_set_from_xml(?image:String, ?images:Array<String>, write_to_file:Bool = false):String
	{
		var full_result:String = "";

		if (image != null && images != null)
			throw "json_to_aseprite error: image or images not both >:-(";

		if (image == null && images == null)
			throw "json_to_aseprite error: both image and images are null >:-(";

		images = images == null ? [image] : images;

		for (image in images)
		{
			var file_name:String = image.indexOf("aseprite") == -1 ? image + ".aseprite" : image;
			var file_path:String = Paths.get(file_name);

			var data:Bytes = File.getBytes(file_path);

			trace(file_path, data.length, data);

			var ase:Ase = Ase.fromBytes(data);

			var anim_set_xml:String = get_anim_set_xml_from_ase(ase, image);
			full_result = '${full_result}\n${anim_set_xml}\n';

			trace(write_to_file, Lists.animSets.get(image) == null);

			if (write_to_file && Lists.animSets.get(image) == null)
			{
				var subdir:String = Paths.get(file_name).split("/")[3];
				var assets_path:String = "../../../assets";

				var xml_file_path:String = 'data/anims/general-anims.xml';

				var local_file_path:String = 'assets/${xml_file_path}';
				var root_target_file_path:String = '${assets_path}/${xml_file_path}';

				trace(root_target_file_path, FileSystem.exists(root_target_file_path), local_file_path, FileSystem.exists(local_file_path));

				// root_target_file_path = root_target_file_path.replace("data/entries", "data/entries/anim");

				var formatted_xml:String = "";
				var xml_array:Array<String> = anim_set_xml.split("\n");

				for (n in 0...xml_array.length)
				{
					xml_array[n] = '\t${xml_array[n]}';
					if (n > 0 && n < xml_array.length - 1)
						xml_array[n] = '\t${xml_array[n]}';
					formatted_xml = formatted_xml + "\n" + xml_array[n];
				}

				var content:String = FileSystem.exists(root_target_file_path) ? sys.io.File.getContent(root_target_file_path) : "<root>\n</root>";
				var add_index:Int = content.indexOf("</root>");

				content = content.substr(0, add_index) + '${formatted_xml}\n</root>';

				Lists.load_anim_set_from_xml(anim_set_xml.string_to_xml().firstElement(), image);

				#if !aseprite_test
				try
				{
					save_aseprite_to_xml(root_target_file_path, local_file_path, content);
				}
				catch (e)
				{
					trace('\n\nNOTICE!!!\naseprite_to_xml(): Creating xml file ${root_target_file_path}\n');
					save_aseprite_to_xml(root_target_file_path, local_file_path, content);
				}
				#else
				trace(formatted_xml);
				#end

				trace('\n\nNOTICE!!!\naseprite_to_xml(): Wrote ${image} to ${root_target_file_path}\n');
			}
		}

		return full_result;
	}

	static function get_anim_set_xml_from_ase(ase:Ase, image_name:String):String
	{
		var anim_set_xml:String = "";
		var anim_set_xml_array:Array<String> = [];
		var replace_words:Array<String> = [];

		var frame_variables:Map<String, Array<Int>> = [];

		var inline_data:String = "";

		var hitbox_data:String = "";

		var auto_offset_data:String = "";

		for (chunk in ase.frames[0].chunks)
			switch (chunk.header.type)
			{
				default:
				case TAGS:
					for (frameTag in cast(chunk, ase.chunks.TagsChunk).tags)
					{
						// trace(frameTag.tagName, frameTag.tagColor, frameTag.tagColor == VARIABLE_COLOR);
						if (frameTag.tagColor == LOOPING_COLOR || frameTag.tagColor == NON_LOOPING_COLOR)
							anim_set_xml_array.push(xml_from_frame_tag(ase, frameTag, ase.frames));
						if (frameTag.tagColor == VARIABLE_COLOR)
							frame_variables = variable_frames_from_frame_tag(frame_variables, frameTag);
					}
				case USER_DATA:
					var user_data:UserDataChunk = cast(chunk, UserDataChunk);
					if (user_data.hasText)
						replace_words.push(user_data.text);
				case SLICE:
					var slice:SliceChunk = cast(chunk, SliceChunk);
					var key:SliceKey = slice.sliceKeys[0];
					switch (slice.name)
					{
						case "hitbox":
							hitbox_data = ' hitbox="${key.width},${key.height}"';
							auto_offset_data = ' offset="${key.xOrigin},${key.yOrigin}"';
						case "offset_left" | "left":
							inline_data = inline_data + ' offset_left="${key.width},${key.height}"';
							auto_offset_data = "";
						case "offset_right" | "right":
							inline_data = inline_data + ' offset_right="${key.width},${key.height}"';
							auto_offset_data = "";
					}
			}

		if (auto_offset_data != "")
			inline_data = inline_data + auto_offset_data;

		inline_data = hitbox_data + inline_data;

		trace(inline_data);
		trace(frame_variables);
		// trace(anim_set_xml);
		// trace(replace_words);

		var replace_index:Int = 0;

		for (n in 0...anim_set_xml_array.length)
			for (replace_char in ["!", "?"])
				if (anim_set_xml_array[n].contains('name=\"$replace_char\"'))
				{
					var new_xml:String = anim_set_xml_array[n].replace(replace_char, replace_words[replace_index]);
					// trace('WORD: ${replace_words[replace_index]}\nPRE: ${anim_set_xml_array[n]}\nPOST: $new_xml');
					anim_set_xml_array[n] = new_xml;
					replace_index++;
					continue;
				}

		for (variable_name in frame_variables.keys())
		{
			var frames:String = frame_variables.get(variable_name).toString();
			frames = frames.substring(1, frames.length - 1);

			anim_set_xml_array.push('<variable name="$variable_name" frames="$frames"/>');
		}

		anim_set_xml = '\n' + anim_set_xml_array.join('\n');

		return '<animSet image="${image_name}"$inline_data>${anim_set_xml}\n</animSet>';
	}

	static function variable_frames_from_frame_tag(frame_variables:Map<String, Array<Int>>, frameTag:ase.chunks.TagsChunk.Tag):Map<String, Array<Int>>
	{
		var name:String = frameTag.tagName;

		if (frame_variables.get(name) == null)
			frame_variables.set(name, []);

		for (frame in frameTag.fromFrame...frameTag.toFrame + 1)
			if (frame_variables.get(name).indexOf(frame) <= -1)
				frame_variables.get(name).push(frame);

		haxe.ds.ArraySort.sort(frame_variables.get(name), function(a, b):Int
		{
			return a - b;
		});

		trace(name, frame_variables.get(name));

		return frame_variables;
	}

	static function xml_from_frame_tag(ase:Ase, frameTag:ase.chunks.TagsChunk.Tag, ase_frames:Array<ase.Frame>):String
	{
		var xml:String = '<anim';

		var name_split:Array<String> = frameTag.tagName.split(" ");
		var args:String = frameTag.tagName.substring(name_split[0].length, frameTag.tagName.length);

		args = args.replace("-> ", "->").replace(" -> ", "->");

		var name:String = name_split[0];

		// grab fps by default from sprite
		var fps_int:Int = ase.frames[frameTag.fromFrame].duration;
		var fps:String = '${fps_int}ms';
		fps = fps == "70ms" ? "" : fps;

		var repeats:String = "";
		var link:String = "";

		if (args.length > -1)
		{
			// fps = args.str_substring_within_brackets(["fps", "ms"]);
			link = args.str_substring("->", " ");
			repeats = args.str_substring_within_brackets("r");
		}

		xml = '${xml} name="${name}"';

		// trace(frameTag.name, name, fps, link, repeats);
		if (fps != null && fps != "")
			xml = '${xml} fps="${fps}"';

		if (link != null && link != "")
			xml = '${xml} link="${link.replace("->", "")}"';

		if (frameTag.tagColor == NON_LOOPING_COLOR)
			xml = '${xml} looping="false"';

		/*
			for (n in frameTag.fromFrame...frameTag.toFrame)
				if (ase_frames[n].duration > fps_int)
				{
					var hold:Int = [];
				}
		 */

		var frames:String = frameTag.fromFrame != frameTag.toFrame ? '${frameTag.fromFrame}t${frameTag.toFrame}' : '${frameTag.fromFrame}';

		if (repeats != null && repeats != "")
			frames += repeats;

		trace(xml);
		return '${xml}>${frames}</anim>';
	}

	/*
		public static function int_array_to_frames_string(arr:Array<Int>):String
		{
			var result:String = "";
			var last:Int = -1;
			var chain_begin:Int = -1;
			var NEW_GROUP:Bool = true;

			if (arr.length == 1)
				return '${arr[0]}';

			while (arr.length > 0)
			{
				var i:Int = arr[0];
				var PREV_IS_REPEAT:Bool = last == i;
				var NEXT_IS_REPEAT:Bool = arr.length > 1 && arr[0] == i;
				var ONE_MORE:Bool = last > -1 && i == last + 1 && !NEXT_IS_REPEAT;

				if (!FIRST)
				{
					if (!ONE_MORE && chain_begin != -1)
					{
						chain_begin = -1;
						NEW_GROUP = true;
					}

					if (NEW_GROUP)
						last = i;
				}

				arr.pop();
			}

			return result;
		}
	 */
	static function save_aseprite_to_xml(root_target_file_path:String, local_file_path:String, content:String)
		try
		{
			sys.io.File.saveContent(root_target_file_path, content);
			Sys.sleep(.25);
			sys.io.File.saveContent(local_file_path, content);
			Sys.sleep(.25);
			// Sys.command('code $root_target_file_path');
		}
		catch (e)
		{
			trace("Couldn't save aseprite_to_xml");
			trace(content);
		}

	static function json_to_aseprite(?image:String, ?images:Array<String>):String
	{
		var result:String = "";

		if (image != null && images != null)
			throw "json_to_aseprite error: image or images not both >:-(";

		if (image == null && images == null)
			throw "json_to_aseprite error: both image and images are null >:-(";

		images = images == null ? [image] : images;

		for (image in images)
		{
			var file_name:String = image.indexOf("json") == -1 ? image + ".json" : image;
			var file_path:String = Paths.get(file_name);

			var parser:JsonParser<AsepriteJSON> = new JsonParser<AsepriteJSON>();
			parser.fromJson(Utils.load_file_string(file_path), "errors.txt");

			var xml:String = '<animSet image="${image}">';

			for (frameTag in parser.value.meta.frameTags)
				if (frameTag.color == NON_LOOPING_COLOR_STRING || frameTag.color == LOOPING_COLOR_STRING)
				{
					xml = '${xml}\n<anim';

					var name_split:Array<String> = frameTag.name.split(" ");
					var args:String = frameTag.name.substring(name_split[0].length, frameTag.name.length).replace("-> ", "->").replace(" -> ", "->");

					var name:String = name_split[0];

					// grab fps by default from sprite
					var fps:String = '${parser.value.frames.get('${image} ${frameTag.from}.aseprite').duration}ms';
					fps = fps == "70ms" ? "" : fps;

					var repeats:String = "";
					var link:String = "";

					if (args.length > -1)
					{
						// fps = args.str_substring_within_brackets(["fps", "ms"]);
						link = args.str_substring("->", " ");
						repeats = args.str_substring_within_brackets("r");
					}

					xml = '${xml} name="${name}"';

					// trace(frameTag.name, name, fps, link, repeats);
					if (fps != null && fps != "")
						xml = '${xml} fps="${fps}"';

					if (link != null && link != "")
						xml = '${xml} link="${link.replace("->", "")}"';

					if (frameTag.color == NON_LOOPING_COLOR_STRING)
						xml = '${xml} looping="false"';

					var frames:String = frameTag.from != frameTag.to ? '${frameTag.from}t${frameTag.to}' : '${frameTag.from}';
					if (repeats != null && repeats != "")
						frames += repeats;

					xml = '${xml}>${frames}</anim>';
				}

			var xml:String = '${xml}\n</animSet>';

			result = '${result}\n${xml}\n';
		}

		return result;
	}
}
#end
