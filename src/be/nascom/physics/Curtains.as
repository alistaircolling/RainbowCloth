package be.nascom.physics {
	import ColorJizz.HSV;

	import be.nascom.physics.verlet.VerletConnection;
	import be.nascom.physics.verlet.VerletPoint;
	import be.nascom.physics.verlet.VerletSystem;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class Curtains extends Sprite {
		// import flash.display.BitmapData;
		private var _dragTarget : VerletPoint;
		private var _bitmapData : BitmapData;
		private var _grid : Array;
		private var _gridX : int;
		private var _gridY : int;
		private var _gravity : Number =0;// 0.1;
		private var _verlet : VerletSystem;
		private var _minX : Number;
		private var _maxX : Number;
		private var _frictionTop : Number = .5;
		private var _friction : Number = .01;
		private var _vertexIndices : Vector.<int>;
		private var _uv : Vector.<Number>;
		private var _vertices : Vector.<Number>;
		private var _indexLookup : Dictionary;
		private var _holder : Sprite;
		private var _maxRatio : Number = 1;

		public function Curtains(source : BitmapData, width : Number, height : Number, gridX : int, gridY : int, minX : Number, maxX : Number) {
			super();

			_bitmapData = source;
			_minX = minX;
			_maxX = maxX;
			_gridX = gridX;
			_gridY = gridY;
			_holder = new Sprite();

			initVerlet(width, height);
			initVertices();
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			addChild(_holder);
		}

		public function lockTop(boolean : Boolean) : void {
			for (var x : int = 0; x < _gridX; x++) {
				_grid[x][0].mobileX = !boolean;
				_grid[x][0].mobileY = !boolean;
			}
		}

		public function lockBottom(boolean : Boolean) : void {
			for (var x : int = 0; x < _gridX; x++) {
				_grid[x][_gridY-1].mobileX = !boolean;
				_grid[x][_gridY-1].mobileY = !boolean;
			}
		}

		public function get lockLeft() : Boolean {
			return !_grid[0][0].mobileX;
		}

		public function set lockLeft(value : Boolean) : void {
			for (var y : int = 0; y < _gridY; y++) {
				_grid[0][y].mobileX = !value;
			}
		}

		public function get lockRight() : Boolean {
			return !_grid[_gridX - 1][0].mobileX;
		}

		public function set lockRight(value : Boolean) : void {
			for (var y : int = 0; y < _gridY; y++) {
				_grid[_gridX - 1][y].mobileX = !value;
			}
		}

		public function get friction() : Number {
			return _friction;
		}

		public function set friction(value : Number) : void {
			_friction = value;
		}

		public function get frictionTop() : Number {
			return _frictionTop;
		}

		public function set frictionTop(value : Number) : void {
			_frictionTop = value;
		}

		public function get gravity() : Number {
			return _gravity;
		}

		public function set gravity(value : Number) : void {
			_gravity = value;
		}

		private function initVertices() : void {
			var index : int = 0;
			var point : VerletPoint;
			_vertices = new Vector.<Number>();
			_vertexIndices = new Vector.<int>();
			_uv = new Vector.<Number>();
			_indexLookup = new Dictionary();

			for (var x : int = 0; x < _gridX; x++) {
				for (var y : int = 0; y < _gridY; y++) {
					point = _grid[x][y];
					_vertices.push(point.x);
					_vertices.push(point.y);
					_uv.push(x / (_gridX - 1));
					_uv.push(y / (_gridY - 1));
					_indexLookup[point] = index++;
				}
			}

			for (x = 0; x < _gridX - 1; x++) {
				for (y = 0; y < _gridY - 1; y++) {
					index = _indexLookup[_grid[x][y]];
					_vertexIndices.push(index);

					index = _indexLookup[_grid[x + 1][y]];
					_vertexIndices.push(index);

					index = _indexLookup[_grid[x][y + 1]];
					_vertexIndices.push(index);

					index = _indexLookup[_grid[x][y + 1]];
					_vertexIndices.push(index);

					index = _indexLookup[_grid[x + 1][y]];
					_vertexIndices.push(index);

					index = _indexLookup[_grid[x + 1][y + 1]];
					_vertexIndices.push(index);
				}
			}
		}

		private function draw() : void {
			var index : int = 0;
			_holder.graphics.clear();
			for (var x : int = 0; x < _gridX; x++) {
				for (var y : int = 0; y < _gridY; y++) {
					_vertices[index] = _grid[x][y].x;
					_vertices[index + 1] = _grid[x][y].y;
					drawCircle(_vertices[index], _vertices[index + 1], x);
					index += 2;
				}
			}

			graphics.clear();
			// graphics.beginBitmapFill(_bitmapData, null, false, true);
			graphics.beginBitmapFill(new BitmapData(300, 250), null, false, true);
			graphics.drawTriangles(_vertices, _vertexIndices, _uv);
			graphics.endFill();
		}

		private function drawCircle(vertices : Number, vertices1 : Number, xPos : Number) : void {
			var hueA : Number = (360 / 20) * xPos;

			// var hsvCol : HSV = new HSV(0, 50, 100);
			// var hsvColS:String = hsvCol.toString();
			var col : uint = ColorUtil.hsv(hueA, 1, 1);
			_holder.graphics.beginFill(col);
			_holder.graphics.drawCircle(vertices, vertices1, 10);
		}

		private function initVerlet(width : Number, height : Number) : void {
			var connection : VerletConnection;
			var stepX : Number = width / (_gridX - 1),
			stepY : Number = height / (_gridY - 1);
			var minX : Number = stepX / 3,
			maxX : Number = stepX *_maxRatio,
			minY : Number = stepY / 3,
			maxY : Number = stepY * _maxRatio;//3;

			_grid = [];
			_verlet = new VerletSystem();

			for (var x : int = 0; x < _gridX; x++) {
				_grid[x] = [];
				for (var y : int = 0; y < _gridY; y++) {
					_grid[x][y] = new VerletPoint(x * stepX, y * stepY);
					_verlet.addPoint(_grid[x][y]);
					if (y == 0) _grid[x][y].mobileY = false;
				}
			}

			for (x = 0; x < _gridX; x++) {
				for (y = 0; y < _gridY; y++) {
					if (x < _gridX - 1) {
						connection = new VerletConnection(_grid[x][y], _grid[x + 1][y], minX, maxX);
						_verlet.addConnection(connection);
					}

					if (y < _gridY - 1) {
						connection = new VerletConnection(_grid[x][y], _grid[x][y + 1], minY, maxY);
						_verlet.addConnection(connection);
					}

					if (x < _gridX - 1 && y < _gridY - 1) {
						connection = new VerletConnection(_grid[x][y], _grid[x + 1][y + 1], Math.sqrt(minX * minX + minY * minY), Math.sqrt(maxX * maxX + maxY * maxY));
						_verlet.addConnection(connection);
					}

					if (x > 0 && y < _gridY - 1) {
						connection = new VerletConnection(_grid[x][y], _grid[x - 1][y + 1], Math.sqrt(minX * minX + minY * minY), Math.sqrt(maxX * maxX + maxY * maxY));
						_verlet.addConnection(connection);
					}
				}
			}
		}

		private function handleMouseDown(event : MouseEvent) : void {
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			_dragTarget = findClosestPoint(mouseX, mouseY);
			;
		}

		private function findClosestPoint(x : Number, y : Number) : VerletPoint {
			var minDist : Number = Number.POSITIVE_INFINITY;
			var dist : Number;
			var closest : VerletPoint;
			var point : VerletPoint;

			for (var i : int = 0; i < _gridX; i++) {
				for (var j : int = 0; j < _gridY; j++) {
					point = _grid[i][j];
					dist = (x - point.x) * (x - point.x) + (y - point.y) * (y - point.y);
					if (dist < minDist) {
						minDist = dist;
						closest = point;
					}
				}
			}
			return closest;
		}

		private function handleMouseUp(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			_dragTarget = null;
		}

		private function handleEnterFrame(event : Event) : void {
			graphics.clear();

			applyPhysics();

			if (_dragTarget) {
				if (_dragTarget.mobileX) _dragTarget.x = mouseX;
				if (_dragTarget.mobileY) _dragTarget.y = mouseY;
			}

			_verlet.update();
			draw();
		}

		private function applyPhysics() : void {
			for (var x : int = 0; x < _gridX; x++) {
				for (var y : int = 0; y < _gridY; y++) {
					_grid[x][y].velocityY *= (1 - _friction);
					if (y == 0) _grid[x][y].velocityX *= (1 - _frictionTop);
					else {
						_grid[x][y].velocityX *= (1 - _friction);
						_grid[x][y].y += _gravity;
					}

					if (_grid[x][y].x < _minX) _grid[x][y].x = _minX;
					else if (_grid[x][y].x > _maxX) _grid[x][y].x = _maxX;
				}
			}
		}
	}
}