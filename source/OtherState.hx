package;

import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxState;

class OtherState extends FlxState{

    override public function create(){

        var button = new FlxButton(0,0, "Switch States", switchState);
        add(button);
        
    }

    // override public function update(elapsed:Float){

    //     super.update();
    // }

    private function switchState():Void{

		FlxG.switchState(new PlayState());
	}

}