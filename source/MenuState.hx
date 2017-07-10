package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.effects.particles.TextEmitter;
import flixel.effects.particles.TextParticle;

class MenuState extends FlxState
{
    private var emitter:TextEmitter;
    
    private static var particleCount:Int = 3;
    private static var poolSize:Int = particleCount*10;
    
    private var colors:Array<FlxColor> = 
        [FlxColor.RED, FlxColor.GREEN, FlxColor.BLUE, FlxColor.YELLOW, FlxColor.PURPLE, FlxColor.ORANGE];
    private var colorIndex:Int = 0;
    
    private var count:Int = 0;
    
    private var promptText:FlxText;
    
	override public function create():Void
	{
		super.create();
        FlxG.camera.bgColor = FlxColor.WHITE;
        promptText = new FlxText();
        promptText = new FlxText(10, 10, 400); // x, y, width
        promptText.setFormat(null, 20, FlxColor.BLACK, LEFT);
        promptText.text = "Click anywhere to make particles.";
        this.add(promptText);
        emitter = makeEmitter();
		this.add(emitter);    
        loadParticles();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
        if (FlxG.mouse.justReleased){
            count++;
            var mPos:FlxPoint = FlxG.mouse.getScreenPosition();
            //rotate through the colors in the colors array
            emitter.color.set(colors[colorIndex]);
            colorIndex = (colorIndex + 1) % colors.length;
            //emit from the mouse cursor's location
            emitter.x = mPos.x;
            emitter.y = mPos.y;
            emitter.Text = count + "X";
            emitter.start(true, 0.01, particleCount);
        }
	}
    
    private function makeEmitter(): TextEmitter {
        var textEmitter:TextEmitter = new TextEmitter(FlxG.width / 2 , FlxG.height / 2, poolSize);
        textEmitter.color.set(colors[colorIndex]);
        textEmitter.launchMode = FlxEmitterMode.CIRCLE;
        textEmitter.Font = "SF Cartoonist Hand Bold";
        //pixels/second
        textEmitter.speed.set(80, 120);
        //emitted particles last for 1 - 2 seconds
        textEmitter.lifespan.set(1.0, 2.0);
        //make emitted particles go generally upwards
        textEmitter.launchAngle.set( -135, -45);
        return textEmitter;
    }

    private function loadParticles():Void{
        for (i in 0...poolSize){
        	var p = new TextParticle("*", 32, true);
            p.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.GRAY, 1, 0);
        	emitter.add(p);
        }
    }
}
