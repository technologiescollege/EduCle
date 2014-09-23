package com.lorentz.SVG.display {
	
	public class SVGShape extends SVGElement {	
		public function SVGShape(){
			super();
			mouseChildren = false;
			_validateFunctions.push(render);
		}

		protected function render():void {
		}
	}
}