package net.tankmas;

import net.core.Client;
import net.tankmas.NetDefs;


class TankmasClient
{
	static var address:String = #if test_local 'http://127.0.0.1:5000' #else "http://78.108.218.30:25567" #end;

	public static function get_users_in_room(room_id:String, ?on_complete:Dynamic->Void)
	{
		var url:String = '$address/rooms/$room_id/users';

		Client.get(url, on_complete);
	}

	public static function post_user(room_id:String, user:NetUserDef, ?on_complete:Dynamic->Void)
	{
		var url:String = '$address/rooms/$room_id/users';

		Client.post(url, user, on_complete);
	}
	public static function get_events(room_id:String, ?on_complete:Dynamic->Void)
	{
		var url:String = '$address/rooms/$room_id/events/get';

		Client.post(url, {username: Main.username}, on_complete);
	}

	public static function post_event(room_id:String, event:NetEventDef, ?on_complete:Dynamic->Void)
	{
		var url:String = '$address/rooms/$room_id/events/post';

		Client.post(url, event, on_complete);
	}
}