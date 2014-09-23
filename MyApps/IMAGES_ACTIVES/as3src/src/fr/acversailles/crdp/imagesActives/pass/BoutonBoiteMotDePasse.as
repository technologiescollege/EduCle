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
package fr.acversailles.crdp.imagesActives.pass {
	import fr.acversailles.crdp.imagesActives.data.ParametresXML;
	import fr.acversailles.crdp.utils.graphiques.InteractiveSprite;

	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class BoutonBoiteMotDePasse extends InteractiveSprite {
		private var couleurFond : uint;
		private var paddingH : Number;
		private var paddingV : Number;
		private var rayonAngle : Number;
		private var icone : Sprite;
		private var hauteurIcone : Number;
		private var couleurUp : uint;
		private var couleurHover : uint;
		private var couleurDown : uint;

		public function BoutonBoiteMotDePasse(icone : Sprite, couleurUp : uint, couleurHover : uint, couleurDown : uint) {
			this.icone = icone;
			this.couleurDown = couleurDown;
			this.couleurHover = couleurHover;
			this.couleurUp = couleurUp;
						// TODO valeurs magiques
			
			paddingH = ParametresXML.instance.unite * 0.2;
			paddingV= ParametresXML.instance.unite*0.2;
			rayonAngle= ParametresXML.instance.unite*0.3;
			var distanceOmbre : Number= ParametresXML.instance.unite*0.1;
			var distanceBiseau : Number= ParametresXML.instance.unite*0.05;
			hauteurIcone = ParametresXML.instance.unite*1;
			mettreIcone();
			super();
			filters = [new BevelFilter(distanceBiseau), new DropShadowFilter(distanceOmbre, 45, 0, 0.3)];
			cacheAsBitmap = true;
			actualiserApparence(true);
		}

		private function mettreIcone() : void {
			addChild(icone);
			icone.height = hauteurIcone;
			icone.scaleX = icone.scaleY;
			icone.x = paddingH;
			icone.y = paddingV;
		}

		override protected function actualiserApparence(redessiner : Boolean) : void {
			switch(_etat) {
				case UP:
					couleurFond = couleurUp;
					break;
				case DOWN:
					couleurFond = couleurHover;
					break;
				case HOVER:
					couleurFond = couleurDown;
					break;
				default:
			}
			if (redessiner)
				dessinerFond();
		}

		private function dessinerFond() : void {
			graphics.clear();
			graphics.beginFill(couleurFond);
			graphics.drawRoundRect(0, 0, icone.width + 2 * paddingH, icone.height + 2 * paddingV, rayonAngle, rayonAngle);
			graphics.endFill();
		}
	}
}
