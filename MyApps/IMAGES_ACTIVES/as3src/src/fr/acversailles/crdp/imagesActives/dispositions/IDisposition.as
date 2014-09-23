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
package fr.acversailles.crdp.imagesActives.dispositions {
	import fr.acversailles.crdp.imagesActives.image.details.IDetail;
	import fr.acversailles.crdp.imagesActives.infos.IZoneInfosDroits;
	import fr.acversailles.crdp.imagesActives.textes.IZoneTexte;

	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author Joachim Dornbusch CRDP Académie de Versailles
	 */
	public interface IDisposition {
		function disposerFondImage() : void;

		function disposerDetail(detail : IDetail) : void;

		function get typeAffichage() : uint;

		function get xFond() : Number;

		function get yFond() : Number;

		function getMasqueImage() : Shape;

		function getMasqueGlobal() : Shape;

		function get largeurFond() : Number;

		function get largeurTotale() : Number;

		function get hauteurFond() : Number;

		function get hauteurTotale() : Number;

		function dessinerFond(main : Sprite) : void;

		function placerZoneTexte(zoneTexte : IZoneTexte) : void;

		function placerTitre(zoneTitre : TextField) : void;

		function placerZoneInfosDroits(zoneInfosDroits : TextField) : void;

		function placerBouton(boutonEcran : SimpleButton, superposer : Boolean = false) : void;

		function creerZoneInfosDroits() : IZoneInfosDroits;

		function hauteurBoutonZoneInfosDroits() : Number;

		function margeGaucheBoutonZoneInfosDroits() : Number;

		function hauteurOngletZoneInfosDroits() : Number;

		function get rayonArc() : Number

		function hauteurVisibleZoneInfos() : Number;

		function largeurBoutonZoneInfosDroits() : Number;

		function largeurOngletZoneInfosDroits() : Number;

		function margeInfZoneInfosDroits() : Number;

		function getHauteurSoulevementZoneInfosDroits() : Number;

		function getDureeEstompageImage() : Number;

		function largeurTootlTips() : Number;

		function getPaddingHBoiteMotDePasse() : Number;

		function getPaddingVBoiteMotDePasse() : Number;

		function getRayonAngleBoiteMotDePasse() : Number;

		function getLargeurZoneInputMotDePasse() : Number;

		function getPaddingHBoutonreponse() : Number;

		function getPaddingVBoutonreponse() : Number;

		function getMargeSupBoutonreponse() : Number;

		function getRayonAngleBoutonreponse() : Number;

		function getDistanceBiseauBoutonreponse() : Number;

		function getDistanceOmbreBoutonreponse() : Number;

		function getProportionMaxFenetreCredits() : Number;

		function detailsPucesVisibles() : Boolean;

	}
}
