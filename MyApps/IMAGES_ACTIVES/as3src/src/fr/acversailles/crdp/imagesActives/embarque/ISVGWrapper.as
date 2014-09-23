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
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public interface ISVGWrapper extends IEventDispatcher {
		function chargerRessources() : void;

		function construire() : void;

		function get fond() : Bitmap;

		function get titreDescription() : String ;

		function get texteDescription() : String ;

		function getDetail(i : int) : Bitmap;

		function getNbDetails() : uint;

		function isDetailZoomable(i : int) : Boolean;
		
		function isPuce(i : int) : Boolean;		

		function getTexteLegendeDetail(i : int) : String;

		function getTexteQuestionDetail(i : int) : String;

		function getReponseQuestionDetail(i : int) : String;

		function getTitreLegendeDetail(i : int) : String;

		function getTitre() : String;

		function getSource() : String;
		
		function getDate() : String;
		
		function getAuteur() : String;
		
		function getTitreImageSource() : String;

		function getDroits() : String;

		function get feuilleDeStyle() : ByteArray;
		
		function get xmlOptions() : XML;
		
		function get xmlParametres() : XML;

		function getSon(cle : String, numero:int=-1) : Sound;

		function getNomPolice(cle : String) : String;
		
		function get asynchrone() : Boolean;

		function policeExiste(font : String) : Boolean;
		
		function enleverCaracteresSansFonts(font : String, chaine : String) : String;

		


	}
}
