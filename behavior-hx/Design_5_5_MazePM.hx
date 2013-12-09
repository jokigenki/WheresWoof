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



class Design_5_5_MazePM extends SceneScript
{          	
	
public var _ScreenOffsetX:Float;

public var _ScreenOffsetY:Float;

public var _OldScreenOffsetX:Float;

public var _OldScreenOffsetY:Float;

public var _MaxX:Float;

public var _MaxY:Float;

public var _ScreenTilesX:Float;

public var _ScreenTilesY:Float;

public var _Player:Actor;

public var _PlayerX:Float;

public var _PlayerY:Float;

public var _TileSetID:Float;

public var _WallList:Array<Dynamic>;

public var _GfxList:Array<Dynamic>;

public var _PlayerStartY:Float;

public var _PlayerStartX:Float;

public var _GoalX:Float;

public var _PlayerInitialised:Bool;

public var _Characters:Array<Dynamic>;

public var _GoalY:Float;

public var _CharacterY:Float;

public var _CharacterX:Float;

public var _DepthSortList:Array<Dynamic>;

public var _AdjacentCharacters:Array<Dynamic>;
    

/* Params are:__XCoord __YCoord */
public function _customBlock_GetListPositionFromXY(__XCoord:Float, __YCoord:Float):Float
{
        return ((__YCoord * _MaxX) + __XCoord);
}
    

/* Params are:__OffsetX __OffsetY */
public function _customBlock_SetOffsets(__OffsetX:Float, __OffsetY:Float):Void
{
        if(((__OffsetX > -1) && (__OffsetX < _MaxX)))
{
            _PlayerX = asNumber(__OffsetX);
propertyChanged("_PlayerX", _PlayerX);
}

        if(((__OffsetY > -1) && (__OffsetY < _MaxY)))
{
            _PlayerY = asNumber(__OffsetY);
propertyChanged("_PlayerY", _PlayerY);
}

        _ScreenOffsetX = asNumber((_PlayerX - (_ScreenTilesX / 2)));
propertyChanged("_ScreenOffsetX", _ScreenOffsetX);
        _ScreenOffsetY = asNumber((_PlayerY - (_ScreenTilesY / 2)));
propertyChanged("_ScreenOffsetY", _ScreenOffsetY);
        if((_ScreenOffsetX < 0))
{
            _ScreenOffsetX = asNumber(0);
propertyChanged("_ScreenOffsetX", _ScreenOffsetX);
}

        else if((_ScreenOffsetX > (_MaxX - _ScreenTilesX)))
{
            _ScreenOffsetX = asNumber((_MaxX - _ScreenTilesX));
propertyChanged("_ScreenOffsetX", _ScreenOffsetX);
}

        if((_ScreenOffsetY < 0))
{
            _ScreenOffsetY = asNumber(0);
propertyChanged("_ScreenOffsetY", _ScreenOffsetY);
}

        else if((_ScreenOffsetY > (_MaxY - _ScreenTilesY)))
{
            _ScreenOffsetY = asNumber((_MaxY - _ScreenTilesY));
propertyChanged("_ScreenOffsetY", _ScreenOffsetY);
}

}
    

/* Params are:__X __Y */
public function _customBlock_CanMoveIntoTile(__X:Float, __Y:Float):Bool
{
        return (_WallList[Std.int(cast((sayToScene("Maze PM", "_customBlock_GetListPositionFromXY", [__X,__Y])), Float))] == 0);
}
    

/* Params are:__Width __Height __X __Y __Value */
public function _customBlock_SetTilesToValue(__Width:Float, __Height:Float, __X:Float, __Y:Float, __Value:Float):Void
{
        for (y in Std.int(__Y)...Std.int(__Y + __Height))
{
	for (x in Std.int(__X)...Std.int(__X + __Width))
	{
		var pos = cast((sayToScene("Maze PM", "_customBlock_GetListPositionFromXY", [x, y])), Int);
	     _WallList[pos] = __Value;
	}
}

}
    

/* Params are:*/
public function _customBlock_GetRandomEmptySquare():Array<Dynamic>
{
        _GoalX = asNumber(-1);
propertyChanged("_GoalX", _GoalX);
        _GoalY = asNumber(-1);
propertyChanged("_GoalY", _GoalY);
        while(((_GoalX == -1) && (_GoalY == -1)))
{
            _GoalX = asNumber(randomInt(Math.floor(0), Math.floor(_MaxX)));
propertyChanged("_GoalX", _GoalX);
            _GoalY = asNumber(randomInt(Math.floor(0), Math.floor(_MaxY)));
propertyChanged("_GoalY", _GoalY);
            if(!(cast((sayToScene("Maze PM", "_customBlock_CanMoveIntoTile", [_GoalX,_GoalY])), Bool)))
{
                _GoalX = asNumber(-1);
propertyChanged("_GoalX", _GoalX);
                _GoalY = asNumber(-1);
propertyChanged("_GoalY", _GoalY);
}

}

        return [_GoalX, _GoalY];
}
    

/* Params are:*/
public function _customBlock_PlaceCharacters():Void
{
        for(item in cast(_Characters, Array<Dynamic>))
{
            if(item.hasBehavior("Keyboard Controls PM"))
{
                if(!(item.getValue("Keyboard Controls PM", "_IsInitialised")))
{
                    item.setValue("Keyboard Controls PM", "_IsInitialised", true);
                    item.setValue("Block Map Character PM", "_XPosition", _PlayerStartX);
                    item.setValue("Block Map Character PM", "_YPosition", _PlayerStartY);
}

                sayToScene("Maze PM", "_customBlock_PlacePlayer", [item,item.getValue("Block Map Character PM", "_XPosition"),item.getValue("Block Map Character PM", "_YPosition")]);
}

            else if(item.hasBehavior("Block Map Character PM"))
{
                sayToScene("Maze PM", "_customBlock_PlaceNPC", [item,item.getValue("Block Map Character PM", "_XPosition"),item.getValue("Block Map Character PM", "_YPosition")]);
}

}

}
    

/* Params are:__Player __X __Y */
public function _customBlock_PlacePlayer(__Player:Actor, __X:Float, __Y:Float):Void
{
        if((__X < (_ScreenTilesX / 2)))
{
            __Player.setX((__X * getTileWidth()));
}

        else if((__X > (_MaxX - (_ScreenTilesX / 2))))
{
            __Player.setX(((getScreenWidth() / 2) + ((__X - (_MaxX - (_ScreenTilesX / 2))) * getTileWidth())));
}

        else
{
            __Player.setX((getScreenWidth() / 2));
}

        if((__Y < (_ScreenTilesY / 2)))
{
            __Player.setY(((__Y * getTileHeight()) - 16));
}

        else if((__Y > (_MaxY - (_ScreenTilesY / 2))))
{
            __Player.setY(((getScreenHeight() / 2) + ((__Y - (_MaxY - (_ScreenTilesY / 2))) * getTileHeight())));
}

        else
{
            __Player.setY(((getScreenHeight() / 2) - 16));
}

}
    

/* Params are:__NPC __X __Y */
public function _customBlock_PlaceNPC(__NPC:Actor, __X:Float, __Y:Float):Void
{
        if((((__X >= _ScreenOffsetX) && (__X < (_ScreenOffsetX + _ScreenTilesX))) && ((__Y >= (_ScreenOffsetY - 1)) && (__Y < (_ScreenOffsetY + _ScreenTilesY)))))
{
            __NPC.enableActorDrawing();
            __NPC.setX(((__X - _ScreenOffsetX) * getTileWidth()));
            __NPC.setY((((__Y - _ScreenOffsetY) - 1) * getTileHeight()));
}

        else
{
            __NPC.disableActorDrawing();
            __NPC.setX(-100);
            __NPC.setY(-100);
}

}
    

/* Params are:__Character */
public function _customBlock_AddCharacter(__Character:Actor):Void
{
        if(!(Utils.contains(_Characters, __Character)))
{
            _Characters.push(__Character);
}

}
    

/* Params are:__X __Y */
public function _customBlock_ClearCharacterCollision(__X:Float, __Y:Float):Void
{
        _WallList[Std.int(cast((sayToScene("Maze PM", "_customBlock_GetListPositionFromXY", [__X,__Y])), Float))] = 0;
}
    

/* Params are:__X __Y */
public function _customBlock_AddCharacterCollision(__X:Float, __Y:Float):Void
{
        _WallList[Std.int(cast((sayToScene("Maze PM", "_customBlock_GetListPositionFromXY", [__X,__Y])), Float))] = 2;
}
    

/* Params are:__Character1 __Character2 */
public function _customBlock_AreCharactersTouching(__Character1:Actor, __Character2:Actor):Bool
{
        _CharacterX = asNumber(Math.abs((__Character1.getValue("Block Map Character PM", "_XPosition") - __Character2.getValue("Block Map Character PM", "_XPosition"))));
propertyChanged("_CharacterX", _CharacterX);
        _CharacterY = asNumber(Math.abs((__Character1.getValue("Block Map Character PM", "_YPosition") - __Character2.getValue("Block Map Character PM", "_YPosition"))));
propertyChanged("_CharacterY", _CharacterY);
        return ((_CharacterX < 2) && (_CharacterY < 2));
}
    

/* Params are:*/
public function _customBlock_UpdateAdjacentCharactersList():Void
{
        _AdjacentCharacters = [];
for (a in _Characters)
{
	for (b in _Characters)
	{
		if (a == b) continue;
		var isAdjacent = cast((sayToScene("Maze PM", "_customBlock_AreCharactersTouching", [a,b])), Bool);

		if (isAdjacent)
		{
			var aName = a.name + " " + a.ID;
			var bName = b.name + " " + b.ID;
			_AdjacentCharacters.push(aName + "|" + bName);
			_AdjacentCharacters.push(bName + "|" + aName);
		}
	}
}

}
    

/* Params are:*/
public function _customBlock_MoveScreen():Void
{
        var row = "";
if (_OldScreenOffsetX != _ScreenOffsetX || _OldScreenOffsetY != _ScreenOffsetY)
{
	var rightEdge = Std.int(_ScreenOffsetX + _ScreenTilesX);
	if (rightEdge > _MaxX) rightEdge = Std.int(_MaxX);
	var bottomEdge = Std.int(_ScreenOffsetY + _ScreenTilesY);
	if (bottomEdge > _MaxY) bottomEdge = Std.int(_MaxY);

	//trace(_ScreenOffsetX+ ":" + _ScreenOffsetY + "-" + rightEdge + ":" + bottomEdge);
	for (y in Std.int(_ScreenOffsetY)...bottomEdge)
	{
		for (x in Std.int(_ScreenOffsetX)...rightEdge)
		{
			var drawX = Std.int(x - _ScreenOffsetX);
			var drawY = Std.int(y - _ScreenOffsetY);
			var pos = cast((sayToScene("Maze PM", "_customBlock_GetListPositionFromXY", [x, y])), Int);
	          var tileID = _GfxList[pos];
	          TileAPI.removeTileAt(drawY,drawX,0);
			TileAPI.setTileAt(drawY,drawX,0,_TileSetID,tileID);
			//trace("set at " + x + ", " + y);
			row = row + tileID;
		}
		//trace(row);
		row = "";
	}
	_OldScreenOffsetX = _ScreenOffsetX;
	_OldScreenOffsetY = _ScreenOffsetY;
}

}
    

/* Params are:__Character1 __Character2 */
public function _customBlock_CanChat(__Character1:Actor, __Character2:Actor):Bool
{
        for(item in cast(_Characters, Array<Dynamic>))
{
            if(item == __Character1.name + " " + __Character1.ID + "|" + __Character2.name + " " + __Character2.ID && __Character2.hasBehavior("Chatee PM"))
{
                return true;
}

}

        return false;
}
    

/* Params are:__Chatter */
public function _customBlock_GetChatee(__Chatter:Actor):Actor
{
        for (namesString in _AdjacentCharacters)
{
	var chatterName = __Chatter.name + " " + __Chatter.ID;
	var names = namesString.split("|");
	var name1 = names[0];
	var name2 = names[1];
	var otherName = name1 == chatterName ? name2 : name1;
	if (name1 == chatterName || name2 == chatterName)
	{
		var allActors = Engine.engine.allActors;
		for (actorOnScreen in allActors)
		{
			if (actorOnScreen != null && !actorOnScreen.dead && !actorOnScreen.recycled)
			{
				if (actorOnScreen.name + " " + actorOnScreen.ID == otherName)
				{
					return actorOnScreen;
				}
			}
		}
	}
}

return null;

}
    

/* Params are:*/
public function _customBlock_DepthSortCharacters():Void
{
        _DepthSortList = new Array<Dynamic>();
propertyChanged("_DepthSortList", _DepthSortList);
        for (character in _Characters) {
	var count = 0;
	var inserted = false;
	for (sortee in _DepthSortList) {
		if (character.getY() < sortee.getY()) {
			_DepthSortList.insert(Std.int(count), character);
			inserted = true;
			break;
		}
		count++;
	}

	if (!inserted) _DepthSortList.push(character);
}

        for(item in cast(_DepthSortList, Array<Dynamic>))
{
            item.bringToFront();
}

}

 
 	public function new(dummy:Int, engine:Engine)
	{
		super(engine);
		nameMap.set("Screen Offset X", "_ScreenOffsetX");
_ScreenOffsetX = 0.0;
nameMap.set("Screen Offset Y", "_ScreenOffsetY");
_ScreenOffsetY = 0.0;
nameMap.set("Old Screen Offset X", "_OldScreenOffsetX");
_OldScreenOffsetX = 0.0;
nameMap.set("Old Screen Offset Y", "_OldScreenOffsetY");
_OldScreenOffsetY = 0.0;
nameMap.set("Max X", "_MaxX");
_MaxX = 0.0;
nameMap.set("Max Y", "_MaxY");
_MaxY = 0.0;
nameMap.set("Screen Tiles X", "_ScreenTilesX");
_ScreenTilesX = 0.0;
nameMap.set("Screen Tiles Y", "_ScreenTilesY");
_ScreenTilesY = 0.0;
nameMap.set("Player", "_Player");
nameMap.set("Player X", "_PlayerX");
_PlayerX = 0.0;
nameMap.set("Player Y", "_PlayerY");
_PlayerY = 0.0;
nameMap.set("Tile Set ID", "_TileSetID");
_TileSetID = 3.0;
nameMap.set("Wall List", "_WallList");
_WallList = [];
nameMap.set("Gfx List", "_GfxList");
_GfxList = [];
nameMap.set("Player Start Y", "_PlayerStartY");
_PlayerStartY = 0.0;
nameMap.set("Player Start X", "_PlayerStartX");
_PlayerStartX = 0.0;
nameMap.set("Goal X", "_GoalX");
_GoalX = 0.0;
nameMap.set("Player Initialised", "_PlayerInitialised");
_PlayerInitialised = false;
nameMap.set("Characters", "_Characters");
_Characters = [];
nameMap.set("Goal Y", "_GoalY");
_GoalY = 0.0;
nameMap.set("Character Y", "_CharacterY");
_CharacterY = 0.0;
nameMap.set("Character X", "_CharacterX");
_CharacterX = 0.0;
nameMap.set("Depth Sort List", "_DepthSortList");
_DepthSortList = [];
nameMap.set("Adjacent Characters", "_AdjacentCharacters");
_AdjacentCharacters = [];

	}
	
