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
/*
**   Images Actives ©2010-2011 CRDP de l'Académie de Versailles
** This file is part of Images Actives.
**
**    Images Actives is free software: you can redistribute it and/or modify
**    it under the terms of the GNU General Public License as published by
**    the Free Software Foundation, either version 3 of the License, or
**    (at your option) any later version.
**
**    Images Actives is distributed in the hope that it will be useful,
**    but WITHOUT ANY WARRANTY; without even the implied warranty of
**    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**    GNU General Public License for more details.
**
**    You should have received a copy of the GNU General Public License
**    along with Images Actives.  If not, see <http://www.gnu.org/licenses/>
**
** 	@author joachim.dornbusch@crdp.ac-versailles.fr
 */
package fr.acversailles.crdp.imagesActives.textes.accordeon {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author dornbusch
	 */
	public class GlissiereCarte extends Sprite {
		private var hauteurViewPort : Number;
		private var hauteurTotale : Number;
		private var largeur : Number;
		private var curseur : CurseurCarte;
		private var rectangleDrag : Rectangle;
		private var couleurCurseur : uint;

		public function GlissiereCarte(hauteurViewPort : Number, hauteurTotale : Number, largeur : Number, couleurCurseur : uint) {
			this.couleurCurseur = couleurCurseur;
			this.largeur = largeur;
			this.hauteurTotale = hauteurTotale;
			this.hauteurViewPort = hauteurViewPort;
			dessinerFond();
			mettreCurseur();
		}

		private function dessinerFond() : void {
			graphics.lineStyle(0.5, couleurCurseur, 0.5);
			graphics.drawRect(0, -1, largeur, hauteurViewPort + 1);
		}

		private function mettreCurseur() : void {
			curseur = new CurseurCarte(hauteurCurseur(), largeur, couleurCurseur) ;
			addChild(curseur);
			determinerRectangleDrag();
			arreterDrag(null);
			// place les bons écouteurs
		}

		private function determinerRectangleDrag() : void {
			rectangleDrag = new Rectangle(0, 0, 0, hauteurViewPort - hauteurCurseur());
		}

		private function hauteurCurseur() : Number {
			return hauteurViewPort * hauteurViewPort / hauteurTotale;
		}

		private function commencerDrag(event : MouseEvent) : void {
			curseur.startDrag(false, rectangleDrag);
			curseur.removeEventListener(MouseEvent.MOUSE_DOWN, commencerDrag);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, signalerDeplacement);
			stage.addEventListener(MouseEvent.MOUSE_UP, arreterDrag);
		}

		private function signalerDeplacement(event : MouseEvent) : void {
			dispatchEvent(new CurseurEvent(CurseurEvent.DEPLACEMENT, curseur.y));
		}

		private function arreterDrag(event : MouseEvent) : void {
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, arreterDrag);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, signalerDeplacement);
			}
			curseur.addEventListener(MouseEvent.MOUSE_DOWN, commencerDrag);
			curseur.stopDrag();
		}

		public function ajusterCurseur(posCurseur : Number) : void {
			curseur.y = posCurseur;
		}

		public function redimensionner(hauteurTotale : Number) : void {
			this.hauteurTotale = hauteurTotale;
			curseur.redimensionner(hauteurCurseur());
			determinerRectangleDrag();
		}
	}
}
