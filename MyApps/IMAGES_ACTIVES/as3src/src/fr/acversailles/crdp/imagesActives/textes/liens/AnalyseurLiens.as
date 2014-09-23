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
package fr.acversailles.crdp.imagesActives.textes.liens {
	import fr.acversailles.crdp.imagesActives.data.StylesCSS;

	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author dornbusch
	 */
	public class AnalyseurLiens {
	//	private static const SCHEMA_LIENS_AVEC_ESPACES_AU_DEBUT : RegExp = /\{\s+([^@]*[^\s@])\s*@([^@]+)/;
//		private static const SCHEMA_LIENS_AVEC_ESPACES_AVANT_AROBASE : RegExp = /\{\s*([^@]*[^\s@])\s+@([^@]+)/;
		private static const SCHEMA_LIENS_AVEC_ESPACES_APRES_AROBASE : RegExp = /([^@]+)@\s+([^\}]*[^\s\}])\s*\}/;
		private static const SCHEMA_LIENS_AVEC_ESPACES_A_LA_FIN : RegExp = /([^@]+)@\s*([^\}]*[^\s\}])\s+\}/;
		private static const SCHEMA_LIENS : RegExp = /\{([^@]*[^\s@])@([^\}]*[^\s\}@])\}/;

		public static function activerLiens(zoneTexte : TextField) : void {
			var extractionLiens : Array = analyserTexte(zoneTexte.text);
			var texteSansLiens : String = supprimerLiens(zoneTexte.text);
			zoneTexte.text = texteSansLiens;
			if (extractionLiens.length > 0)
				implanterLiens(zoneTexte, extractionLiens);
		}

		public static function implanterLiens(zoneTexte : TextField, liens : Array) : void {
			zoneTexte.text = supprimerEspacesInutiles(zoneTexte.text);
			var formatTexteAvecLiens : TextFormat = zoneTexte.defaultTextFormat;
			// TODO faut-il obligatoirement un target blank
			formatTexteAvecLiens.target = "_blank";
			formatTexteAvecLiens.color = StylesCSS.instance.styleToTextFormat(".hyperlink").color;
			formatTexteAvecLiens.underline = StylesCSS.instance.styleToTextFormat(".hyperlink").underline;
			formatTexteAvecLiens.italic = StylesCSS.instance.styleToTextFormat(".hyperlink").italic;
			for each (var lien : Array in liens) {
				formatTexteAvecLiens.url = lien[2];
				zoneTexte.setTextFormat(formatTexteAvecLiens, lien[0], lien[1]);
			}
		}

		public static function supprimerLiens(chaine : String) : String {
			chaine = supprimerEspacesInutiles(chaine);
			var occurence : Array = SCHEMA_LIENS.exec(chaine);

			do {
				if (occurence) {
					chaine = chaine.replace(occurence[0], occurence[1]);
					occurence = SCHEMA_LIENS.exec(chaine);
				}
			} while (occurence != null);
			return chaine;
		}

		public static function analyserTexte(chaine : String) : Array {
			chaine = supprimerEspacesInutiles(chaine);
			var occurence : Array = SCHEMA_LIENS.exec(chaine);
			var resultat : Array = new Array();
			var debut : int;
			var fin : int;
			var url : String;
			do {
				if (occurence) {
					debut = chaine.indexOf(occurence[0]);
					fin = debut + occurence[1].length;
					url = occurence[2];
					resultat.push([debut, fin, url]);
					chaine = chaine.replace(occurence[0], occurence[1]);
					occurence = SCHEMA_LIENS.exec(chaine);
				}
			} while (occurence != null);
			return resultat;
		}

		private static function supprimerEspacesInutiles(chaine : String) : String {
			//pourquoi y avait-il ce dispositif ?
//			while (chaine.match(SCHEMA_LIENS_AVEC_ESPACES_AU_DEBUT))
//				chaine = chaine.replace(SCHEMA_LIENS_AVEC_ESPACES_AU_DEBUT, "{$1@$2");
//			while (chaine.match(SCHEMA_LIENS_AVEC_ESPACES_AVANT_AROBASE))
//				chaine = chaine.replace(SCHEMA_LIENS_AVEC_ESPACES_AVANT_AROBASE, "{$1@$2");
			while (chaine.match(SCHEMA_LIENS_AVEC_ESPACES_APRES_AROBASE))
				chaine = chaine.replace(SCHEMA_LIENS_AVEC_ESPACES_APRES_AROBASE, "$1@$2}");
			while (chaine.match(SCHEMA_LIENS_AVEC_ESPACES_A_LA_FIN))
				chaine = chaine.replace(SCHEMA_LIENS_AVEC_ESPACES_A_LA_FIN, "$1@$2}");
			return chaine;
		}
	}
}
