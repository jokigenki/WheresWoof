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



class Design_19_19_DialogBoxPM extends ActorScript
{          	
	
public var _Portrait:Actor;

public var _NameText:String;

public var _BioText:String;

public var _SpeechText:String;

public var _NameLabel:Actor;

public var _BioLabel:Actor;

public var _SpeechLabel:Actor;

public var _TitleFont:Font;

public var _BioFont:Font;

public var _SpeechFont:Font;
    

/* Params are:__Self __Portrait __Name __Bio __Speech */
public function _customBlock_Display(__Portrait:ActorType, __Name:String, __Bio:String, __Speech:String):Void
{
var __Self:Actor = actor;
        actor.enableActorDrawing();
        if((hasValue(_Portrait) != false))
{
            recycleActor(_Portrait);
}

        if((hasValue(_NameLabel) != false))
{
            recycleActor(_NameLabel);
}

        if((hasValue(_BioLabel) != false))
{
            recycleActor(_BioLabel);
}

        if((hasValue(_SpeechLabel) != false))
{
            recycleActor(_SpeechLabel);
}

        createRecycledActor(__Portrait, (actor.getX() + 10), (actor.getY() + 10), Script.FRONT);
        _Portrait = getLastCreatedActor();
propertyChanged("_Portrait", _Portrait);
        createRecycledActor(getActorType(61), (actor.getX() + 68), (actor.getY() + 12), Script.FRONT);
        _NameLabel = getLastCreatedActor();
propertyChanged("_NameLabel", _NameLabel);
        _NameLabel.setValue("Label PM", "_Font", _TitleFont);
        _NameLabel.setValue("Label PM", "_TextToDraw", __Name);
        createRecycledActor(getActorType(61), (actor.getX() + 68), (actor.getY() + 22), Script.FRONT);
        _BioLabel = getLastCreatedActor();
propertyChanged("_BioLabel", _BioLabel);
        _BioLabel.setValue("Label PM", "_Font", _BioFont);
        _BioLabel.setValue("Label PM", "_TextToDraw", __Bio);
        createRecycledActor(getActorType(61), (actor.getX() + 12), (actor.getY() + 68), Script.FRONT);
        _SpeechLabel = getLastCreatedActor();
propertyChanged("_SpeechLabel", _SpeechLabel);
        _SpeechLabel.setValue("Label PM", "_Font", _SpeechFont);
        _SpeechLabel.setValue("Label PM", "_TextToDraw", __Speech);
}
    

/* Params are:__Self */
public function _customBlock_Hide():Void
{
var __Self:Actor = actor;
        actor.disableActorDrawing();
        if((hasValue(_Portrait) != false))
{
            recycleActor(_Portrait);
}

        if((hasValue(_NameLabel) != false))
{
            recycleActor(_NameLabel);
}

        if((hasValue(_BioLabel) != false))
{
            recycleActor(_BioLabel);
}

        if((hasValue(_SpeechLabel) != false))
{
            recycleActor(_SpeechLabel);
}

}

 
 	public function new(dummy:Int, actor:Actor, engine:Engine)
	{
		super(actor, engine);	
		nameMap.set("Portrait", "_Portrait");
nameMap.set("Name Text", "_NameText");
_NameText = "";
nameMap.set("Bio Text", "_BioText");
_BioText = "";
nameMap.set("Speech Text", "_SpeechText");
_SpeechText = "";
nameMap.set("Name Label", "_NameLabel");
nameMap.set("Bio Label", "_BioLabel");
nameMap.set("Speech Label", "_SpeechLabel");
nameMap.set("Title Font", "_TitleFont");
nameMap.set("Bio Font", "_BioFont");
nameMap.set("Speech Font", "_SpeechFont");
nameMap.set("Actor", "actor");

	}
	
	override public function init()
	{
		            actor.disableActorDrawing();

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}