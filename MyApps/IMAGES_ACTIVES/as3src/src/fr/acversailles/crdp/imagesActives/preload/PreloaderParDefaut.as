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
	import fr.acversailles.crdp.imagesActives.icones.Logo;
	import fr.acversailles.crdp.imagesActives.icones.BarrePreLoader;
	import fr.acversailles.crdp.imagesActives.icones.FondPreLoader;
	import fr.acversailles.crdp.utils.functions.centrer;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class PreloaderParDefaut extends AbstractPreloader {
		private static const MARGE_DROITE : Number = 9;
		private static const MARGE_GAUCHE : Number = 10;
		private static const LARGEUR_DECO : Number = 400;
		private static const MARGE_SUP_BARRE : Number = 15;

		public function PreloaderParDefaut() {
			super();
		}

		override protected function determinerNbBarres() : void {
			nbBarres = 30;
		}

		override protected function placerDeco() : void {
			deco = new Logo();
			addChild(deco);
			var proportion : Number = LARGEUR_DECO / deco.width;
			deco.scaleX = deco.scaleY = proportion;
		}

		override protected function placerFond() : void {
			fond = new FondPreLoader();
			addChild(fond);
			fond.y = deco. getBounds(this).bottom + MARGE_SUP_BARRE;
			fond.x = (LARGEUR_DECO - fond.width) / 2;
		}

		override protected function placerBarre() : void {
			barre = new BarrePreLoader();
			fond.addChild(barre);
			centrer(barre, 0, fond.height);
			barre.x = fond.width - MARGE_DROITE - barre.width;
		}

		override protected function positionnerZoneTexte() : void {
			centrer(zoneTexte, 0, fond.height);
			zoneTexte.x = MARGE_GAUCHE;
		}
	}
}
