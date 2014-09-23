 /**
 * Copyright (c) 2011 Centre Régional de Documentation Pédagogique de l'Académie de Versailles 
 * Images Actives is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * at your option) any later version.
 * Images Actives is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Images Actives.  If not, see <http://www.gnu.org/licenses/>.
 **/
package fr.acversailles.crdp.imagesActives.image.details {
	import fr.acversailles.crdp.utils.functions.mesurerZoneOpaque;

	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;

	import fr.acversailles.crdp.imagesActives.ImageActive;
	import fr.acversailles.crdp.imagesActives.controle.SynchronisationEvent;
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class Detail extends Bitmap implements IDetail {
		private var _idDetail : uint;
		private var filtreFaible : GlowFilter;
		private var filtreFort : GlowFilter;
		private var zoomabilite : Boolean;
		private var detailPuce : Boolean;
		private var rectangleZoom : Rectangle;
		private var rectangleOrigine : Rectangle;
		private var tweenX : Tween;
		private var tweenY : Tween;
		private var tweenW : Tween;
		private var tweenH : Tween;
		private var tweenXRetour : Tween;
		private var tweenYRetour : Tween;
		private var tweenWRetour : Tween;
		private var tweenHRetour : Tween;
		private var _formeEnCreu : Bitmap;
		private static var noircissement : ColorTransform;
		private var emphaseFaible : ColorTransform;
		private var sansEmphase : ColorTransform;
		private var dureeZoom : Number;
		private var _resolution : Rectangle;
		private var refParent : DisplayObjectContainer;
		private var visibilite : Boolean;

		public function Detail(idDetail : uint, data : BitmapData, zoomabilite : Boolean, detailPuce : Boolean, visibilite : Boolean) {
			this.visibilite = visibilite;
			this.detailPuce = detailPuce;
			this.zoomabilite = zoomabilite;

			_idDetail = idDetail;
			super(data);
			_resolution = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);

			creerFiltres();
			visible = detailPuce && visibilite;
			pixelSnapping = PixelSnapping.AUTO;
			smoothing = true;

			dureeZoom = ContenuXML.instance.getParamInteractiviteCommun("zoom_duration");
			creerTransforms();
		}

		private function creerTransforms() : void {
			sansEmphase = this.transform.colorTransform;
			emphaseFaible = new ColorTransform();
			emphaseFaible.color = ContenuXML.instance.getParamInteractiviteCommun("roll_over_coloration");
			emphaseFaible.blueMultiplier = emphaseFaible.greenMultiplier = emphaseFaible.redMultiplier = ContenuXML.instance.getParamInteractiviteCommun("roll_over_brightness");
		}

		public function dimensionner(x : Number, y : Number, width : Number, height : Number, largeurOriginaleFond : Number, hauteurOriginaleFond : Number) : void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.rectangleOrigine = new Rectangle(x, y, width, height);
		}

		public function get displayObject() : DisplayObject {
			return this;
		}

		public function get idDetail() : uint {
			return _idDetail;
		}

		public function pixelOpaqueAuPoint(localX : Number, localY : Number) : Boolean {
			if (detailPuce && !visibilite) return false;
			return (bitmapData.getPixel32(localX / scaleX, localY / scaleY) >> 24 & 0xFF) > 0;
		}

		public function emphaseLegere() : void {
			filters = [filtreFaible];
			transform.colorTransform = emphaseFaible;
			visible = true;
		}

		private function creerFiltres() : void {
			filtreFaible = new GlowFilter(ContenuXML.instance.getParamInteractiviteCommun("outline_color"), ContenuXML.instance.getParamInteractiviteCommun("outline_alpha"), ContenuXML.instance.getParamInteractiviteCommun("outline_thickness"), ContenuXML.instance.getParamInteractiviteCommun("outline_thickness"), ContenuXML.instance.getParamInteractiviteCommun("outline_intensity"));
			filtreFort = new GlowFilter(ContenuXML.instance.getParamInteractiviteCommun("outline_color"), ContenuXML.instance.getParamInteractiviteCommun("outline_alpha"), ContenuXML.instance.getParamInteractiviteCommun("outline_thickness"), ContenuXML.instance.getParamInteractiviteCommun("outline_thickness"), ContenuXML.instance.getParamInteractiviteCommun("outline_intensity"));
		}

		public function emphaseForte() : void {
			filters = [filtreFort];
			transform.colorTransform = sansEmphase;
			visible = visibilite;
		}

		public function aucuneEmphase() : void {
			filters = [];
			transform.colorTransform = sansEmphase;
			visible = detailPuce && visibilite;
		}

		public function get zoomable() : Boolean {
			return this.zoomabilite ;
		}

		public function getRectangle() : Rectangle {
			var rect : Rectangle = mesurerZoneOpaque(bitmapData);
			rect.x *= scaleX;
			rect.y *= scaleX;
			rect.width *= scaleX;
			rect.height *= scaleX;
			return rect;
		}

		public function configurerZoom(rectangleCadre : Rectangle, rectangleDetail : Rectangle) : void {
			this.rectangleZoom = rectangleCadre;
		}

		private function creerTweens() : void {
			tweenX = new Tween(this, "x", Regular.easeOut, rectangleOrigine.x, rectangleZoom.x, dureeZoom, false);
			tweenY = new Tween(this, "y", Regular.easeOut, rectangleOrigine.y, rectangleZoom.y, dureeZoom, false);
			tweenW = new Tween(this, "width", Regular.easeOut, rectangleOrigine.width, rectangleZoom.width, dureeZoom, false);
			tweenH = new Tween(this, "height", Regular.easeOut, rectangleOrigine.height, rectangleZoom.height, dureeZoom, false);
			tweenX.stop();
			tweenY.stop();
			tweenW.stop();
			tweenH.stop();
		}

		private function creerTweensRetour() : void {
			tweenXRetour = new Tween(this, "x", Regular.easeOut, this.rectangleZoom.x, this.rectangleOrigine.x, dureeZoom, false);
			tweenYRetour = new Tween(this, "y", Regular.easeOut, this.rectangleZoom.y, this.rectangleOrigine.y, dureeZoom, false);
			tweenWRetour = new Tween(this, "width", Regular.easeOut, this.rectangleZoom.width, this.rectangleOrigine.width, dureeZoom, false);
			tweenHRetour = new Tween(this, "height", Regular.easeOut, this.rectangleZoom.height, this.rectangleOrigine.height, dureeZoom, false);
			tweenXRetour.stop();
			tweenYRetour.stop();
			tweenWRetour.stop();
			tweenHRetour.stop();
		}

		public function zoomer() : void {
			refParent = parent;
			ImageActive.supportCurseur.addChild(this);
			filters = [];
			if (!tweenX) creerTweens();
			tweenX.addEventListener(TweenEvent.MOTION_FINISH, gererFinZoom);
			tweenX.start();
			tweenY.start();
			tweenW.start();
			tweenH.start();
		}

		private function gererFinZoom(event : TweenEvent) : void {
			tweenX.removeEventListener(TweenEvent.MOTION_FINISH, gererFinZoom);
			dispatchEvent(new SynchronisationEvent(SynchronisationEvent.FIN_ZOOM));
		}

		public function dezoomer() : void {
			if (!tweenXRetour) creerTweensRetour();
			tweenXRetour.addEventListener(TweenEvent.MOTION_FINISH, gererFinDezoom);
			tweenXRetour.start();
			tweenYRetour.start();
			tweenWRetour.start();
			tweenHRetour.start();
		}

		private function gererFinDezoom(event : TweenEvent) : void {
			tweenXRetour.removeEventListener(TweenEvent.MOTION_FINISH, gererFinDezoom);
			dispatchEvent(new SynchronisationEvent(SynchronisationEvent.FIN_DEZOOM));
		}

		public function get formeEnCreu() : Bitmap {
			if (!_formeEnCreu) {
				_formeEnCreu = new Bitmap(bitmapData.clone());
				_formeEnCreu.x = x;
				_formeEnCreu.y = y;
				_formeEnCreu.width = width;
				_formeEnCreu.height = height;
				if (!noircissement) {
					noircissement = new ColorTransform();
					noircissement.color = 0;
				}
				_formeEnCreu.transform.colorTransform = noircissement;
			}

			return _formeEnCreu;
		}

		public function get resolution() : Rectangle {
			return _resolution;
		}

		public function get isPuce() : Boolean {
			return detailPuce;
		}

		public function forcerMasquage(bool : Boolean) : void {
			if (detailPuce && visibilite) visible = !bool;
		}
	}
}
