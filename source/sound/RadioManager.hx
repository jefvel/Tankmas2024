package sound;

typedef RadioSegment =
{
	var type:RadioSegmentType;
	var parts:Array<String>;
	var ?follow_up:RadioSegmentType;
}

enum abstract RadioSegmentType(String) from String to String
{
	var AD = 'ad';
	var NEWS = 'news';
	var MUSIC = 'music';
	var SHOTGUN = 'shotgun';
}

class RadioManager
{
	var current_segment:RadioSegment;
	var sounds:Map<String, Array<String>> = [];
	var next_music_followup:RadioSegmentType = AD;
	var current_sound:FlxSound;

	var next_music_track:String = "chaoz-fantasy";

	final sound_categories:Array<String> = [
		'ad-intro-',
		'ad-main-',
		'ad-outro-',
		'music-chaoz-fantasy-intro-',
		'music-chaoz-fantasy-main-',
		'music-chaoz-fantasy-outro-',
		'news-A-main-',
		'news-A-followup-',
		'news-A-intro-',
		'news-A-outro-',
		'shotgun-'
	];

	var ran:FlxRandom;

	public function new()
	{
		ran = new FlxRandom();
		current_segment = make_segment(MUSIC);
        update();
	}

	public function update()
	{
		if (current_sound == null)
		{
			if (current_segment == null || current_segment.parts.length == 0)
				current_segment = make_segment(current_segment.follow_up);
			var next_sound:String = current_segment.parts.shift();
            #if trace_radio  trace("PLAYING ", next_sound); #end
			current_sound = SoundPlayer.sound(next_sound);
			current_sound.onComplete = end_sound;
		}
	}

	public function end_sound()
	{
		current_sound = null;
		update();
	}

	public function manage_sounds_array()
		for (category in sound_categories)
			if (!sounds.exists(category) || sounds.get(category).length == 0)
			{
				sounds.set(category, Paths.get_every_file_of_type('.ogg', 'assets', category));
				ran.shuffle(sounds.get(category));
			}

	function get_part(part_name:String){
        #if trace_radio trace(part_name, sounds.get(part_name)); #end
		return sounds.get(part_name).pop();
    }

	function make_segment(type:RadioSegmentType):RadioSegment
	{
		manage_sounds_array();
		var segment:RadioSegment = {type: type, parts: []};
		switch (segment.type)
		{
			case SHOTGUN:
				segment = make_shotgun(segment);
			case AD:
				segment = make_ad(segment);
			case NEWS:
				segment = make_news(segment);
			case MUSIC:
				segment = make_music(segment);
		}

		return segment;
	}

	function make_shotgun(segment:RadioSegment):RadioSegment
	{
		segment.parts = [get_part("shotgun-")];
		segment.follow_up = MUSIC;
		return segment;
	}

	function make_music(segment:RadioSegment):RadioSegment
	{
		var n:String = next_music_track;
		segment.parts = [
			get_part('music-$n-intro-'),
			get_part('music-$n-main-'),
			next_music_track,
			get_part('music-$n-outro-')
		];
		segment.follow_up = next_music_followup;
		next_music_followup == AD ? NEWS : AD;
		return segment;
	}

	function make_news(segment:RadioSegment):RadioSegment
	{
		var n:String = 'A';
		segment.parts = [get_part('news-$n-intro-'), get_part('news-$n-main-'), get_part('news-$n-outro-')];
		segment.follow_up = SHOTGUN;
		return segment;
	}

	function make_ad(segment:RadioSegment):RadioSegment
	{
		segment.parts = [get_part('ad-intro-'), get_part('ad-main-'), get_part('ad-outro-')];
		segment.follow_up = SHOTGUN;
		return segment;
	}
}
