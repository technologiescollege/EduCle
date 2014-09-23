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
package fr.acversailles.crdp.imagesActives.tooltips {
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;

	/**
	 * @author Dornbusch
	 */
	internal class Tooltipable {
		private var _texte : String;
		private var _objet : InteractiveObject;
		private var _active : Boolean;

		public function Tooltipable(objet : InteractiveObject, texte : String) {
			this._objet = objet;
			this._texte = texte;
		}

		public function get texte() : String {
			return _texte;
		}

		public function set texte(texte : String) : void {
			_texte = texte;
		}

		public function get objet() : InteractiveObject {
			return _objet;
		}

		public function desactiver() : void {
			_active = false;
			_objet.removeEventListener(MouseEvent.MOUSE_OVER, elire);
			_objet.removeEventListener(MouseEvent.MOUSE_OUT, dechoir);
			//il est peut-être actuellement élu
			dechoir(null);
		}

		public function activer() : void {
			_active = true;
			_objet.addEventListener(MouseEvent.MOUSE_OVER, elire);
			_objet.addEventListener(MouseEvent.MOUSE_OUT, dechoir);
		}

		private function dechoir(event : MouseEvent) : void {
			GestionnaireAffichageTooltips.annulerElection(this);
		}

		private function elire(event : MouseEvent) : void {
			GestionnaireAffichageTooltips.objetElu = this;
		}

		public function get active() : Boolean {
			return _active;
		}
	}
}
