/*
    Stencyl exclusively uses the Haxe programming language. 
    Haxe is similar to ActionScript and JavaScript.
    
    Want to use native code or make something reusable? Use the Extensions Framework instead.
    http://www.stencyl.com/help/view/engine-extensions/
    
    Learn more about Haxe and our APIs
    http://www.stencyl.com/help/view/haxe/
*/

package scripts;

import com.stencyl.Engine;

class AStarPathFinder
{    
 	public function new()
	{
	}
	
	public static function getAStarPath(__BlockList:Array<Dynamic>, __MapWidth:Int, __MapHeight:Int, __StartX:Int, __StartY:Int, __GoalX:Int, __GoalY:Int, __AllowDiagonals):Array<Dynamic>
    	{
    		var timeout = 10000;
    		var count = 0;
    		var startBlock = new Node(__StartX, __StartY);
    		var goalBlock = new Node(__GoalX, __GoalY);
    		var closedList = [startBlock];
    		var failed = false;

    		while (!failed && !startBlock.matches(goalBlock.x, goalBlock.y))
		{
			var openList = AStarPathFinder.getValidSquares(__BlockList,__MapWidth,__MapHeight,startBlock.x,startBlock.y, closedList, __AllowDiagonals);
			count++;
			
			if (count == timeout)
			{
				failed = true;
			}
			else
			{
				if (openList.length == 0)
				{
					var oldBlock = startBlock;
					startBlock = startBlock.parent;
					
					if (startBlock.matches(oldBlock.x, oldBlock.y)) failed = true;
				}
				else
				{
					for (block in openList)
					{
						block.parent = startBlock;
					}
					
					var bestBlock = null;
					var bestH = 9999999;
					
					for (block in cast(openList, Array<Dynamic>))
					{
						var distanceX = Std.int(__GoalX - block.x);
						var distanceY = Std.int(__GoalY - block.y);
						
						if (distanceX < 0) distanceX = -distanceX;
						if (distanceY < 0) distanceY = -distanceY;
						
						var h = (distanceX + distanceY) * 10;
						if (h < bestH)
						{
							bestBlock = block;
							bestH = h;
						}
					}
	
					startBlock = bestBlock;
					closedList.push(startBlock);
				}
			}
		}
		
		var path = [];
		var pathBlock = closedList[closedList.length - 1];
		
		while (!pathBlock.matches(__StartX, __StartY))
		{
			path.push(pathBlock);
			pathBlock = pathBlock.parent;
		}
		
		return path;
    }
    
	/* Params are:__BlockList __Width __Height __StartX __StartY __ClosedList */
	public static function getValidSquares(__BlockList:Array<Dynamic>, __Width:Float, __Height:Float, __StartX:Int, __StartY:Int, __ClosedList:Array<Dynamic>, __AllowDiagonals:Bool):Array<Dynamic>
	{
		var valid = [];
		var target;
		var closed = false;

		// left
		if (__StartX > 0)
		{
			var pos = Std.int((__StartY * __Width) + __StartX - 1);
			target = __BlockList[pos];
			
			if (target == 0)
			{
				closed = false;
				
				for (item in cast(__ClosedList, Array<Dynamic>))
				{
					if (item.x == __StartX - 1 && item.y == __StartY)
					{
						closed = true;
						break;
					}
				}
				
				if (!closed) valid.push(new Node(__StartX - 1, __StartY));
            }
            if (__AllowDiagonals)
            {
            	if (__StartY > 0)
            	{
            		var pos = Std.int(((__StartY - 1)* __Width) + __StartX - 1);
            		target = __BlockList[pos];
            		if (target == 0) valid.push(new Node(__StartX - 1, __StartY - 1));
            	}
            	if (__StartY < __Height)
            	{
            		var pos = Std.int(((__StartY + 1)* __Width) + __StartX - 1);
            		target = __BlockList[pos];
            		if (target == 0) valid.push(new Node(__StartX - 1, __StartY + 1));
            	}
            }
        }

		// right
        if (__StartX < __Width)
        {
        		var pos = Std.int((__StartY * __Width) + __StartX + 1);
        		target = __BlockList[pos];

            if (target == 0)
            {
                closed = false;

                for (item in cast(__ClosedList, Array<Dynamic>))
                {
                    if (item.x == __StartX + 1 && item.y == __StartY)
                    {
                        closed = true;
                        break;
                    }
                }

                if (!closed) valid.push(new Node(__StartX + 1, __StartY));
            }
            if (__AllowDiagonals)
            {
            	if (__StartY > 0)
            	{
            		var pos = Std.int(((__StartY - 1)* __Width) + __StartX + 1);
            		target = __BlockList[pos];
            		if (target == 0) valid.push(new Node(__StartX + 1, __StartY - 1));
            	}
            	if (__StartY < __Height)
            	{
            		var pos = Std.int(((__StartY + 1)* __Width) + __StartX + 1);
            		target = __BlockList[pos];
            		if (target == 0) valid.push(new Node(__StartX - 1, __StartY + 1));
            	}
            }
        }

        // mid
        if (__StartY > 0)
        {
            var pos = Std.int(((__StartY - 1)* __Width) + __StartX);
            target = __BlockList[pos];

            if (target == 0)
            {
                closed = false;

                for (item in cast(__ClosedList, Array<Dynamic>))
                {
                    if (item.x == __StartX && item.y == __StartY - 1)
                    {
                        closed = true;
                        break;
                    }
                }

                if (!closed) valid.push(new Node(__StartX, __StartY - 1));
            }
        }
        
        if (__StartY < __Height)
        {
        	var pos = Std.int(((__StartY + 1)* __Width) + __StartX);
            target = __BlockList[pos];

            if (target == 0)
            {
                closed = false;

                for (item in cast(__ClosedList, Array<Dynamic>))
                {
                    if (item.x == __StartX && item.y == __StartY + 1)
                    {
                        closed = true;
                        break;
                    }
                }

                if (!closed) valid.push(new Node(__StartX, __StartY + 1));
            }
        }

        return valid;
    }
}