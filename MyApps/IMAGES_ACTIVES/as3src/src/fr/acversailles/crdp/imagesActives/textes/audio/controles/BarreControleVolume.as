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
package fr.acversailles.crdp.imagesActives.textes.audio.controles {
	import flash.events.MouseEvent;
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import flash.display.Sprite;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	internal class BarreControleVolume extends Sprite {
		private static const EPAISSEUR_NORMALE : Number = 0.5;
		private static const EPAISSEUR_FORTE : Number=1;
		private var largeur : Number;
		private var hauteurDroite : Number;
		private var hauteurGauche : Number;
		private var epaisseurTrait : Number;
		private var couleurFond : uint;
		private var _activation : Boolean;

		public function BarreControleVolume(largeur : Number, hauteurDroite : Number, hauteurGauche : Number) {
			this.hauteurGauche = hauteurGauche;
			this.hauteurDroite = hauteurDroite;
			this.largeur = largeur;
			dessinerBarre();
			addEventListener(MouseEvent.MOUSE_OVER, gererMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, gererMouseOut);
			gererMouseOut(null);
			buttonMode=true;
		}

		private function gererMouseOut(event : MouseEvent) : void {
			epaisseurTrait = EPAISSEUR_NORMALE;
			//TODO en faire un paramètre
			couleurFond= _activation?ContenuXML.instance.getParametreCouleur("color_1"):0x000000;
			dessinerBarre();
		}

		private function gererMouseOver(event : MouseEvent) : void {
			epaisseurTrait = EPAISSEUR_FORTE;
			//TODO en faire un paramètre
			couleurFond= ContenuXML.instance.getParametreCouleur("color_1");
			dessinerBarre();
		}

		private function dessinerBarre() : void {
			graphics.clear();
			graphics.lineStyle(epaisseurTrait, ContenuXML.instance.getParametreCouleur("color_3"));
			graphics.beginFill(couleurFond);
			graphics.moveTo(0, hauteurDroite);
			graphics.lineTo(0, hauteurDroite-hauteurGauche);
			graphics.lineTo(largeur, 0);
			graphics.lineTo(largeur, hauteurDroite);
			graphics.lineTo(0, hauteurDroite);
			graphics.endFill();
			
		}

		public function activer(boolean : Boolean) : void {
			_activation = boolean;
			gererMouseOut(null);
		}
	}
}
