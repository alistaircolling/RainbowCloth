package be.nascom.physics.verlet {
	import graphics.Drawing;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	public class VerletPoint {
		private var _hook : DisplayObject;
		private var _x : Number,
		_y : Number,
		_oldX : Number,
		_oldY : Number;
		public var mobileX : Boolean = true;
		public var mobileY : Boolean = true;
		private var _lock:Boolean;

		public function VerletPoint(x : Number = 0, y : Number = 0, displayObjectHook : DisplayObject = null, lockIt:Boolean = false) {
			_hook = displayObjectHook;
			lock = lockIt;

			setPosition(x, y);
		}

		public function setPosition(x : Number, y : Number) : void {
			_x = _oldX = x;
			_y = _oldY = y;

			if (_hook) {
				_hook.x = x;
				_hook.y = y;
			}
		}

		public function update() : void {
			var oldX : Number;
			var oldY : Number;

			if (mobileX) {
				oldX = x;
				x += velocityX;
				_oldX = oldX;
			}
			if (mobileY) {
				oldY = y;
				y += velocityY;
				_oldY = oldY;
			}
		}

		public function get x() : Number {
			// if (_hook) _x = _hook.x;
			return _x;
		}

		public function set x(value : Number) : void {
			_x = value;
			if (!mobileX) _oldX = value;
			if (_hook) _hook.x = value;
		}

		public function get y() : Number {
			// if (_hook) _y = _hook.y;
			return _y;
		}

		public function set y(value : Number) : void {
			_y = value;
			if (!mobileY) _oldY = value;
			if (_hook) _hook.y = value;
		}

		public function get velocityX() : Number {
			return _x - _oldX;
		}

		public function set velocityX(value : Number) : void {
			_oldX = _x - value;
		}

		public function get velocityY() : Number {
			return _y - _oldY;
		}

		public function set velocityY(value : Number) : void {
			_oldY = _y - value;
		}

		public function get lock() : Boolean {
			return _lock;
		}

		public function set lock(lock : Boolean) : void {
			_lock = lock;
		}

		public function isLocked() : Boolean {
		
			if (!mobileX&&!mobileY){
				return true;
			}else{
				return false;
			}
		
		}

		public function setLocked(boolean : Boolean) : void {
			mobileX = !boolean;
			mobileY = !boolean;
		}
	}
}