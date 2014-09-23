﻿package com.lorentz.SVG.display {
	import com.lorentz.SVG.Base64Decoder;
	import com.lorentz.SVG.SVGUtil;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class SVGImage extends SVGElement implements IViewPort {
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
		
		public var svgHref:String;
		
		protected var _loader:Loader;
		
		protected var _originalWidth:Number;
		protected var _originalHeight:Number;
		
		public function SVGImage() {
			super();
		}
		
		override protected function initialize():void {
			super.initialize();
			//_validateFunctions.push(loadImage);
		}
				
		public function loadURL(url:String):void {
			if(_loader!=null){
				removeChild(_loader);
				_loader = null;
			}
			
			if(url!=null){
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
				_loader.load(new URLRequest(url));
				this.addChild(_loader);
			}
		}
		
		//Thanks to youzi530, for coding base64 embed image support
		public function loadBase64(content:String):void
		{
			var decoder:Base64Decoder = new Base64Decoder();
			var byteArray:ByteArray;
			
			var base64String:String = content;
			
			base64String = base64String.replace(/^data:[a-z\/]*;base64,/, '');
			
			decoder.decode(base64String);
			byteArray = decoder.flush();
			
			loadBytes(byteArray);
		}
		
		public function loadBytes(byteArray:ByteArray):void {
			if(_loader!=null){
				removeChild(_loader);
				_loader = null;
			}
			
			if(byteArray!=null){
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
				_loader.loadBytes(byteArray);
				this.addChild(_loader);
			}
		}
		
		override protected function commitProperties():void {
			if( svgX != null )
                x = getUserUnit(svgX, SVGUtil.WIDTH);
            if( svgY != null )
                y =  getUserUnit(svgY, SVGUtil.HEIGHT);
		}
		
		protected function loadImage():void {
			if(_loader!=null)
				return;
				
			if(svgHref.match(/^data:[a-z\/]*;base64,/)){
				loadBase64(svgHref);
			} else {
				loadURL(document.resolveURL(svgHref));
				beginASyncValidation("loadImage");
			}
		}
		
		private function loadComplete(event:Event):void {
			if(_loader.content is Bitmap)
				(_loader.content as Bitmap).smoothing = true;
				
			_originalWidth = _loader.content.width;
			_originalHeight = _loader.content.height;
			
			updateView();
		}
		
		private function loadError(e:IOErrorEvent):void {
			trace("Failed to load image");
			updateView();
		}
			
		public function updateView():void {
			endASyncValidation("loadImage");
							
			if(_loader!=null){
				var x:Number = 0;
				var y:Number = 0;
				
				var _width:Number = svgWidth==null ? _originalWidth : getUserUnit(svgWidth, SVGUtil.WIDTH);
				var _height:Number = svgHeight==null ? _originalHeight : getUserUnit(svgHeight, SVGUtil.HEIGHT);
				
				var w:Number = _width;
				var h:Number = _height;
				
				/*if(_preserveAspectRatio){
					var rw:Number = w / _originalWidth;
					var rh:Number = h / _originalHeight;
					if(rw>rh){
						w = rh*_originalWidth;
						x = (_width - w) / 2; 
					} else {
						h = rw*_originalHeight;
						y = (_height - h) / 2;
					}
				}*/
				
				_loader.x = x;
				_loader.y = y;
				_loader.width = w;
				_loader.height = h;
			}
		}
		
		override public function clone(deep:Boolean = true):SVGElement {
			var c:SVGImage = super.clone(deep) as SVGImage;
			c.svgX = svgX;
			c.svgY = svgY;
			c.svgWidth = svgWidth;
			c.svgHeight = svgHeight;
			c.svgPreserveAspectRatio = svgPreserveAspectRatio;
			c.svgHref = svgHref;
			return c;
		}
	}
}