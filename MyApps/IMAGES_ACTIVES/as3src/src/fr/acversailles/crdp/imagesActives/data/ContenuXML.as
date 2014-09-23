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
	import fr.acversailles.crdp.utils.functions.remplacerCaracteresSansFonts;
	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class ContenuXML {
		
		private static var _instance : ContenuXML;
		private static var docXML : XML;
		private static var mainNS : Namespace = new Namespace("http://www.crdp.ac_versailles.fr/2011/images_actives");

		public function ContenuXML() {
			docXML = SVGWrapper.instance.xmlOptions;
		}

		public static function get instance() : ContenuXML {
			if (!_instance) _instance = new ContenuXML();
			return _instance;
		}

		public function modeleDisposition() : String {
			return docXML.mainNS::layout.@layout_pattern;
		}

		public function modeInteractivite() : String {
			return docXML.mainNS::specific_interactivity_parameters.@interactivity_type;
		}

		public function getParametreDispositionSpecifiques(ns : Namespace, cle : String) : Number {
			return docXML.mainNS::layout.ns::[cle];
		}

		public function getParamInteractiviteCommun(cle : String) : Number {
			return docXML.mainNS::common_interactivity_parameters.mainNS::[cle];
		}

		public function getParamInteractiviteSpecifique(ns : Namespace, cle : String) : Number {
			return parseInt(docXML.mainNS::specific_interactivity_parameters.ns::[cle]);
		}

		public function getTexteCommun(cle : String) : String {
			return remplacerCaracteresSansFonts(docXML.mainNS::common_texts.mainNS::[cle]);
		}

		public function getTexteSpecifique(ns : Namespace, cle : String) : String {
			return remplacerCaracteresSansFonts(docXML.mainNS::specific_texts.ns::[cle]);
		}

		public function getLargeurTotale() : Number {
			return docXML.mainNS::export_size.mainNS::width;
		}

		public function getHauteurTotale() : Number {
			return docXML.mainNS::export_size.mainNS::height;
		}

		public function getParametreCouleur(cle : String) : uint {
			return uint(docXML..mainNS::color.(@id == cle).text());
		}
	}
}
