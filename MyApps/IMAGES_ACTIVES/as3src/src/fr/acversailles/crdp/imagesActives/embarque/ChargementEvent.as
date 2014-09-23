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
	import flash.events.Event;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ChargementEvent extends Event {
		public static const CHARGEMENT_TERMINE : String = "CHARGEMENT_TERMINE";
		public static const PROGRESSION : String = "PROGRESSION";
		public static const CHARGEMENT_COMMENCE : String = "CHARGEMENT_COMMENCE";
		public static const ERREUR : String = "ERREUR";
		private var _valeur1 : Number;
		private var _valeur2 : Number;

		public function ChargementEvent(type : String, valeur1 : Number = 0, valeur2 : Number = 0, bubbles : Boolean = false, cancelable : Boolean = false) {
			_valeur2 = valeur2;
			_valeur1 = valeur1;
			super(type, bubbles, cancelable);
		}

		public function get valeur1() : Number {
			return _valeur1;
		}

		public function get valeur2() : Number {
			return _valeur2;
		}
	}
}
