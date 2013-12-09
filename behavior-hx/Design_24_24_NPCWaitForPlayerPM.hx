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



class Design_24_24_NPCWaitForPlayerPM extends ActorScript
{          	
	
public var _Player:Actor;

public var _XDistance:Float;

public var _YDistance:Float;

public var _WaitDistance:Float;

 
 	public function new(dummy:Int, actor:Actor, engine:Engine)
	{
		super(actor, engine);	
		nameMap.set("Player", "_Player");
nameMap.set("X Distance", "_XDistance");
_XDistance = 0.0;
nameMap.set("Y Distance", "_YDistance");
_YDistance = 0.0;
nameMap.set("Wait Distance", "_WaitDistance");
_WaitDistance = 5.0;
nameMap.set("Actor", "actor");

	}
	
	override public function init()
	{
		    addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
if(wrapper.enabled){
        if((hasValue(_Player) != false))
{
            _XDistance = asNumber((_Player.getValue("Block Map Character PM", "_XPosition") - actor.getValue("Block Map Character PM", "_XPosition")));
propertyChanged("_XDistance", _XDistance);
            _YDistance = asNumber((_Player.getValue("Block Map Character PM", "_YPosition") - actor.getValue("Block Map Character PM", "_YPosition")));
propertyChanged("_YDistance", _YDistance);
            if((((_XDistance * _XDistance) + (_YDistance * _YDistance)) < (_WaitDistance * _WaitDistance)))
{
                actor.setValue("NPC Wander PM", "_AllowWander", false);
}

            else
{
                actor.setValue("NPC Wander PM", "_AllowWander", true);
}

}

}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}