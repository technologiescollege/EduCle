package com.lorentz.SVG.display {
	import flash.geom.Rectangle;

	public class SVGSymbol extends SVGG implements IViewBox {
		private var _viewBox : Rectangle;

		public function get viewBox() : Rectangle {
			return _viewBox;
		}

		public function set viewBox(value : Rectangle) : void {
			_viewBox = value;
		}

		protected var _svgPreserveAspectRatio : String;

		public function get svgPreserveAspectRatio() : String {
			return _svgPreserveAspectRatio;
		}

		public function set svgPreserveAspectRatio(value : String) : void {
			_svgPreserveAspectRatio = value;
		}

		public function SVGSymbol() {
			super();
		}
	}
}