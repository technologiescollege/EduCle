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
package fr.acversailles.crdp.imagesActives.textes.accordeon {
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;

	import fr.acversailles.crdp.imagesActives.data.ContenuXML;

	import flash.display.Sprite;

	/**
	 * @author dornbusch
	 */
	public class Carte extends Sprite {
		private static const DUREE_OUVERTURE : Number = 12;
		private var titre : String;
		private var contenu : String;
		private var largeur : Number;
		private var type : String;
		private var hauteurEnTete : Number;
		private var entete : EnTeteCarte;
		private var corps : CorpsCarte;
		private var hauteurCorps : Number;
		private var tweenDeplacement : Tween;
		private var _positionHaute : Number;
		private var _positionBasse : Number;
		private var _estEnHaut : Boolean;
		private var nameSpaceComportement : Namespace;

		public function Carte(nameSpaceComportement : Namespace, titre : String, contenu : String, largeur : Number, hauteurEnTete : Number, hauteurCorps : Number, type : String, largeurGlissiere : uint, reponse : String = "", paddingHBouton : Number = 0, paddingVBouton : Number = 0, margeSupBouton : Number = 0, rayonAngleBouton : Number = 0, distanceBiseauBouton : Number = 0, distanceOmbreBouton : Number = 0) {
			this.nameSpaceComportement = nameSpaceComportement;
			this.hauteurCorps = hauteurCorps;
			this.hauteurEnTete = hauteurEnTete;
			this.type = type;
			this.largeur = largeur;
			this.contenu = contenu;
			this.titre = titre;
			mettreEnTete();
			mettreCorps(reponse, paddingHBouton, paddingVBouton, margeSupBouton, rayonAngleBouton, distanceBiseauBouton, distanceOmbreBouton, largeurGlissiere);
			_estEnHaut = true;
		}

		private function mettreCorps(reponse:String, paddingH : Number, paddingV : Number, margeSup : Number, rayonAngle : Number, distanceBiseau : Number, distanceOmbre : Number,largeurGlissiere : uint) : void {
			if (type == TypesCartes.QUESTION)
				corps = new CorpsCarteBouton(nameSpaceComportement, contenu, largeur, hauteurCorps, determinerCouleurCorps(), entete.couleurFond, largeurGlissiere, reponse, paddingH, paddingV, margeSup, rayonAngle, distanceBiseau, distanceOmbre);
			else
				corps = new CorpsCarte(contenu, largeur, hauteurCorps, determinerCouleurCorps(), entete.couleurFond, largeurGlissiere);

			addChild(corps);
			corps.y = hauteurEnTete + 1;
		}

		private function mettreEnTete() : void {
			entete = new EnTeteCarte(titre, largeur, hauteurEnTete, type);
			addChild(entete);
		}

		private function determinerCouleurCorps() : uint {
			var couleur : uint;
			switch(type) {
				case TypesCartes.DESCRIPTION:
				case TypesCartes.CONSIGNE_QUIZZ:
					couleur = ContenuXML.instance.getParametreCouleur("color_4");
					break;
				case TypesCartes.DETAIL:
				case TypesCartes.QUESTION:
					couleur = ContenuXML.instance.getParametreCouleur("color_4");
					break;
			}
			return couleur;
		}

		private function creerTweenDeplacement() : void {
			tweenDeplacement = new Tween(this, "y", Regular.easeOut, 0, 0, DUREE_OUVERTURE);
			tweenDeplacement.stop();
		}

		internal function allerPositionHaute() : void {
			if (_estEnHaut)
				return;
			if (!tweenDeplacement)
				creerTweenDeplacement();
			tweenDeplacement.begin = _positionBasse;
			tweenDeplacement.finish = _positionHaute;
			tweenDeplacement.start();
			_estEnHaut = true;
		}

		internal function allerPositionBasse() : void {
			if (!_estEnHaut)
				return;
			if (!tweenDeplacement)
				creerTweenDeplacement();
			tweenDeplacement.begin = _positionHaute;
			tweenDeplacement.finish = _positionBasse;
			tweenDeplacement.start();
			_estEnHaut = false;
		}

		internal function get estEnHaut() : Boolean {
			return _estEnHaut;
		}

		internal function get positionHaute() : Number {
			return _positionHaute;
		}

		internal function set positionHaute(positionHaute : Number) : void {
			_positionHaute = positionHaute;
		}

		internal function get positionBasse() : Number {
			return _positionBasse;
		}

		internal function set positionBasse(positionBasse : Number) : void {
			_positionBasse = positionBasse;
		}

		internal function afficherCorps(bool : Boolean) : void {
			corps.afficher(bool);
		}
		internal function afficherReponse():void {
			(corps as CorpsCarteBouton).afficherReponse();
		}
	}
}
