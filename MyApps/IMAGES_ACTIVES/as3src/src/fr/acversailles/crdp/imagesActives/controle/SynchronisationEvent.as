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
package fr.acversailles.crdp.imagesActives.controle {
	import flash.events.Event;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class SynchronisationEvent extends Event {
		public static const FIN_DEZOOM : String = "FIN_DEZOOM";
		public static const FIN_ZOOM : String = "FIN_ZOOM";
		private var _numero : int;

		public function SynchronisationEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public function get numero() : int {
			return _numero;
		}
	}
}
