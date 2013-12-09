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



class Design_20_20_LabelPM extends ActorScript
{          	
	
public var _MaxWidth:Float;

public var _CurrentText:String;

public var _TextToDraw:String;

public var _CharacterStart:Float;

public var _CharacterEnd:Float;

public var _Font:Font;

public var _CurrentY:Float;

public var _ReturnChunk:String;

public var _Lines:Array<Dynamic>;

public var _CurrentLine:String;

public var _LineHeight:Float;

 
 	public function new(dummy:Int, actor:Actor, engine:Engine)
	{
		super(actor, engine);	
		nameMap.set("Max Width", "_MaxWidth");
_MaxWidth = 0.0;
nameMap.set("Current Text", "_CurrentText");
_CurrentText = "";
nameMap.set("Text To Draw", "_TextToDraw");
_TextToDraw = "";
nameMap.set("Character Start", "_CharacterStart");
_CharacterStart = 0.0;
nameMap.set("Character End", "_CharacterEnd");
_CharacterEnd = 0.0;
nameMap.set("Font", "_Font");
nameMap.set("Current Y", "_CurrentY");
_CurrentY = 0.0;
nameMap.set("Return Chunk", "_ReturnChunk");
_ReturnChunk = "";
nameMap.set("Lines", "_Lines");
_Lines = [];
nameMap.set("Current Line", "_CurrentLine");
_CurrentLine = "";
nameMap.set("Line Height", "_LineHeight");
_LineHeight = 0.0;
nameMap.set("Actor", "actor");

	}
	
	override public function init()
	{
		            actor.disableActorDrawing();
    addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
if(wrapper.enabled){
        g.translateToActor(actor);
        g.setFont(_Font);
        _CurrentY = asNumber(0);
propertyChanged("_CurrentY", _CurrentY);
        _Lines = ("" + _TextToDraw).split("|");
propertyChanged("_Lines", _Lines);
        for(item in cast(_Lines, Array<Dynamic>))
{
            _CharacterEnd = asNumber(0);
propertyChanged("_CharacterEnd", _CharacterEnd);
            _CurrentLine = item;
propertyChanged("_CurrentLine", _CurrentLine);
            while((_CharacterEnd < ("" + _CurrentLine).length))
{
                _CurrentText = "";
propertyChanged("_CurrentText", _CurrentText);
                _CharacterStart = asNumber(_CharacterEnd);
propertyChanged("_CharacterStart", _CharacterStart);
                while(((g.font.font.getTextWidth(_CurrentText)/Engine.SCALE < _MaxWidth) && (_CharacterEnd < ("" + _CurrentLine).length)))
{
                    _CharacterEnd += 1;
propertyChanged("_CharacterEnd", _CharacterEnd);
                    _CurrentText = ("" + _CurrentLine).substring(Std.int(_CharacterStart), Std.int(_CharacterEnd));
propertyChanged("_CurrentText", _CurrentText);
}

                _ReturnChunk = _CurrentText;
propertyChanged("_ReturnChunk", _ReturnChunk);
                if((_CharacterEnd < ("" + _CurrentLine).length))
{
                    while(((("" + _ReturnChunk).length > 0) && !(("" + _ReturnChunk).charAt(Std.int((("" + _ReturnChunk).length - 1))) == " ")))
{
                        _ReturnChunk = ("" + _ReturnChunk).substring(Std.int(0), Std.int((("" + _ReturnChunk).length - 1)));
propertyChanged("_ReturnChunk", _ReturnChunk);
}

}

                if((("" + _ReturnChunk).length == 0))
{
                    _CurrentText = ("" + _CurrentText).substring(Std.int(0), Std.int((("" + _CurrentText).length - 1)));
propertyChanged("_CurrentText", _CurrentText);
                    _CharacterEnd -= 1;
propertyChanged("_CharacterEnd", _CharacterEnd);
}

                else
{
                    _CharacterEnd -= (("" + _CurrentText).length - ("" + _ReturnChunk).length);
propertyChanged("_CharacterEnd", _CharacterEnd);
                    _CurrentText = _ReturnChunk;
propertyChanged("_CurrentText", _CurrentText);
}

                g.drawString("" + _CurrentText, 0, _CurrentY);
                if((_LineHeight > 0))
{
                    _CurrentY += _LineHeight;
propertyChanged("_CurrentY", _CurrentY);
}

                else
{
                    _CurrentY += g.font.getHeight()/Engine.SCALE;
propertyChanged("_CurrentY", _CurrentY);
}

}

}

}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}