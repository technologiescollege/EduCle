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
	import flash.events.Event;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class AudioEvent extends Event {
		public static const POSITION : String = "POSITION";
		public static const PAUSE : String = "PAUSE";
		public static const LECTURE : String = "LECTURE";
		public static const SON_ON : String = "SON_ON";
		public static const SON_OFF : String = "SON_OFF";
		public static const RESET : String = "RESET";
		public static const VOLUME : String = "VOLUME";
		private var _position : Number;

		public function AudioEvent(type : String, position : Number = 0) {
			_position = position;
			super(type, false, false);
		}

		public function get position() : Number {
			return _position;
		}
	}
}
