package com.lorentz.SVG.display {
	import com.lorentz.SVG.SVGUtil;

	import flash.geom.Rectangle;

	public class SVG extends SVGG implements IViewBox, IViewPort {
		protected var _svgX : String;

		public function get svgX() : String {
			return _svgX;
		}

		public function set svgX(value : String) : void {
			_svgX = value;
		}

		protected var _svgY : String;

		public function get svgY() : String {
			return _svgY;
		}

		public function set svgY(value : String) : void {
			_svgY = value;
		}

		protected var _svgWidth : String;

		public function get svgWidth() : String {
			return _svgWidth;
		}

		public function set svgWidth(value : String) : void {
			_svgWidth = value;
		}

		protected var _svgHeight : String;

		public function get svgHeight() : String {
			return _svgHeight;
		}

		public function set svgHeight(value : String) : void {
			_svgHeight = value;
		}

		protected var _svgPreserveAspectRatio : String;

		public function get svgPreserveAspectRatio() : String {
			return _svgPreserveAspectRatio;
		}

		public function set svgPreserveAspectRatio(value : String) : void {
			_svgPreserveAspectRatio = value;
		}

		protected var _overflow : String;

		public function get overflow() : String {
			return _overflow;
		}

		public function set overflow(value : String) : void {
			_overflow = value;
		}

		private var _viewBox : Rectangle;

		public function get viewBox() : Rectangle {
			return _viewBox;
		}

		public function set viewBox(value : Rectangle) : void {
			_viewBox = value;
		}

		public function SVG() {
			super();
		}

		override protected function initialize() : void {
			super.initialize();

			addEventListener(SVGDisplayEvent.CHILDREN_SYNC_VALIDATED, childrenValidated);
			addEventListener(SVGDisplayEvent.CHILDREN_ASYNC_VALIDATED, childrenValidated);
		}

		override protected function commitProperties() : void {
			super.commitProperties();

			if ( svgX != null )
				x = getUserUnit(svgX, SVGUtil.WIDTH);
			if ( svgY != null )
				y = getUserUnit(svgY, SVGUtil.HEIGHT);
		}

		protected function childrenValidated(e : SVGDisplayEvent) : void {
			updateView();
		}

		protected function updateView() : void {
			validate();

			_content.scaleX = 1;
			_content.scaleY = 1;
			_content.x = 0;
			_content.y = 0;

			if (svgX != null)
				_content.x += getUserUnit(svgX, SVGUtil.WIDTH);

			if (svgY != null)
				_content.y += getUserUnit(svgY, SVGUtil.HEIGHT);

			var box : Rectangle = null;
			if (viewBox != null) {
				box = viewBox;
				_content.x -= box.left;
				_content.y -= box.top;

				if (svgWidth != null && svgHeight != null && svgWidth.indexOf("%") == -1 && svgHeight.indexOf("%") == -1) {
					var w : Number = getUserUnit(svgWidth, SVGUtil.WIDTH);
					var h : Number = getUserUnit(svgHeight, SVGUtil.HEIGHT);

					_content.scaleX = w / box.width;
					_content.scaleY = h / box.height;

					var preserveAspectRatio : String = svgPreserveAspectRatio == null ? "xmidymid meet" : svgPreserveAspectRatio.toLowerCase();

					if (preserveAspectRatio != "none") {
						_content.scaleX = Math.min(_content.scaleX, _content.scaleY);
						_content.scaleY = Math.min(_content.scaleX, _content.scaleY);
					}
				}
			} else if (svgWidth != null && svgHeight != null && svgWidth.indexOf("%") == -1 && svgHeight.indexOf("%") == -1) {
				var w_ : Number = getUserUnit(svgWidth, SVGUtil.WIDTH);
				var h_ : Number = getUserUnit(svgHeight, SVGUtil.HEIGHT);
				box = new Rectangle(0, 0, w_, h_);
			}

			if (box != null && (overflow == "hidden" || overflow == "scroll"))
				_content.scrollRect = box;
			else
				_content.scrollRect = null;
		}

		override public function clone(deep : Boolean = true) : SVGElement {
			var c : SVG = super.clone(deep) as SVG;
			c.svgX = svgX;
			c.svgY = svgY;
			c.svgWidth = svgWidth;
			c.svgHeight = svgHeight;
			c.svgPreserveAspectRatio = svgPreserveAspectRatio;

			c.viewBox = (viewBox != null) ? viewBox.clone() : null;
			return c;
		}
	}
}