package {
	import net.hires.debug.Stats;
	import be.nascom.physics.Curtains;
	
	
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	
	[SWF(width="1000", height="1000", frameRate="30", backgroundColor="0x595959")]
	public class CurtainsDemo extends Sprite
	{
		private var _curtain : Curtains;
		
		[Embed(source="tweet.jpg")]
		private var _texture : Class; 
		
		[Embed(source="logo.png")]
		private var _logo : Class; 
	
		public function CurtainsDemo()
		{
		//	var textfield : TextField = new TextField();
			var bitmap : Bitmap = new _texture();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			bitmap.alpha = .25;
			bitmap.scaleX = bitmap.scaleY = 2;
			bitmap.filters = [ new BlurFilter(10, 10, 1) ];
			bitmap.x = -50;
			bitmap.y = -150;
			
			
		//	addChild(bitmap);
			
			_curtain = new Curtains(bitmap.bitmapData, 600, 600, 20, 20, 0, 1000);
			_curtain.lockTop(true);
			_curtain.lockBottom(true);
			_curtain.lockRight = true;
		//	_curtain.lockBottom = true;
		//	_curtain.x = 106;
			addChild(_curtain);		
			addChild(new Stats());	
						
	//		addChild(new _logo());
			
			//_curtain.lockRight = true;
			
			
		}
	}
}
