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
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.data.ParametresXML;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.textes.IZoneTexte;

	import flash.geom.Point;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class DispositionLegendesHautBas extends DispositionAvecDefilement implements IDispositionLegendesHautBas {
		public static const TOP : uint = 0;
		public static const BOTTOM : uint = 1;
		private var pourcentageHauteur : Number;
		private var espaceVerticalLegendes : Number;
		private var _position : uint;
		private var positionVLegendes : Number;

		public function DispositionLegendesHautBas(typeAffichage : uint) {
			ns = new Namespace("http://www.crdp.ac_versailles.fr/2011/images_actives/layouts/top_bottom_captions");
			_position = ContenuXML.instance.getParametreDispositionSpecifiques(ns, "captions_position");
			super(typeAffichage);
		}

		override protected function determinerDimensionsCadre() : void {
			var dimensionHZoneImage : Number = _largeurTotale;
			var margesH : Number = ParametresXML.instance.getParametreDimensions("left_margin", ns);
			margesH += ParametresXML.instance.getParametreDimensions("right_margin", ns);
			largeurMaxImage = dimensionHZoneImage - margesH;
			
			pourcentageHauteur = getParametreLayout("vertical_image_portion");

			espaceVerticalLegendes = _hauteurTotale * (1 - pourcentageHauteur) ;
			hauteurMaxImage = hauteurTotale * pourcentageHauteur;
			if (_position == BOTTOM) {
				espaceVerticalLegendes -= ParametresXML.instance.getParametreDimensions("infos_area_visible_height", ns);
				espaceVerticalLegendes -= ParametresXML.instance.getParametreDimensions("infos_area_tab_height", ns);
				espaceVerticalLegendes -= ParametresXML.instance.getParametreDimensions("caption_bottom_margin", ns);
				espaceVerticalLegendes -= ParametresXML.instance.getParametreDimensions("caption_bottom_margin", ns) / 2;
				hauteurMaxImage -= ParametresXML.instance.getParametreDimensions("vertical_image_title_margin", ns);
				hauteurMaxImage -= ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns);
				hauteurMaxImage -= ParametresXML.instance.getParametreDimensions("vertical_image_text_margin", ns) / 2;
			} else {
				espaceVerticalLegendes -= ParametresXML.instance.getParametreDimensions("vertical_text_title_margin", ns);
				espaceVerticalLegendes -= ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns);
				espaceVerticalLegendes -= ParametresXML.instance.getParametreDimensions("vertical_image_text_margin", ns) / 2;
				hauteurMaxImage -= ParametresXML.instance.getParametreDimensions("infos_area_visible_height", ns);
				hauteurMaxImage -= ParametresXML.instance.getParametreDimensions("infos_area_tab_height", ns);
				hauteurMaxImage -= ParametresXML.instance.getParametreDimensions("vertical_image_text_margin", ns) / 2;
				hauteurMaxImage -= ParametresXML.instance.getParametreDimensions("vertical_image_footer_margin", ns);
			}
		}

		override protected function limiteInferieureTitre() : Number {
			if (_position == TOP) return ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns);
			else return super.limiteInferieureTitre();
		}

		override protected function positionnerFond() : void {
			super.positionnerFond();
			switch(_position) {
				case TOP:
					_yFond += espaceVerticalLegendes + ParametresXML.instance.getParametreDimensions("caption_bottom_margin", ns);
					positionVLegendes = ParametresXML.instance.getParametreDimensions("vertical_toolbar_area", ns) + ParametresXML.instance.getParametreDimensions("vertical_text_title_margin", ns);;
					break;
				case BOTTOM:
					positionVLegendes = _yFond + hauteurFond + ParametresXML.instance.getParametreDimensions("vertical_image_text_margin", ns);
					break;
			}
			SVGWrapper.instance.fond.y = _yFond;
		}

		override public function placerZoneTexte(zoneTexte : IZoneTexte) : void {
			zoneTexte.sprite.x = 0;
			zoneTexte.sprite.y = 0;
		}

		public function getLargeurSelecteurs() : Number {
			return ParametresXML.instance.getParametreDimensions("caption_selector_width", ns);
		}

		public function getPositionSelecteur(numero : int) : Point {
			var pos : Point = new Point();
			pos.x = numero * (getLargeurSelecteurs() + ParametresXML.instance.getParametreDimensions("caption_selector_horizontal_margin", ns));
			pos.y = ParametresXML.instance.getParametreDimensions("caption_selector_top_margin", ns);
			pos.offset(xFond, positionVLegendes);
			return pos;
		}

		public function getMargeInfSelecteurs() : Number {
			return ParametresXML.instance.getParametreDimensions("caption_selector_bottom_margin", ns);
		}

		public function getMargeInfLegende() : Number {
			return ParametresXML.instance.getParametreDimensions("caption_bottom_margin", ns);
		}

		public function getPosition() : uint {
			return _position;
		}
		override public function detailsPucesVisibles() : Boolean {
			return false;
		}

	}
}
