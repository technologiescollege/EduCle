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
package fr.acversailles.crdp.imagesActives.image {
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;

	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.dispositions.IDisposition;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.image.controle.ControleurImage;
	import fr.acversailles.crdp.imagesActives.image.controle.IControleurImage;
	import fr.acversailles.crdp.imagesActives.image.details.GestionDetails;
	import fr.acversailles.crdp.imagesActives.image.details.IGestionDetails;

	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ZoneImage extends Sprite implements IZoneImage {
		private var disposition : IDisposition;
		private var gestionnaireDetails : IGestionDetails;
		private var controleur : IControleurImage;
		private var voile : Shape;
		private var tweenApparitionVoile : Tween;
		private var estompage : Boolean;
		private var fondZoom : Shape;
		private var tweenFondZoom : Tween;
		private var dureeZoom : Number;
		private var couleurFondZoom : Number;
		private var alphaFondZoom : Number;
		private var masqueLocal : Shape;
		private var masqueGlobal : Shape;
		private var dureeEstompage : Number;

		public function ZoneImage(disposition : IDisposition) {
			this.disposition = disposition;
			dureeZoom = ContenuXML.instance.getParamInteractiviteCommun("zoom_duration");
			couleurFondZoom = ContenuXML.instance.getParamInteractiviteCommun("zoom_background_color");
			alphaFondZoom = ContenuXML.instance.getParamInteractiviteCommun("zoom_background_alpha");
			dureeEstompage = disposition.getDureeEstompageImage();
			disposition.disposerFondImage();
			placerFond();
			creerMasques();
			creerVoile();
			creerTweenVoile();
			creerGestionnaires();
			gestionnaireDetails.ajouterSupportFormesEnCreu(this);
			creerFondZoom();
			gestionnaireDetails.placerDetails(this);
		}

		private function creerMasques() : void {
			masqueLocal = disposition.getMasqueImage();
			addChild(masqueLocal);
			masqueGlobal = disposition.getMasqueGlobal();
			mettreMasque(true);
			
		}

		private function creerGestionnaires() : void {
			var classeGestionDetails : Class;
			var classeControleur : Class;

			gestionnaireDetails = new GestionDetails(disposition);

			controleur = new ControleurImage(this, gestionnaireDetails);
		}

		private function placerFond() : void {
			SVGWrapper.instance.fond.smoothing=true;
			addChild(SVGWrapper.instance.fond);
			
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function emphaseLegereDetail(idDetail : uint) : void {
			gestionnaireDetails.emphaseLegereDetail(idDetail);
			estomperFond(false);
		}

		public function emphaseForteDetail(idDetail : uint, estomperContexte:Boolean=true) : void {
			gestionnaireDetails.emphaseForteDetail(idDetail);
			estomperFond(estomperContexte);
		}

		public function aucuneEmphaseDetail(idDetail : int=-1) : void {
			//-1 = concerne tous les details
			gestionnaireDetails.aucuneEmphaseDetail(idDetail);
			estomperFond(false);
		}

		private function estomperFond(nouvelEstompage : Boolean) : void {
			if (nouvelEstompage == estompage) return;
			estompage = nouvelEstompage;
			if (estompage) tweenApparitionVoile.start();
			else {
				tweenApparitionVoile.stop();
				voile.alpha = 0;
			}
		}

		private function creerTweenVoile() : void {
			tweenApparitionVoile = new Tween(voile, "alpha", Regular.easeOut, 0, ContenuXML.instance.getParamInteractiviteCommun("shading_alpha"), dureeEstompage);
			tweenApparitionVoile.stop();
		}

		private function creerVoile() : void {
			voile = new Shape();
			voile.graphics.beginFill(ContenuXML.instance.getParamInteractiviteCommun("shading_color"), 1);
			voile.graphics.drawRect(disposition.xFond, disposition.yFond, disposition.largeurFond, disposition.hauteurFond);
			voile.graphics.endFill();
			voile.alpha = 0;
			addChild(voile);
		}

		public function detailZoomable(idDetail : uint) : Boolean {
			return gestionnaireDetails.detailZoomable(idDetail);
		}
		
		public function detailPuce(idDetail : uint) : Boolean {
			return gestionnaireDetails.detailPuce(idDetail);
		}

		public function zoomerDetail(idDetail : uint) : void {
			gestionnaireDetails.zoomerDetail(idDetail);
			estomperFond(false);
		}

		public function dezoomerDetail(idDetail : uint) : void {
			gestionnaireDetails.dezoomerDetail(idDetail);
			afficherFondZoom(false);
		}

		public function afficherFondZoom(boolean : Boolean) : void {
			tweenFondZoom.continueTo(boolean ? alphaFondZoom : 0, dureeZoom);
		}

		private function creerFondZoom() : void {
			fondZoom = new Shape();
			fondZoom.graphics.beginFill(couleurFondZoom);
			fondZoom.graphics.drawRect(0, 0, disposition.largeurTotale, disposition.hauteurTotale);
			fondZoom.graphics.endFill();
			addChild(fondZoom);
			tweenFondZoom = new Tween(fondZoom, "alpha", Regular.easeOut, 0, 0, dureeZoom);
			fondZoom.alpha = 0;
		}

		public function mettreMasque(boolean : Boolean) : void {
			mask = boolean ? masqueLocal : null;
			if(boolean && !contains(masqueLocal)) addChild(masqueLocal);
			if(!boolean && contains(masqueLocal)) removeChild(masqueLocal);
		}

		public function emphaseTousDetails() : void {
			gestionnaireDetails.emphaseTousdetails();
		}

	}
}