	override public function init()
	{
		            _Characters = new Array<Dynamic>();
propertyChanged("_Characters", _Characters);
        _AdjacentCharacters = new Array<Dynamic>();
propertyChanged("_AdjacentCharacters", _AdjacentCharacters);
        _OldScreenOffsetX = asNumber(-1);
propertyChanged("_OldScreenOffsetX", _OldScreenOffsetX);
        _OldScreenOffsetY = asNumber(-1);
propertyChanged("_OldScreenOffsetY", _OldScreenOffsetY);
        _ScreenOffsetX = asNumber(0);
propertyChanged("_ScreenOffsetX", _ScreenOffsetX);
        _ScreenOffsetY = asNumber(0);
propertyChanged("_ScreenOffsetY", _ScreenOffsetY);
        _ScreenTilesX = asNumber(Math.ceil((getScreenWidth() / getTileWidth())));
propertyChanged("_ScreenTilesX", _ScreenTilesX);
        _ScreenTilesY = asNumber(Math.ceil((getScreenHeight() / getTileHeight())));
propertyChanged("_ScreenTilesY", _ScreenTilesY);
        _WallList = new Array<Dynamic>();
propertyChanged("_WallList", _WallList);
        _GfxList = new Array<Dynamic>();
propertyChanged("_GfxList", _GfxList);
        // outer walls!
for (y in 0...Std.int(_MaxY))
{
	for (x in 0...Std.int(_MaxX))
     {
     	var pos = cast((sayToScene("Maze PM", "_customBlock_GetListPositionFromXY", [x, y])), Int);
          _WallList[pos] = 1;
         
		// put the entrance door in!
          if (y == 0 && x > 95 && x < 101)
          {
          	_WallList[pos] = 0;
          }
      }
}
        var blockSize = 5;
var minMove = 3;
var border = (minMove * blockSize) + 2;
var directionX = 0;
var directionY = minMove;
var currentXPosition = _PlayerStartX - 2;
var currentYPosition = _PlayerStartY + 1;
var lastX = directionX;
var lastY = directionY;

//roads
for (c in 0...400)
{	
	var blocksX = directionX == 0 ? blockSize : minMove * blockSize;
	var blocksY = directionY == 0 ? blockSize : minMove * blockSize;
	var startX = directionX < 0 ? currentXPosition - (blocksX - blockSize) : currentXPosition;
	var startY = directionY < 0 ? currentYPosition - (blocksY - blockSize) : currentYPosition;

	sayToScene("Maze PM", "_customBlock_SetTilesToValue", [blocksX,blocksY,startX,startY,0]);
	currentXPosition += directionX * blockSize;
	currentYPosition += directionY * blockSize;
	
	if (lastX == -directionX && lastX != 0) trace ("FLIPPED X");
	if (lastY == -directionY && lastY != 0) trace ("FLIPPED Y");

	lastX = directionX;
	lastY = directionY;
	
	// if moving left
	if (directionX == -minMove)
	{
		// if on the left edge
		if (currentXPosition < border)
		{
			// handle corners
			if (currentYPosition < border)
			{
				directionX = 0;
				directionY = minMove;
			}
			else if (currentYPosition > _MaxY - border)
			{
				directionX = 0;
				directionY = -minMove;
			}
			else if (Math.random() < 0.5)
			{
				directionX = 0;
				directionY = -minMove;
			}
			else 
			{
				directionX = 0;
				directionY = minMove;
			}
			
		}
		else if (currentYPosition < _MaxY - border && Math.random() < 0.25)
		{
			directionX = 0;
			directionY = minMove;
		}
		else if (currentYPosition > border && Math.random() < 0.5)
		{
			directionX = 0;
			directionY = -minMove;
		}
	}
	
	// if moving right
	else if (directionX == minMove)
	{
		// if on the right edge
		if (currentXPosition > _MaxX - border)
		{
			if (currentYPosition < border)
			{
				directionX = 0;
				directionY = minMove;
			}
			else if (currentYPosition > _MaxY - border)
			{
				directionX = 0;
				directionY = -minMove;
			}
			else if (Math.random() < 0.5)
		     {
		         directionX = 0;
		         directionY = -minMove;
		     }
		     else
		     {
		         directionX = 0;
		         directionY = minMove;
		     }
		} 
		else if (currentYPosition < _MaxY - border && Math.random() < 0.25)
		{
			directionX = 0;
			directionY = minMove;
		}
		else if (currentYPosition > border && Math.random() < 0.5)
		{
			directionX = 0;
			directionY = -minMove;
		}
	}

	
	// if moving up
	else if (directionY == -minMove)
	{
		// if on the left edge
		if (currentYPosition < border)
		{
			if (currentXPosition < border)
			{
				directionX = minMove;
				directionY = 0;
			}
			else if (currentXPosition > _MaxX - border)
			{
				directionX = -minMove;
				directionY = 0;
			}
			else if (Math.random() < 0.5)
		     {
		         directionX = -minMove;
		         directionY = 0;
		     }
		     else
		     {
		         directionX = minMove;
		         directionY = 0;
		     }
		}
		else if (currentXPosition < _MaxX - border && Math.random() < 0.25)
		{
			directionX = minMove;
			directionY = 0;
		}
		else if (currentXPosition > border && Math.random() < 0.5)
		{
			directionX = -minMove;
			directionY = 0;
		}
	}
	
	// if moving down
	else if (directionY == minMove)
	{
		// if on the bottom edge
		if (currentYPosition > _MaxY - border)
		{
			if (currentXPosition < border)
			{
				directionX = minMove;
				directionY = 0;
			}
			else if (currentXPosition > _MaxX - border)
			{
				directionX = -minMove;
				directionY = 0;
			}
			else if (Math.random() < 0.5)
	          {
	              directionX = -minMove;
	              directionY = 0;
	          }
	          else
	          {
	              directionX = minMove;
	              directionY = 0;
	          }
		}
		else if (currentXPosition < _MaxX - border && Math.random() < 0.25)
		{
			directionX = minMove;
			directionY = 0;
		}
		else if (currentXPosition > border && Math.random() < 0.5)
		{
			directionX = -minMove;
			directionY = 0;
		}
	}
}
        // render
for (y in 0...Std.int(_MaxY))
{
	for (x in 0...Std.int(_MaxX))
     {
     	var pos = cast((sayToScene("Maze PM", "_customBlock_GetListPositionFromXY", [x, y])), Int);
          var type = _WallList[pos];
          if (type == 0)
		{
			_GfxList[pos] = 0;
		}
		else if (type == 1)
		{
			var downpos = cast((sayToScene("Maze PM", "_customBlock_GetListPositionFromXY", [x, y + 3])), Int);
			var isWall = _WallList[downpos] == 1;
			if (isWall) _GfxList[pos] = 2;
			else _GfxList[pos] = 1;
		}
      }
}
        setGameAttribute("Maze", _WallList);
    addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
if(wrapper.enabled){
        sayToScene("Maze PM", "_customBlock_PlaceCharacters");
        sayToScene("Maze PM", "_customBlock_UpdateAdjacentCharactersList");
        sayToScene("Maze PM", "_customBlock_MoveScreen");
        sayToScene("Maze PM", "_customBlock_DepthSortCharacters");
}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}