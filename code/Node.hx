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

class Node
{    
	public var x:Int;
	public var y:Int;
	public var parent:Node;
	
 	public function new(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}

	public function matches (x:Int, y:Int):Bool
	{
		return (this.x == x && this.y == y);
	}
}