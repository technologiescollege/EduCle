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
package fr.acversailles.crdp.imagesActives.textes.boutons {
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.data.ParametresXML;
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.utils.graphiques.InteractiveSprite;

	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class BoutonReponse extends InteractiveSprite {
		private var zoneTexte : TextField;
		private var couleurFond : uint;
		private var paddingH : Number;
		private var paddingV : Number;
		private var rayonAngle : Number;
		private var nameSpaceComportement : Namespace;

		public function BoutonReponse(nameSpaceComportement : Namespace, paddingH : Number, paddingV : Number, rayonAngle : Number, distanceOmbre : Number, distanceBiseau : Number) {
			this.nameSpaceComportement = nameSpaceComportement;
			this.paddingV = paddingV;
			this.paddingH = paddingH;
			this.rayonAngle = rayonAngle;
			mettreZoneTexte();
			super();
			filters=[new BevelFilter(distanceBiseau), new DropShadowFilter(distanceOmbre, 45, 0, 0.3)];
			cacheAsBitmap=true;
			actualiserApparence(true);
		}

		private function mettreZoneTexte() : void {
			zoneTexte=new TextField();
			zoneTexte.mouseEnabled=false;
			zoneTexte.selectable=false;
			zoneTexte.multiline=false;
			zoneTexte.wordWrap=false;
			var police : String = StylesCSS.instance.styleToTextFormat(".answer_button").font;
			zoneTexte.embedFonts = SVGWrapper.instance.policeExiste(police);
			zoneTexte.defaultTextFormat=StylesCSS.instance.styleToTextFormat(".answer_button");
			zoneTexte.autoSize=TextFieldAutoSize.CENTER;
			zoneTexte.text=/*SVGWrapper.instance.enleverCaracteresSansFonts(police,*/ ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "answer_button")/*)*/;
			addChild(zoneTexte);
			zoneTexte.x = paddingH;
			zoneTexte.y = paddingV;
		}

		override protected function actualiserApparence(redessiner : Boolean) : void {
			switch(_etat){
				case UP:
					couleurFond=ParametresXML.instance.getParametreCouleur("answer_button_up_color");
					break;
				case DOWN:
					couleurFond=ParametresXML.instance.getParametreCouleur("answer_button_down_color");
					break;
				case HOVER:
					couleurFond=ParametresXML.instance.getParametreCouleur("answer_button_hover_color");
					break;
				default:
				
			}			
			if(redessiner)
				dessinerFond();
		}

		private function dessinerFond() : void {
			graphics.clear();
			graphics.beginFill(couleurFond);
			graphics.drawRoundRect(0, 0, zoneTexte.width+2*paddingH, zoneTexte.height+2*paddingV, rayonAngle, rayonAngle);
			graphics.endFill();
		}
	}
}
