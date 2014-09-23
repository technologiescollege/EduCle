package com.lorentz.SVG.display {
	import com.lorentz.SVG.SVGUtil;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class SVGPattern extends SVGElement implements IViewBox {
		private var _viewBox : Rectangle;

		public function get viewBox() : Rectangle {
			return _viewBox;
		}

		public function set viewBox(value : Rectangle) : void {
			_viewBox = value;
		}

		public var svgX : String;
		public var svgY : String;
		public var svgWidth : String;
		public var svgHeight : String;

		public function SVGPattern() {
			super();
		}

		public override function setDocument(doc : SVGDocument) : void {
			super.setDocument(doc);
			invalidate(true);
		}

		public function getBitmap() : BitmapData {
			validate(true);

			_content.scaleX = _content.scaleY = 1;

//			var _x : Number = getUserUnit(svgX, SVGUtil.WIDTH);
//			var _y : Number = getUserUnit(svgY, SVGUtil.HEIGHT);

			var w : Number = getUserUnit(svgWidth, SVGUtil.WIDTH);
			var h : Number = getUserUnit(svgHeight, SVGUtil.HEIGHT);

			_content.scaleX = w / _content.width;
			_content.scaleY = h / _content.height;

			var bd : BitmapData = new BitmapData(w, h);
			bd.draw(this, null, null, null, null, true);
			return bd;
		}
	}
}