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
package fr.acversailles.crdp.imagesActives.data {
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import flash.errors.IllegalOperationError;
	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ParametresXML {
		
		private static var _instance : ParametresXML;
		private static var docXML : XML;
		private static var _unite : Number;
		private static var mainNS : Namespace = new Namespace("http://www.crdp.ac_versailles.fr/2011/images_actives");

		public function ParametresXML() {
			docXML = SVGWrapper.instance.xmlParametres;
			_unite = Number(docXML.mainNS::dimensions.mainNS::unit) * (ContenuXML.instance.getLargeurTotale() + ContenuXML.instance.getHauteurTotale()) / 2;
		}

		public static function get instance() : ParametresXML {
			if (!_instance) _instance = new ParametresXML();
			return _instance;
		}

		public function getParametreDimensions(cle : String, ns : Namespace) : Number {
			if (docXML.mainNS::dimensions.ns::[cle].toString().match(/^\s*$/))
				throw new IllegalOperationError("Paramètre absent de la base : namespace :"+ns.toString()+" clé : "+cle);
			return Number(docXML.mainNS::dimensions.ns::[cle]) * _unite;
		}

		public function get unite() : Number {
			return _unite;
		}

		public function getParametreCommun(cle : String) : Number {
			if (docXML.mainNS::common_parameters.mainNS::[cle].toString().match(/^\s*$/))
				throw new IllegalOperationError("Paramètre absent de la base : namespace :"+mainNS.toString()+" clé : "+cle);
			return Number(docXML.mainNS::common_parameters.mainNS::[cle]);
		}

		public function getParametreCouleur(cle : String) : uint {
			if (docXML.mainNS::colors.mainNS::[cle].toString().match(/^\s*$/))
				throw new IllegalOperationError("Couleur absente de la base : namespace :"+mainNS.toString()+" clé : "+cle);
			return uint(docXML.mainNS::colors.mainNS::[cle]);
		}
	}
}
