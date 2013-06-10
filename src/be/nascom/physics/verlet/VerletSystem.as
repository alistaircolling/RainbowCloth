package be.nascom.physics.verlet
{

	
	public class VerletSystem
	{
		private var _connections : Vector.<VerletConnection> = new Vector.<VerletConnection>();
		private var _points : Vector.<VerletPoint> = new Vector.<VerletPoint>();
		
		public function VerletSystem()
		{
		}
		
		public function addPoint(point : VerletPoint) : void
		{
			_points.push(point);
		}
		
		public function addConnection(connection : VerletConnection) : void
		{
			_connections.push(connection);
		}
		
		public function update() : void
		{
			var i : int;
			var connection : VerletConnection;
			
			i = _points.length;
			while (i > 0) {
				_points[--i].update();
			}
			
			i = _connections.length;
			while (i > 0) {
				_connections[--i].update();
			}
		}
		
	}
}