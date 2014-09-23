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
package fr.acversailles.crdp.imagesActives.preload {
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;
	import fr.acversailles.crdp.utils.avertirClasseAbstraite;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class AbstractPreloader extends Sprite implements IPreloader {
		protected var nbBarres : Number;
		protected var fond : Sprite;
		protected var deco : Sprite;
		protected var barre : Sprite;
		protected var masqueBarre : Shape;
		protected var zoneTexte : TextField;

		public function AbstractPreloader() {
			determinerNbBarres();
			placerDeco();
			placerFond();
			placerBarre();
			placerMasqueBarre();
			mettreZoneTexte();
			positionnerZoneTexte();
		}

		protected function determinerNbBarres() : void {
			avertirClasseAbstraite();
		}

		protected function placerDeco() : void {
			avertirClasseAbstraite();
		}

		protected function positionnerZoneTexte() : void {
			avertirClasseAbstraite();
		}

		private function mettreZoneTexte() : void {
			zoneTexte = new TextField();
			zoneTexte.multiline = false;
			//à ce stade, svgwrapper n'est pas instancié
			zoneTexte.embedFonts = false;
			zoneTexte.autoSize = TextFieldAutoSize.LEFT;
			zoneTexte.defaultTextFormat = StylesCSS.instance.styleToTextFormat(".preloader");
			zoneTexte.wordWrap = false;
			zoneTexte.selectable = false;
			zoneTexte.antiAliasType = AntiAliasType.ADVANCED;
			zoneTexte.mouseEnabled = false;
			zoneTexte.mouseWheelEnabled = false;
			fond.addChild(zoneTexte);
			afficherNouvelleRessource(0, 0);
		}

		protected function placerBarre() : void {
			avertirClasseAbstraite();
		}

		protected function placerMasqueBarre() : void {
			masqueBarre = new Shape();
			masqueBarre.x = barre.x;
			masqueBarre.y = barre.y;
			masqueBarre.graphics.beginFill(0x000000);
			masqueBarre.graphics.drawRect(0, 0, barre.width, barre.height);
			masqueBarre.graphics.endFill();
			fond.addChild(masqueBarre);
			barre.mask = masqueBarre;
			masqueBarre.scaleX = 0;
		}

		protected function placerFond() : void {
			avertirClasseAbstraite();
		}

		public function get sprite() : Sprite {
			return this;
		}

		public function afficherProgression(valeur : Number) : void {
			valeur = valeur * 100;
			valeur = Math.round(valeur / (100 / nbBarres)) * (100 / nbBarres);
			masqueBarre.scaleX = valeur / 100;
		}

		public function afficherNouvelleRessource(numero : Number, total : Number) : void {
			zoneTexte.text = numero + " / " + total;
		}

		public function afficherErreur() : void {
			zoneTexte.text = "Erreur !";
		}
	}
}
