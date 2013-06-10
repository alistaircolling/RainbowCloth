package be.nascom.physics.verlet {
	import flash.display.Sprite;

	public class VerletConnection {
		private var _rigidity : Number = .5;
		// .5;
		private var _point1 : VerletPoint;
		private var _point2 : VerletPoint;
		private var _minDistance : Number,
		_maxDistance : Number;
		private var _target : Sprite;
		private var _keepAngle : Boolean;
		private var _angle : Number;

		public function VerletConnection(point1 : VerletPoint, point2 : VerletPoint, minDistance : Number = -1, maxDistance : Number = -1, drawTarget : Sprite = null) {
			_point1 = point1;
			_point2 = point2;

			if (minDistance >= 0)
				_minDistance = minDistance;
			else
				_minDistance = Math.sqrt((point2.x - point1.x) * (point2.x - point1.x) + (point2.y - point1.y) * (point2.y - point1.y));

			if (maxDistance >= minDistance)
				_maxDistance = maxDistance;
			else
				_maxDistance = _minDistance;

			if (_keepAngle) {
				_angle = Math.atan2(point2.y - point1.y, point2.x - point1.x);
			}

			_target = drawTarget;
		}

		public function get rigidity() : Number {
			return _rigidity;
		}

		public function set rigidity(value : Number) : void {
			_rigidity = value;
		}

		public function update() : void {
			var x1 : Number = _point1.x,
			x2 : Number = _point2.x,
			y1 : Number = _point1.y,
			y2 : Number = _point2.y,
			dirX : Number = x2 - x1,
			dirY : Number = y2 - y1;
			var dist : Number = Math.sqrt(dirX * dirX + dirY * dirY);
			var ratio : Number,
			diffX : Number,
			diffY : Number;
			var angle : Number = Math.atan2(dirY, dirX);

			if (_keepAngle && angle != _angle) {
				ratio = -(_minDistance + dist) / dist * .75;
			} else if (dist <= _minDistance) {
				ratio = (_minDistance - dist) / dist * _rigidity;
			} else if (dist >= _maxDistance) {
				ratio = (_maxDistance - dist) / dist * _rigidity;

				if (dist > (2.7 * _maxDistance)) {
					// trace("ratio:"+ratio);
					if (_point1.isLocked()) {
						_point1.setLocked(false);
					}
					if (_point2.isLocked()) {
						_point2.setLocked(false);
					}
					
				}
			} else {
				draw();
				return;
			}

			diffX = ratio * dirX;
			diffY = ratio * dirY;

			if (!_point1.mobileX || !_point2.mobileX) diffX *= 2;
			if (!_point1.mobileY || !_point2.mobileY) diffY *= 2;

			if (_point1.mobileX) _point1.x -= diffX;
			if (_point1.mobileY) _point1.y -= diffY;
			if (_point2.mobileX) _point2.x += diffX;
			if (_point2.mobileY) _point2.y += diffY;

			draw();
		}

		private function draw() : void {
			if (_target) {
				_target.graphics.lineStyle(1, 0xff0000);
				_target.graphics.moveTo(_point1.x, _point1.y);
				_target.graphics.lineTo(_point2.x, _point2.y);
			}
		}
	}
}