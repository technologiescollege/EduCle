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
package fr.acversailles.crdp.imagesActives.textes.legendesHautBas {
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.icones.ContourBoutonVide;
	import fr.acversailles.crdp.imagesActives.icones.FindBoutonPlein;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class SelecteurLegende extends Sprite implements ISelecteurLegende {
		private static const PROPORTION_HAUTEUR_TEXTE : Number = 0.7;
		private static const UP : uint = 0;
		private static const OVER : uint = 1;
		private var contour : Sprite;
		private var fond : Sprite;
		private var zoneNumero : TextField;
		private var largeur : Number;
		private var hauteur : Number;
		private var _etat : uint;
		private var _selection : Boolean;
		private var colorationBord : ColorTransform;
		private var colorationFond : ColorTransform;
		private var glow : GlowFilter;
		private var _numero : uint;

		public function SelecteurLegende(largeur : Number, numero : uint) {
			_numero = numero;
			this.largeur = largeur;
			contour = new ContourBoutonVide();
			fond = new FindBoutonPlein();
			var coeff : Number = largeur / fond.width;
			contour.width *= coeff;
			contour.height *= coeff;
			fond.width *= coeff;
			fond.height *= coeff;
			hauteur = contour.height;
			addChild(fond);
			addChild(contour);
			mettreNumero();
			_etat = UP;
			_selection = false;
			colorationBord = new ColorTransform();
			colorationFond = new ColorTransform();
			glow = new GlowFilter(ContenuXML.instance.getParametreCouleur("color_3"));
			actualiser();
			addEventListener(MouseEvent.MOUSE_OVER, gererInteraction);
			addEventListener(MouseEvent.MOUSE_OUT, gererInteraction);
			mouseChildren = false;
			buttonMode = true;
		}

		private function gererInteraction(event : MouseEvent) : void {
			switch(event.type) {
				case MouseEvent.MOUSE_OVER:
					_etat = OVER;
					break;
				case MouseEvent.MOUSE_OUT:
					_etat = UP;
					break;
			}
			actualiser();
		}

		private function actualiser() : void {
			var couleurBord : uint;
			var couleurFond : uint;
			if (!_selection) {
				couleurBord = ContenuXML.instance.getParametreCouleur("color_3");
				couleurFond = ContenuXML.instance.getParametreCouleur("color_1");
			} else {
				couleurBord = ContenuXML.instance.getParametreCouleur("color_3");
				couleurFond = ContenuXML.instance.getParametreCouleur("color_2");
			}
			switch(_etat) {
				case UP:
					filters = [];
					break;
				case OVER:
					filters = [glow];
					break;
				default:
			}
			colorationBord.color = couleurBord;
			colorationFond.color = couleurFond;
			fond.transform.colorTransform = colorationFond;
			contour.transform.colorTransform = colorationBord;
		}

		private function mettreNumero() : void {
			zoneNumero = new TextField();
			zoneNumero.text = /*SVGWrapper.instance.enleverCaracteresSansFonts(StylesCSS.instance.styleToTextFormat(".caption_selector").font,*/ String(_numero)/*)*/;
			zoneNumero.multiline = false;
			zoneNumero.embedFonts = SVGWrapper.instance.policeExiste(StylesCSS.instance.styleToTextFormat(".caption_selector").font);
			zoneNumero.wordWrap = false;
			zoneNumero.selectable = false;
			zoneNumero.mouseWheelEnabled = false;
			zoneNumero.antiAliasType = AntiAliasType.ADVANCED;
			zoneNumero.autoSize = TextFieldAutoSize.LEFT;
			var format : TextFormat = StylesCSS.instance.styleToTextFormat(".caption_selector");
			zoneNumero.setTextFormat(format);
			while (zoneNumero.textHeight > hauteur * PROPORTION_HAUTEUR_TEXTE) {
				format.size = Number(format.size) - 1;
				zoneNumero.setTextFormat(format);
			}
			zoneNumero.x = (width - zoneNumero.width) / 2;
			zoneNumero.y = (height - zoneNumero.height) / 2;
			addChild(zoneNumero);
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function get numero() : uint {
			return _numero;
		}

		public function selectionner(boolean : Boolean) : void {
			_selection = boolean;
			actualiser();
		}
	}
}
