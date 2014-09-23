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
package fr.acversailles.crdp.imagesActives.embarque {
	import flash.text.Font;

	import fr.acversailles.crdp.utils.avertirClasseAbstraite;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import fr.acversailles.crdp.imagesActives.embarque.IRessourcesClass;

	import flash.media.Sound;
	import flash.display.Bitmap;
	import flash.utils.ByteArray;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class AbstractRessources extends EventDispatcher implements IRessourcesClass {
		public static var classesPolices : Object;

		public function AbstractRessources(target : IEventDispatcher = null) {
			super(target);
		}

		public function getImage(cle : String) : Bitmap {
			avertirClasseAbstraite();
			return null;
		}

		public function getSon(cle : String) : Sound {
			avertirClasseAbstraite();
			return null;
		}

		public function getContenu() : XML {
			var svg : Class = this["contenu"];
			return XML(new svg());
		}

		public function getFeuilleDeStyle() : ByteArray {
			var feuille : Class = this["feuilleDeStyle"];
			return new feuille() as ByteArray;
		}

		public function getPolice(cle : String) : Font {
			var classePolice : Class = classesPolices[cle];
			return new classePolice() as Font;
		}

		public function getPolices() : Object {
			return classesPolices;
		}

		public function getOptions() : XML {
			var options : Class = this["options"];
			return XML(new options());
		}

		public function getParametres() : XML {
			var parametres : Class = this["parametres"];
			return XML(new parametres());
		}
	}
}
