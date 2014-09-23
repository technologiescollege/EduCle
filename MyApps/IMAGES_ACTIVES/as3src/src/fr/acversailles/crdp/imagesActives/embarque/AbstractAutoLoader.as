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
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public class AbstractAutoLoader extends AbstractRessources implements IRessourcesChargeesClass {
		private var loaderImages : Loader;
		private var pointeurFile : int;
		protected static var clesImages : Array ;
		protected static var clesSons : Array ;
		protected static var urlImages : Array;
		protected static var urlSons : Array;
		private static var images : Object;
		private static var sons : Object;
		private var loaderSons : Sound;
		private var nbObjectsACharger : int;

		public function AbstractAutoLoader(target : IEventDispatcher = null) {
			
			super(target);
		}

		public function demarrerChargement() : void {
			pointeurFile = -1;
			images = new Object();
			nbObjectsACharger = 0;
			nbObjectsACharger+= urlImages? urlImages.length:0;
			nbObjectsACharger+= urlSons? urlSons.length:0;
			chargerImages();
		}

		private function chargerImages() : void {
			if (!urlImages || urlImages.length == 0) signalerFinChargement();
			loaderImages = new Loader();
			loaderImages.contentLoaderInfo.addEventListener(Event.COMPLETE, chargerImageSuivante);
			loaderImages.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, gererErreur);
			loaderImages.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, signalerProgressionChargementImage);
			chargerImageSuivante(null);
		}

		private function gererErreur(event : IOErrorEvent) : void {
			dispatchEvent(new ChargementEvent(ChargementEvent.ERREUR));
		}

		private function signalerProgressionChargementImage(event : ProgressEvent) : void {
			if(loaderImages.contentLoaderInfo.bytesTotal==0) return;
			signalerProgressionChargement(loaderImages.contentLoaderInfo.bytesLoaded/loaderImages.contentLoaderInfo.bytesTotal);
		}
		private function signalerProgressionChargement(progres : Number) : void {
			dispatchEvent(new ChargementEvent(ChargementEvent.PROGRESSION, progres));
		}

		private function chargerImageSuivante(event : Event) : void {
			if (event) {
				images[clesImages[pointeurFile]] = loaderImages.content;
			}
			pointeurFile++;
			dispatchEvent(new ChargementEvent(ChargementEvent.CHARGEMENT_COMMENCE, pointeurFile+1, nbObjectsACharger));
			if (pointeurFile < urlImages.length) {
				loaderImages.load(new URLRequest(urlImages[pointeurFile]));
			} else chargerSons();
		}

		private function chargerSons() : void {
			pointeurFile = -1;
			if (!urlSons || urlSons.length == 0) signalerFinChargement();
			else {
				sons = new Object();
				loaderImages.contentLoaderInfo.removeEventListener(Event.COMPLETE, chargerImageSuivante);
				loaderImages.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, gererErreur);
				chargerSonSuivant(null);
			}
			
		}

		private function chargerSonSuivant(event : Event) : void {
			if (event) {
				loaderSons.removeEventListener(Event.COMPLETE, chargerSonSuivant);
				loaderSons.removeEventListener(IOErrorEvent.IO_ERROR, gererErreur);
				sons[clesSons[pointeurFile]] = loaderSons;
			}
			pointeurFile++;
			dispatchEvent(new ChargementEvent(ChargementEvent.CHARGEMENT_COMMENCE, urlImages.length+ pointeurFile+1, nbObjectsACharger));
			if (pointeurFile < urlSons.length) {
				loaderSons = new Sound();
				loaderSons.addEventListener(Event.COMPLETE, chargerSonSuivant);
				loaderSons.addEventListener(IOErrorEvent.IO_ERROR, gererErreur);
				loaderSons.load(new URLRequest(urlSons[pointeurFile]));
			} else signalerFinChargement();
		}

		private function signalerFinChargement() : void {
			dispatchEvent(new ChargementEvent(ChargementEvent.CHARGEMENT_TERMINE));
		}

		override public function getImage(cle : String) : Bitmap {
			return images[cle];
		}

		override public function getSon(cle : String) : Sound {
			return sons[cle];
		}
	}
}
