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



class Design_8_8_NPCWanderPM extends ActorScript
{          	
	
public var _GoalX:Float;

public var _GoalY:Float;

public var _GoalList:Array<Dynamic>;

public var _PlaceRandomly:Bool;

public var _XPosition:Float;

public var _YPosition:Float;

public var _IsInitialised:Bool;

public var _Path:Array<Dynamic>;

public var _LocalCollisionMap:Array<Dynamic>;

public var _MapWidth:Float;

public var _MapHeight:Float;

public var _HasDestination:Bool;

public var _FrameCount:Float;

public var _AllowWander:Bool;

public var _FramesPerMove:Float;
    

/* Params are: */
public function _customBlock_GetXDistanceToGoal():Float
{
var __Self:Actor = actor;
        return Math.abs((_GoalX - _XPosition));
}
    

/* Params are: */
public function _customBlock_GetYDistanceToGoal():Float
{
var __Self:Actor = actor;
        return Math.abs((_GoalY - _YPosition));
}
    

/* Params are: */
public function _customBlock_GetXVectorToGoal():Float
{
var __Self:Actor = actor;
        if(((_GoalX - _XPosition) < 0))
{
            return -1;
}

        else if(((_GoalX - _YPosition) > 0))
{
            return 1;
}

        return 0;
}
    

/* Params are: */
public function _customBlock_GetYGoalVector():Float
{
var __Self:Actor = actor;
        if(((_GoalY - _YPosition) < 0))
{
            return -1;
}

        else if(((_GoalY - _YPosition) > 0))
{
            return 1;
}

        return 0;
}

 
 	public function new(dummy:Int, actor:Actor, engine:Engine)
	{
		super(actor, engine);	
		nameMap.set("Goal X", "_GoalX");
_GoalX = -1.0;
nameMap.set("Goal Y", "_GoalY");
_GoalY = -1.0;
nameMap.set("Goal List", "_GoalList");
_GoalList = [];
nameMap.set("Place Randomly?", "_PlaceRandomly");
_PlaceRandomly = false;
nameMap.set("X Position", "_XPosition");
_XPosition = 0.0;
nameMap.set("Y Position", "_YPosition");
_YPosition = 0.0;
nameMap.set("Is Initialised?", "_IsInitialised");
_IsInitialised = false;
nameMap.set("Path", "_Path");
_Path = [];
nameMap.set("Local Collision Map", "_LocalCollisionMap");
_LocalCollisionMap = [];
nameMap.set("Map Width", "_MapWidth");
_MapWidth = 0.0;
nameMap.set("Map Height", "_MapHeight");
_MapHeight = 0.0;
nameMap.set("Has Destination?", "_HasDestination");
_HasDestination = false;
nameMap.set("Actor", "actor");
nameMap.set("Frame Count", "_FrameCount");
_FrameCount = 0.0;
nameMap.set("Allow Wander?", "_AllowWander");
_AllowWander = false;
nameMap.set("Frames Per Move", "_FramesPerMove");
_FramesPerMove = 15.0;

	}
	
	override public function init()
	{
		            if(_PlaceRandomly)
{
            _GoalList = cast((sayToScene("Maze PM", "_customBlock_GetRandomEmptySquare")), Array<Dynamic>);
propertyChanged("_GoalList", _GoalList);
            _XPosition = asNumber(_GoalList[Std.int(0)]);
propertyChanged("_XPosition", _XPosition);
            _YPosition = asNumber(_GoalList[Std.int(1)]);
propertyChanged("_YPosition", _YPosition);
            actor.setValue("Block Map Character PM", "_XPosition", _XPosition);
            actor.setValue("Block Map Character PM", "_YPosition", _YPosition);
}

        sayToScene("Maze PM", "_customBlock_AddCharacter", [actor]);
    addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
if(wrapper.enabled){
        _XPosition = asNumber(actor.getValue("Block Map Character PM", "_XPosition"));
propertyChanged("_XPosition", _XPosition);
        _YPosition = asNumber(actor.getValue("Block Map Character PM", "_YPosition"));
propertyChanged("_YPosition", _YPosition);
        sayToScene("Maze PM", "_customBlock_ClearCharacterCollision", [_XPosition,_YPosition]);
        if(((_XPosition == _GoalX) && (_YPosition == _GoalY)))
{
            _HasDestination = false;
propertyChanged("_HasDestination", _HasDestination);
}

        if(!(_HasDestination))
{
            _HasDestination = true;
propertyChanged("_HasDestination", _HasDestination);
            _GoalList = cast((sayToScene("Maze PM", "_customBlock_GetRandomEmptySquare")), Array<Dynamic>);
propertyChanged("_GoalList", _GoalList);
            _GoalX = asNumber(_GoalList[Std.int(0)]);
propertyChanged("_GoalX", _GoalX);
            _GoalY = asNumber(_GoalList[Std.int(1)]);
propertyChanged("_GoalY", _GoalY);
            _Path = new Array<Dynamic>();
propertyChanged("_Path", _Path);
            runLater(1000 * 3, function(timeTask:TimedTask):Void {
                        _LocalCollisionMap = getGameAttribute("Maze");
propertyChanged("_LocalCollisionMap", _LocalCollisionMap);
                        _MapWidth = asNumber(getValueForScene("Maze PM", "_MaxX"));
propertyChanged("_MapWidth", _MapWidth);
                        _MapHeight = asNumber(getValueForScene("Maze PM", "_MaxY"));
propertyChanged("_MapHeight", _MapHeight);
                        _Path = scripts.AStarPathFinder.getAStarPath(_LocalCollisionMap, Std.int(_MapWidth), Std.int(_MapHeight), Std.int(_XPosition), Std.int(_YPosition), Std.int(_GoalX), Std.int(_GoalY), false);
propertyChanged("_Path", _Path);
}, actor);
}

        if(((_FrameCount > _FramesPerMove) && _AllowWander))
{
            _FrameCount = asNumber(0);
propertyChanged("_FrameCount", _FrameCount);
            if(((hasValue(_Path) != false) && (_Path.length > 0)))
{
                var nextNode = _Path.pop();
                _XPosition = asNumber(nextNode.x);
propertyChanged("_XPosition", _XPosition);
                _YPosition = asNumber(nextNode.y);
propertyChanged("_YPosition", _YPosition);
}

}

        else
{
            _FrameCount += 1;
propertyChanged("_FrameCount", _FrameCount);
}

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