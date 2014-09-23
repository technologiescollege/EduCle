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
	import fr.acversailles.crdp.utils.functions.assert;
	import fr.acversailles.crdp.utils.functions.remplacerCaracteresSansFonts;

	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.display.SVGElement;
	import com.lorentz.SVG.display.SVGG;
	import com.lorentz.SVG.display.SVGImage;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
		import OnTheFlyClass;


	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class SVGWrapper extends EventDispatcher implements ISVGWrapper {
		private static var _instance : ISVGWrapper;
		private static const MOTIF_DETAIL : RegExp = /^detail(\d*)$/;
		private var _fond : Bitmap;
		private var _titreImageSource : String;
		private var _titreDescription : String;
		private var _texteDescription : String;
		private var titreLegendes : Dictionary ;
		private var textesLegendes : Dictionary;
		private var detailsZoomables : Dictionary;
		private var detailsPuces : Dictionary;
		private var details : Dictionary;
		private var clesDetails : Vector.<String>;
		private var _source : String;
		private var _date : String;
		private var _auteur : String;
		private var _droits : String;
		private var sons : Object;
		private var polices : Object;
		private var nbDetails : uint;
		private static var embedClass : IRessourcesClass;
		private static var _stage : DisplayObjectContainer;
		private var _asynchrone : Boolean;
		private var contours : Vector.<DisplayObject>;
		private var nbTotalDetails : uint;
		private var _titre : String;

		public static function initialiser(stage : DisplayObjectContainer) : void {
			_stage = stage;
			embedClass = new OnTheFlyClass();
			creerInstance(embedClass is IRessourcesChargeesClass);
			if (instance.asynchrone) {
				(embedClass as IRessourcesChargeesClass).addEventListener(ChargementEvent.CHARGEMENT_TERMINE, gererFinChargementRessources);
				(embedClass as IRessourcesChargeesClass).addEventListener(ChargementEvent.CHARGEMENT_COMMENCE, gererDebutChargementRessources);
				(embedClass as IRessourcesChargeesClass).addEventListener(ChargementEvent.PROGRESSION, gererProgressionChargementRessources);
				(embedClass as IRessourcesChargeesClass).addEventListener(ChargementEvent.ERREUR, gererErreurChargementRessources);
			}
		}

		private static function gererErreurChargementRessources(event : ChargementEvent) : void {
			instance.dispatchEvent(new ChargementEvent(ChargementEvent.ERREUR));
		}

		private static function gererProgressionChargementRessources(event : ChargementEvent) : void {
			instance.dispatchEvent(new ChargementEvent(ChargementEvent.PROGRESSION, event.valeur1));
		}

		private static function gererDebutChargementRessources(event : ChargementEvent) : void {
			instance.dispatchEvent(new ChargementEvent(ChargementEvent.CHARGEMENT_COMMENCE, event.valeur1, event.valeur2));
		}

		private static function creerInstance(asynchrone : Boolean) : void {
			_instance = new SVGWrapper(asynchrone, new Verrou());
		}

		public function chargerRessources() : void {
			if (embedClass is IRessourcesChargeesClass) {
				(embedClass as IRessourcesChargeesClass).demarrerChargement();
			} else signalerFinChargement();
		}

		private static function gererFinChargementRessources(event : ChargementEvent) : void {
			signalerFinChargement();
		}

		private static function signalerFinChargement() : void {
			instance.dispatchEvent(new ChargementEvent(ChargementEvent.CHARGEMENT_TERMINE));
		}

		public function SVGWrapper(asynchrone : Boolean, v : Verrou) {
			_asynchrone = asynchrone;
			details = new Dictionary();
			detailsZoomables = new Dictionary();
			detailsPuces = new Dictionary();
			titreLegendes = new Dictionary();
			textesLegendes = new Dictionary();
			v;
		}

		public function construire() : void {
			_fond = embedClass.getImage("fond");
			nbDetails = 0;
			analyserSVG();
			creerPolices();
			sons = new Object();
		}

		private function analyserSVG() : void {
			var svgDoc : SVGDocument = construireSVGDoc();
			// obligatoire pour le bon fonctionnement de la librairie
			_stage.addChild(svgDoc);
			nbTotalDetails = compterDetails(svgDoc);
			clesDetails = new Vector.<String>(nbTotalDetails);
			contours = new Vector.<DisplayObject>(nbTotalDetails);
			extraireElementsImage(svgDoc);
			_stage.removeChild(svgDoc);
			svgDoc = null;
		}

		private function extraireElementsImage(svgDoc : SVGDocument) : void {
			var element : SVGElement;
			// +1 pour le fond
			for ( var i : int = 0; i < svgDoc.numChildren; i++) {
				element = svgDoc.getChildAt(i) as SVGElement;
				if (element.id.match(MOTIF_DETAIL)) {
					extraireDetail(element);
				} else if (element.id == "background") {
					_titreDescription = element.title;
					_texteDescription = element.description;
				}
			}
		}

		private function compterDetails(svgDoc : SVGDocument) : uint {
			var comptageDetails : Number = 0;
			for (var i : int = 0; i < svgDoc.numChildren; i++) {
				var element : DisplayObject = svgDoc.getChildAt(i) as DisplayObject;
				var idElement : String = (element as SVGElement).id;
				if (idElement.match(MOTIF_DETAIL)) {
					comptageDetails++;
				}
			}
			return comptageDetails;
		}

		private function construireSVGDoc() : SVGDocument {
			XML.ignoreWhitespace = true;
			var docXML : XML = embedClass.getContenu();
			var svgDoc : SVGDocument = new SVGDocument();
			svgDoc.visible = false;
			svgDoc.parse(docXML);
			_titre = svgDoc.getTitle();
			_titreImageSource = svgDoc.getMetadata('title');
			_source = svgDoc.getMetadata('source');
			_droits = svgDoc.getMetadata('rights');
			_auteur = svgDoc.getMetadata('creator');
			_date = svgDoc.getMetadata('date');
			enleverGroupesALaRacine(svgDoc);
			nettoyerSVG(svgDoc);

			return svgDoc;
		}

		private function extraireDetail(element : SVGElement) : void {
			if (element is SVGImage)
				extraireBitmap(element as SVGImage);
			else extraireElement(element as SVGElement);
			detailsZoomables[element.id] = (element as SVGElement).zoomable;
			detailsPuces[element.id] = (element as SVGElement).puce;
			titreLegendes[element.id] = (element as SVGElement).title;
			textesLegendes[element.id] = (element as SVGElement).description;
			assertEquals("Deux éléments svg ont le même id : " + element.id, -1, clesDetails.indexOf(element.id));
			clesDetails[nbDetails] = element.id;
			nbDetails++;
		}

		private function extraireElement(element : SVGElement) : void {
			var spriteProvisoire : Sprite = new Sprite();
			var fondDetail : Bitmap = embedClass.getImage("fond");
			spriteProvisoire.addChild(fondDetail);
			spriteProvisoire.addChild(element.clone(true));

			spriteProvisoire.mask = element;
			var data : BitmapData = new BitmapData(_fond.width, _fond.height, true, 0x0);
			data.draw(spriteProvisoire);
			details[element.id] = new Bitmap(data);
		}

		private function extraireBitmap(element : SVGImage) : void {
			var bitmapDetail : Bitmap = embedClass.getImage(element.id);
			bitmapDetail.x = element.x;
			bitmapDetail.y = element.y;
			var data : BitmapData = new BitmapData(_fond.width, _fond.height, true, 0x0);
			var matrix : Matrix = new Matrix();
			if (element.width != bitmapDetail.width) {
				var scale : Number = parseFloat((element as SVGImage).svgWidth) / bitmapDetail.width;
				matrix.scale(scale, scale);
			}
			matrix.translate(parseFloat((element as SVGImage).svgX), parseFloat((element as SVGImage).svgY));
			data.draw(bitmapDetail, matrix);
			details[element.id] = new Bitmap(data);
		}

		private function enleverGroupesALaRacine(svgDoc : SVGDocument) : void {
			var deltaX : Number;
			var deltaY : Number;
			while (svgDoc.numChildren == 1 && svgDoc.getChildAt(0) is SVGG && !svgDoc.id.match(MOTIF_DETAIL)) {
				deltaX = svgDoc.getChildAt(0).transform.matrix.tx;
				deltaY = svgDoc.getChildAt(0).transform.matrix.ty;
				var groupe : DisplayObjectContainer = svgDoc.getChildAt(0) as DisplayObjectContainer;
				var element : SVGElement;
				while (groupe.numChildren > 0) {
					element = groupe.getChildAt(0) as SVGElement;
					svgDoc.addChild(element);
					if (element is SVGImage) {
						(element as SVGImage).svgX += deltaX;
						(element as SVGImage).svgY += deltaY;
					} else {
						element.x += deltaX;
						element.y += deltaY;
					}
				}
			}
		}

		private function nettoyerSVG(svgDoc : SVGDocument) : void {
			var element : DisplayObject;
			var numChild : uint = 0;
			while (numChild < svgDoc.numChildren) {
				element = svgDoc.getChildAt(numChild) as DisplayObject;
				var idElement : String = (element as SVGElement).id;

				if (!idElement.match(MOTIF_DETAIL) && !idElement == "background") {
					svgDoc.removeChildAt(numChild);
				} else numChild++;
			}
		}

		private function creerPolices() : void {
			polices = new Object();
			for (var cle : String in embedClass.getPolices()) {
				polices[cle] = embedClass.getPolice(cle);
			}
		}

		public static function get instance() : ISVGWrapper {
			assert(_instance != null, "Le container d'images vectorielles doit être initialisé avec une référence à la scène");
			return _instance;
		}

		public function get fond() : Bitmap {
			return _fond;
		}

		public function getDetail(idDetail : int) : Bitmap {
			return details[clesDetails[idDetail]];
		}

		public function isDetailZoomable(idDetail : int) : Boolean {
			return detailsZoomables[clesDetails[idDetail]];
		}
		
		public function isPuce(idDetail : int) : Boolean {
			return detailsPuces[clesDetails[idDetail]];;
		}

		public function getNbDetails() : uint {
			return nbDetails;
		}

		public function get titreDescription() : String {
			return remplacerCaracteresSansFonts(_titreDescription);
		}

		public function get texteDescription() : String {
			return remplacerCaracteresSansFonts(_texteDescription);
		}

		public function getTexteLegendeDetail(i : int) : String {
			return remplacerCaracteresSansFonts(textesLegendes[clesDetails[i]]);
		}

		public function getTitreLegendeDetail(i : int) : String {
			return  remplacerCaracteresSansFonts(titreLegendes[clesDetails[i]]);
		}

		public function getTexteQuestionDetail(i : int) : String {
			return remplacerCaracteresSansFonts(titreLegendes[clesDetails[i]]);
		}

		public function getReponseQuestionDetail(i : int) : String {
			return remplacerCaracteresSansFonts(textesLegendes[clesDetails[i]]);
		}

		public function getTitre() : String {
			return remplacerCaracteresSansFonts(_titre);
		}

		public function getSource() : String {
			return remplacerCaracteresSansFonts(_source);
		}
		
		public function getDate() : String {
			return remplacerCaracteresSansFonts(_date);
		}
		
		public function getAuteur() : String {
			return remplacerCaracteresSansFonts(_auteur);
		}
		
		public function getTitreImageSource() : String {
			return remplacerCaracteresSansFonts(_titreImageSource);
		}

		public function getDroits() : String {
			return remplacerCaracteresSansFonts(_droits);
		}

		public function get feuilleDeStyle() : ByteArray {
			return embedClass.getFeuilleDeStyle();
		}

		public function getSon(cle : String, numero : int = -1) : Sound {
			// retranscrire le nurmo d'ordre en numéro de type détail+i
			var index : int ;
			if (numero >= 0) {
				index = MOTIF_DETAIL.exec(clesDetails[numero])[1];
				cle = cle + index;
			}
			assertNotNull("le son correspondant à cette clé n'existe pas " + cle, embedClass.getSon(cle));
			if (!sons[cle]) sons[cle] = embedClass.getSon(cle);
			return sons[cle] as Sound;
		}

		public function getNomPolice(cle : String) : String {
			return (polices[cle] as Font).fontName;
		}

		public function get asynchrone() : Boolean {
			return _asynchrone;
		}

		public function policeExiste(cle : String) : Boolean {
			return polices[cle] !=null;
		}

		public function enleverCaracteresSansFonts(font : String, chaine : String) : String {
			//d�sactivation, emp�che l'activation des liens
			return chaine;
			var police : Font = chercherFont(font);
			//si la police n'est pas là, pas de pb de glyphes
			if(!police) return chaine;
			for (var i : int = 0; i < chaine.length; i++) {
				if (chaine.charAt(i) == "\n" || chaine.charAt(i) == "\r" || "{@}".indexOf(chaine.charAt(i)) != -1) {
					
					continue;
				}
				//on commence par chercher la minuscule
				if (!police.hasGlyphs(chaine.charAt(i))) chaine = chaine.substring(0, i) + chaine.charAt(i).toLowerCase() + chaine.substring(i+1);
				//on met un espace � la place
				if (!police.hasGlyphs(chaine.charAt(i))) chaine = chaine.substring(0, i) + " " + chaine.substring(i+1);
			}
			return chaine;
		}

		private function chercherFont(nom : String) : Font {
			for (var key : String in polices) {
				if(polices[key] is Font)
					if((polices[key] as Font).fontName==nom)
						return polices[key] as Font;
			}
			return null;
		}

		public function get xmlOptions() : XML {
			return embedClass.getOptions();
		}

		public function get xmlParametres() : XML {
			return embedClass.getParametres();
		}


	}
}
class Verrou {
}
