package scripts;

import com.stencyl.graphics.G;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.utils.Utils;

import nme.ui.Mouse;
import nme.display.Graphics;
import nme.display.BlendMode;
import nme.events.Event;
import nme.events.TouchEvent;
import nme.net.URLLoader;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;



class Design_3_3_KeyboardControlsPM extends ActorScript
{          	
	
public var _XPosition:Float;

public var _YPosition:Float;

public var _XOffset:Float;

public var _YOffset:Float;

public var _FramesPerMove:Float;

public var _FrameCount:Float;

public var _IsInitialised:Bool;

 
 	public function new(dummy:Int, actor:Actor, engine:Engine)
	{
		super(actor, engine);	
		nameMap.set("X Position", "_XPosition");
_XPosition = 0.0;
nameMap.set("Y Position", "_YPosition");
_YPosition = 0.0;
nameMap.set("X Offset", "_XOffset");
_XOffset = 0.0;
nameMap.set("Y Offset", "_YOffset");
_YOffset = 0.0;
nameMap.set("Frames Per Move", "_FramesPerMove");
_FramesPerMove = 10.0;
nameMap.set("Frame Count", "_FrameCount");
_FrameCount = 0.0;
nameMap.set("Is Initialised?", "_IsInitialised");
_IsInitialised = false;
nameMap.set("Actor", "actor");

	}
	
	override public function init()
	{
		            _FrameCount = asNumber(0);
propertyChanged("_FrameCount", _FrameCount);
        sayToScene("Maze PM", "_customBlock_AddCharacter", [actor]);
    addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
if(wrapper.enabled){
        _XPosition = asNumber(actor.getValue("Block Map Character PM", "_XPosition"));
propertyChanged("_XPosition", _XPosition);
        _YPosition = asNumber(actor.getValue("Block Map Character PM", "_YPosition"));
propertyChanged("_YPosition", _YPosition);
        _XOffset = asNumber(0);
propertyChanged("_XOffset", _XOffset);
        _YOffset = asNumber(0);
propertyChanged("_YOffset", _YOffset);
        if(isKeyDown("left"))
{
            _XOffset -= 1;
propertyChanged("_XOffset", _XOffset);
}

        if(isKeyDown("right"))
{
            _XOffset += 1;
propertyChanged("_XOffset", _XOffset);
}

        if(isKeyDown("up"))
{
            _YOffset -= 1;
propertyChanged("_YOffset", _YOffset);
}

        if(isKeyDown("down"))
{
            _YOffset += 1;
propertyChanged("_YOffset", _YOffset);
}

        if(((_XOffset == 0) && (_YOffset == 0)))
{
            _FrameCount = asNumber(0);
propertyChanged("_FrameCount", _FrameCount);
}

        if((_FrameCount == _FramesPerMove))
{
            _FrameCount = asNumber(0);
propertyChanged("_FrameCount", _FrameCount);
            if(cast((sayToScene("Maze PM", "_customBlock_CanMoveIntoTile", [(_XPosition + _XOffset),(_YPosition + _YOffset)])), Bool))
{
                sayToScene("Maze PM", "_customBlock_ClearCharacterCollision", [_XPosition,_YPosition]);
                _XPosition = asNumber((_XPosition + _XOffset));
propertyChanged("_XPosition", _XPosition);
                _YPosition = asNumber((_YPosition + _YOffset));
propertyChanged("_YPosition", _YPosition);
}

}

        else
{
            _FrameCount += 1;
propertyChanged("_FrameCount", _FrameCount);
}

        sayToScene("Maze PM", "_customBlock_SetOffsets", [_XPosition,_YPosition]);
        sayToScene("Maze PM", "_customBlock_AddCharacterCollision", [_XPosition,_YPosition]);
        actor.setValue("Block Map Character PM", "_XPosition", _XPosition);
        actor.setValue("Block Map Character PM", "_YPosition", _YPosition);
}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}