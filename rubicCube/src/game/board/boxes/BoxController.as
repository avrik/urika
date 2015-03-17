package game.board.boxes 
{
	import mvc.Controller;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class BoxController extends Controller 
	{
		private var _view:BoxView;
		private var _model:BoxModel;
		
		public function BoxController(boxView:BoxView, boxModel:BoxModel) 
		{
			super();
			this._model = boxModel;
			this._view = boxView;
			
			this._view.draw();
		}
		
		public function get view():BoxView 
		{
			return _view;
		}
		
		public function get model():BoxModel 
		{
			return _model;
		}
		
	}

}