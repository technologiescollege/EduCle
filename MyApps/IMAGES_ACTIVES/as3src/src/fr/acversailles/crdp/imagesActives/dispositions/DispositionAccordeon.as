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
package fr.acversailles.crdp.imagesActives.dispositions {
	import fr.acversailles.crdp.imagesActives.data.ParametresXML;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.icones.BoutonDescriptionGenerale;
	import fr.acversailles.crdp.imagesActives.textes.IZoneTexte;

	import flash.display.SimpleButton;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class DispositionAccordeon extends Disposition implements IDispositionAccordeon {
		private var _dimensionHZoneImage : Number;

		public function DispositionAccordeon(typeAffichage : uint) {
			ns = new Namespace("http://www.crdp.ac_versailles.fr/2011/images_actives/layouts/accordion");
			super(typeAffichage);
		}

		override protected function determinerDimensionsCadre() : void {
			var margesH : Number = ParametresXML.instance.getParametreDimensions("horizontal_image_text_margin", ns) / 2;
			margesH += ParametresXML.instance.getParametreDimensions("left_margin", ns);
			largeurMaxImage = dimensionHZoneImage - margesH;
			var margesV : Number = ParametresXML.instance.getParametreDimensions("vertical_image_title_margin", ns);
			margesV += ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns);
			margesV += ParametresXML.instance.getParametreDimensions("vertical_image_footer_margin", ns);			
			margesV += ParametresXML.instance.getParametreDimensions("infos_area_tab_height", ns);
			margesV += ParametresXML.instance.getParametreDimensions("infos_area_visible_height", ns);
			hauteurMaxImage = _hauteurTotale - margesV;
		}

		public function getLargeurCartes() : Number {
			var margesH : Number = ParametresXML.instance.getParametreDimensions("horizontal_image_text_margin", ns) / 2;
			margesH += ParametresXML.instance.getParametreDimensions("right_margin", ns);
			return _largeurTotale - dimensionHZoneImage - margesH;
		}

		override public function placerBouton(bouton : SimpleButton, superposer : Boolean = false) : void {
			if (bouton is BoutonDescriptionGenerale) {
				bouton.visible = false;
				return;
			}
			super.placerBouton(bouton, superposer);
		}

		private function get dimensionHZoneImage() : Number {
			if (isNaN(_dimensionHZoneImage)) calculerDimensionHZoneImage();
			return _dimensionHZoneImage;
		}

		private function calculerDimensionHZoneImage() : void {
			var pourcentageLargeur : Number = getParametreLayout("horizontal_image_portion");
			_dimensionHZoneImage = _largeurTotale * pourcentageLargeur;
		}

		public function getHauteurCorpsCartes() : Number {
			return hauteurMaxImage - (SVGWrapper.instance.getNbDetails() + 1) * getHauteurEnTetesCartes();
		}

		public function getHauteurEnTetesCartes() : Number {
			return ParametresXML.instance.getParametreDimensions("cards_headers_height", ns);
		}
		
		public function getLargeurGlissiere() : Number {
			return ParametresXML.instance.getParametreDimensions("cards_scrollbar_width", ns);
		}

		override public function placerZoneTexte(zoneTexte : IZoneTexte) : void {
			zoneTexte.sprite.y = ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns);
			zoneTexte.sprite.y += ParametresXML.instance.getParametreDimensions("vertical_image_title_margin", ns);
			zoneTexte.sprite.x = dimensionHZoneImage + ParametresXML.instance.getParametreDimensions("horizontal_image_text_margin", ns) / 2;
		}

		override public function detailsPucesVisibles() : Boolean {
			return false;
		}


	}
}
