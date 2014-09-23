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
	public class ActionUtilisateurEvent extends Event {
		public static const MOUSE_DOWN_DETAIL : String = "MOUSE_DOWN_DETAIL";
		public static const MOUSE_DOWN_FOND_IMAGE : String = "MOUSE_DOWN_FOND_IMAGE";
		public static const MOUSE_MOVE_DETAIL : String = "MOUSE_MOVE_DETAIL";
		public static const MOUSE_MOVE_FOND_IMAGE : String = "MOUSE_MOVE_FOND_IMAGE";
		public static const MOUSE_DOWN_DETAIL_PUCE : String = "MOUSE_DOWN_DETAIL_PUCE";
		public static const MOUSE_MOVE_DETAIL_PUCE : String = "MOUSE_MOVE_DETAIL_PUCE";
		public static const MOUSE_DOWN_LEGENDE : String = "MOUSE_DOWN_LEGENDE";
		public static const MOUSE_DOWN_BOUTON_DESCRIPTION : String = "MOUSE_DOWN_BOUTON_DESCRIPTION";
		public static const MOUSE_DOWN_BOUTON_REPONSE : String = "MOUSE_DOWN_BOUTON_REPONSE";
		public static const MOUSE_OVER_LEGENDE : String = "MOUSE_OVER_LEGENDE";
		public static const MOUSE_OUT_LEGENDE : String = "MOUSE_OUT_LEGENDE";
		public static const MOUSE_DOWN_BOUTON_AFFICHER_DETAILS : String = "MOUSE_DOWN_BOUTON_AFFICHER_DETAILS";
		public static const MOUSE_OUT_BOUTON_AFFICHER_DETAILS : String = "MOUSE_OUT_BOUTON_AFFICHER_DETAILS";
		public static const MOUSE_UP_SCENE : String = "MOUSE_UP_SCENE";
		public static const MOUSE_OVER_ZONE_INFOS_DROITS : String = "MOUSE_OVER_ZONE_INFOS_DROITS";
		public static const MOUSE_OUT_ZONE_INFOS_DROITS : String = "MOUSE_OUT_ZONE_INFOS_DROITS";
		public static const MOUSE_DOWN_ZONE_INFOS_DROITS : String = "MOUSE_DOWN_ZONE_INFOS_DROITS";
		public static const DEVERROUILLAGE_ANIMATION : String = "DEVERROUILLAGE_ANIMATION";
		public static const ABANDON_DEVERROUILLAGE_ANIMATION : String = "ABANDON_DEVERROUILLAGE_ANIMATION";
		public static const MOUSE_OUT_ZONE_IMAGE : String = "MOUSE_OUT_ZONE_IMAGE";
		public static const CLIC_LIEN : String = "CLIC_LIEN";
		public static const MOUSE_DOWN_FOND_SCENE : String = "MOUSE_DOWN_FOND_SCENE";
		public static const MOUSE_DOWN_BOUTON_INFOS : String = "MOUSE_DOWN_BOUTON_INFOS";
		public static const MOUSE_DOWN_FENETRE_CREDITS : String = "MOUSE_DOWN_FENETRE_CREDITS";
		private var _numero : uint;
		private var _chaine : String;

		public function ActionUtilisateurEvent(type : String, numero : uint = 0, chaine : String = "") {
			_chaine = chaine;
			_numero = numero;
			super(type, false, false);
		}

		public function get numero() : uint {
			return _numero;
		}

		public function get chaine() : String {
			return _chaine;
		}
	}
}
