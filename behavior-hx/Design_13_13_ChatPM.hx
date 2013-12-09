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



class Design_13_13_ChatPM extends ActorScript
{          	
	
public var _Chatee:Actor;

public var _DialogBox:Actor;

public var _IsChatting:Bool;

 
 	public function new(dummy:Int, actor:Actor, engine:Engine)
	{
		super(actor, engine);	
		nameMap.set("Chatee", "_Chatee");
nameMap.set("Dialog Box", "_DialogBox");
nameMap.set("Is Chatting?", "_IsChatting");
_IsChatting = false;
nameMap.set("Actor", "actor");

	}
	
	override public function init()
	{
		    addKeyStateListener("action1", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void {
if(wrapper.enabled && pressed){
        _Chatee = cast((sayToScene("Maze PM", "_customBlock_GetChatee", [actor])), Actor);
propertyChanged("_Chatee", _Chatee);
        if((hasValue(_Chatee) != false))
{
            _DialogBox.say("Dialog Box PM", "_customBlock_Display", [_Chatee.getValue("Chatee PM", "_Portrait"),_Chatee.getValue("Chatee PM", "_Name"),_Chatee.getValue("Chatee PM", "_Bio"),"Can I be of assistance?"]);
            _IsChatting = true;
propertyChanged("_IsChatting", _IsChatting);
}

}
});
    addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
if(wrapper.enabled){
        if(_IsChatting)
{
            _Chatee = cast((sayToScene("Maze PM", "_customBlock_GetChatee", [actor])), Actor);
propertyChanged("_Chatee", _Chatee);
            if(!((hasValue(_Chatee) != false)))
{
                _IsChatting = false;
propertyChanged("_IsChatting", _IsChatting);
                _DialogBox.say("Dialog Box PM", "_customBlock_Hide");
}

}

}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}