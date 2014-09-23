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
	import flash.filters.BevelFilter;

	/**
	 * @author dornbusch
	 */
	public class CurseurCarte extends Sprite {
		private static const ECARTS_TIRETS : Number = 5;
		private var hauteur : Number;
		private var largeur : Number;
		private var couleur : uint;
		private var filtreNormal : BevelFilter;
		private var filtreEmphase : BevelFilter;

		public function CurseurCarte(hauteur : Number, largeur : Number, couleur : uint) {
			this.couleur = couleur;
			this.largeur = largeur;
			this.hauteur = hauteur;
			dessinerFond();
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_OVER, emphaser);
			addEventListener(MouseEvent.MOUSE_OUT, desemphaser);
			filtreNormal = new BevelFilter(2);
			filtreEmphase = new BevelFilter(4);
			desemphaser(null);
		}

		private function desemphaser(event : MouseEvent) : void {
			filters = [filtreNormal];
		}

		private function emphaser(event : MouseEvent) : void {
			filters = [filtreEmphase];
		}

		private function dessinerFond() : void {
			graphics.clear();
			graphics.beginFill(couleur, 0.5);
			graphics.drawRect(2, 2, largeur - 3, hauteur - 2);
			graphics.endFill();
			tirerTrait(hauteur / 2);
			tirerTrait(hauteur / 2 + ECARTS_TIRETS);
			tirerTrait(hauteur / 2 - ECARTS_TIRETS);
		}

		private function tirerTrait(posY : Number) : void {
			graphics.lineStyle(0.5, 0x666666);
			graphics.moveTo(largeur / 3, posY);
			graphics.lineTo(2 * largeur / 3, posY);
		}

		public function redimensionner(hauteur : Number) : void {
			this.hauteur = hauteur;
			dessinerFond();
		}
	}
}
