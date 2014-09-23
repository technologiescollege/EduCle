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
	import fr.acversailles.crdp.imagesActives.controle.SynchronisationEvent;
	import fr.acversailles.crdp.imagesActives.dispositions.IDisposition;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.image.IZoneImage;

	import flash.display.Sprite;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class GestionDetails implements IGestionDetails {
		private var disposition : IDisposition;
		private var details : Vector.<IDetail> ;
		private var zoneImage : IZoneImage;
		private var supportFormesEnCreu : Sprite;

		public function GestionDetails(disposition : IDisposition) {
			this.disposition = disposition;
			this.details = new Vector.<IDetail>(SVGWrapper.instance.getNbDetails());
		}

		public function ajouterSupportFormesEnCreu(zoneImage : IZoneImage) : void {
			this.supportFormesEnCreu = new Sprite();
			zoneImage.sprite.addChild(supportFormesEnCreu);
		}

		public function placerDetails(zoneImage : IZoneImage) : void {
			this.zoneImage = zoneImage;
			var detail : IDetail;
			for (var i : int = 0; i < SVGWrapper.instance.getNbDetails(); i++) {
				var zoomabilite : Boolean = SVGWrapper.instance.isDetailZoomable(i);
				var detailPuce : Boolean = SVGWrapper.instance.isPuce(i);
				detail = new Detail(i, SVGWrapper.instance.getDetail(i).bitmapData, zoomabilite, detailPuce, !detailPuce || disposition.detailsPucesVisibles());
				if(detailPuce) {
					
				}
				else {
				detail.displayObject.addEventListener(SynchronisationEvent.FIN_DEZOOM, gererFinDezoom);
				detail.displayObject.addEventListener(SynchronisationEvent.FIN_ZOOM, gererFinZoom);
				}
				disposition.disposerDetail(detail);
				zoneImage.sprite.addChild(detail.displayObject);
				details[i] = detail;
			}
		}

		public function numeroDetailAuPoint(localX : Number, localY : Number) : int {
			for each (var detail : IDetail in details) {
				if (detail.pixelOpaqueAuPoint(localX - disposition.xFond, localY - disposition.yFond)) {
					return detail.idDetail;
				}
			}
			return -1;
		}

		public function emphaseLegereDetail(idDetail : uint) : void {
			details[idDetail].emphaseLegere();
		}

		public function emphaseForteDetail(idDetail : uint) : void {
			details[idDetail].emphaseForte();
		}

		public function aucuneEmphaseDetail(idDetail : int) : void {
			if (idDetail >= 0)
				details[idDetail].aucuneEmphase();
			else {
				for each (var detail : Detail in details) {
					detail.aucuneEmphase();
				}
			}
		}

		public function detailZoomable(idDetail : uint) : Boolean {
			return details[idDetail].zoomable && ! detailPuce(idDetail);
		}
		public function detailPuce(idDetail : uint) : Boolean {
			return details[idDetail].isPuce;
		}

		public function zoomerDetail(idDetail : uint) : void {
			this.supportFormesEnCreu.addChild(details[idDetail].formeEnCreu);
			for each (var detail : Detail in details) {
				if(detail.idDetail !=idDetail) detail.forcerMasquage(true);
			}
			details[idDetail].zoomer();
			zoneImage.mettreMasque(false);
		}

		public function dezoomerDetail(idDetail : uint) : void {
			for each (var detail : Detail in details) {
				if(detail.idDetail !=idDetail) detail.forcerMasquage(false);
			}
			details[idDetail].dezoomer();
		}

		private function gererFinZoom(event : SynchronisationEvent) : void {
			zoneImage.sprite.dispatchEvent(new SynchronisationEvent(SynchronisationEvent.FIN_ZOOM));
		}

		private function gererFinDezoom(event : SynchronisationEvent) : void {
			while (this.supportFormesEnCreu.numChildren > 0)
				this.supportFormesEnCreu.removeChild(this.supportFormesEnCreu.getChildAt(0));
			zoneImage.mettreMasque(true);
			zoneImage.sprite.dispatchEvent(new SynchronisationEvent(SynchronisationEvent.FIN_DEZOOM));
		}

		public function emphaseTousdetails() : void {
			for each (var detail : Detail in details) {
				if(!detail.isPuce)
					detail.emphaseLegere();
			}
		}
	}
}
