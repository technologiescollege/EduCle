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
package fr.acversailles.crdp.utils {
	/**
	 * @private
	 */
	public class MiseEnForme {
		public static function mettreEspaceDansNombre(nombre : String) : String {
			if (nombre.length <= 3) return nombre;
			else return mettreEspaceDansNombre(nombre.substring(0, nombre.length - 3)) + "\u00A0" + nombre.substring(nombre.length - 3, nombre.length);
			return "";
		}

		public static function sommeEnEuros(nombre : String) : String {
			return mettreEspaceDansNombre(nombre) + '\u00A0' + "€";
		}

		public static function arrondir(donneeDeBase : Number, decimales : uint) : Number {
			var coeff : Number = Math.pow(10, decimales);
			return Math.round(donneeDeBase * coeff) / coeff;
		}

		public static function retirerDoublesEspaces(chaine : String) : String {
			return chaine.replace(/\s\s/g, " ");
		}

		public static function retirerEspaces(chaine : String) : String {
			return chaine.replace(/\s/g, "");
		}

		public static function espaceInsecableAvant(phrase : String, car : String) : String {
			var chaineModele : String = "\\s" + car;
			var schema : RegExp = new RegExp(chaineModele, "g");
			phrase = phrase.replace(schema, "\u00a0" + car);
			return phrase;
		}

		public static function corrigerPbAAccentSqLite(chaine : String) : String {
			var aAccent : RegExp = new RegExp(String.fromCharCode(65533), "g");
			return chaine.replace(aAccent, "à");
		}

		public static function corrigerPbSlashSqLite(chaine : String) : String {
			return chaine.replace(/\\#/g, "'");
		}

		public static function remplacerCaracteresSpeciaux(description : String) : String {
			description = description.replace(/\n/g, " ");
			description = description.replace(/\t/g, "");
			description = description.replace(/\r/g, "");
			description = description.replace(/§/g, "\n");
			description = description.replace(/_/g, "\u00A0");
			description = description.replace(/\\#/g, "\u2019");
			return description;
		}
	}
}
