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
	import fr.acversailles.crdp.imagesActives.controle.ActionUtilisateurEvent;
	import fr.acversailles.crdp.imagesActives.data.ContenuXML;
	import fr.acversailles.crdp.imagesActives.dispositions.Disposition;
	import fr.acversailles.crdp.imagesActives.dispositions.IDispositionAccordeon;
	import fr.acversailles.crdp.imagesActives.embarque.SVGWrapper;
	import fr.acversailles.crdp.imagesActives.textes.ZoneTexte;
	import fr.acversailles.crdp.imagesActives.textes.boutons.BoutonReponse;

	import org.flexunit.asserts.assertTrue;

	import flash.events.MouseEvent;

	public class ZoneTexteAccordeon extends ZoneTexte {
		private var cartes : Vector.<Carte>;
		private var numeroCarteVisible : int;
		private var hauteurCorpsCartes : Number;

		public function ZoneTexteAccordeon(disposition : IDispositionAccordeon) {
			super(disposition);
			cartes = new Vector.<Carte>();
			determinerHauteurCorpsCartes();
			
		}

		override public function construire(nameSpaceComportement : Namespace) : void {
			super.construire(nameSpaceComportement);
			switch(_disposition.typeAffichage) {
				case Disposition.AFFICHAGE_LEGENDES:
					creerCarteDescriptionAvecLegende();
					creerCartesDetailsAvecLegende();
					determinerEmplacementsCartes();
					numeroCarteVisible = -1;
					ouvrirCarte(0);
					break;
				case Disposition.AFFICHAGE_QUESTIONS:
					creerCarteDescriptionAvecConsigne();
					creerCartesDetailsAvecQuestions();
					determinerEmplacementsCartes();
					numeroCarteVisible = -1;
					ouvrirCarte(0);
					break;
				default:
					assertTrue("ce type d'affichage n'existe pas :" + _disposition.typeAffichage, false);
			}
		}

		private function determinerHauteurCorpsCartes() : void {
			hauteurCorpsCartes = (_disposition as IDispositionAccordeon).getHauteurCorpsCartes();
		}

		private function ouvrirCarte(numero : int) : Boolean {
			if (numero == numeroCarteVisible) return false;
			numeroCarteVisible = numero;
			cartes.forEach(actualiserEtatEtPosition);
			return true;
		}

		private function actualiserEtatEtPosition(carte : Carte, index : int, v : Vector.<Carte>) : void {
			v;
			if (index <= numeroCarteVisible && !carte.estEnHaut) carte.allerPositionHaute();
			else if (index > numeroCarteVisible && carte.estEnHaut) carte.allerPositionBasse();
			cartes[index].afficherCorps(index == numeroCarteVisible);
		}

		private function determinerEmplacementsCartes() : void {
			cartes.forEach(determinerEmplacement);
		}

		private function determinerEmplacement(carte : Carte, index : int, v : Vector.<Carte>) : void {
			v;
			carte.y = index * (_disposition as IDispositionAccordeon).getHauteurEnTetesCartes();
			carte.positionHaute = index * (_disposition as IDispositionAccordeon).getHauteurEnTetesCartes();
			carte.positionBasse = index * (_disposition as IDispositionAccordeon).getHauteurEnTetesCartes() + hauteurCorpsCartes;
			addChild(carte);
		}

		private function creerCarteDescriptionAvecLegende() : void {
			var carteDescription : Carte = new Carte(nameSpaceComportement, SVGWrapper.instance.titreDescription, SVGWrapper.instance.texteDescription, (_disposition as IDispositionAccordeon).getLargeurCartes(), (_disposition as IDispositionAccordeon).getHauteurEnTetesCartes(), hauteurCorpsCartes, TypesCartes.DESCRIPTION, (_disposition as IDispositionAccordeon).getLargeurGlissiere());
			cartes.push(carteDescription);
		}

		private function creerCarteDescriptionAvecConsigne() : void {
			var carteDescription : Carte = new Carte(nameSpaceComportement, ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "quiz_instruction_title"), ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "quiz_instruction_text"), (_disposition as IDispositionAccordeon).getLargeurCartes(), (_disposition as IDispositionAccordeon).getHauteurEnTetesCartes(), hauteurCorpsCartes, TypesCartes.CONSIGNE_QUIZZ, (_disposition as IDispositionAccordeon).getLargeurGlissiere());
			cartes.push(carteDescription);
		}

		private function creerCartesDetailsAvecLegende() : void {
			var nouvelleCarte : Carte;
			for (var i : int = 0; i < SVGWrapper.instance.getNbDetails(); i++) {
				nouvelleCarte = new Carte(nameSpaceComportement, SVGWrapper.instance.getTitreLegendeDetail(i), SVGWrapper.instance.getTexteLegendeDetail(i), (_disposition as IDispositionAccordeon).getLargeurCartes(), (_disposition as IDispositionAccordeon).getHauteurEnTetesCartes(), hauteurCorpsCartes, TypesCartes.DETAIL, (_disposition as IDispositionAccordeon).getLargeurGlissiere());
				cartes.push(nouvelleCarte);
			}
		}

		private function creerCartesDetailsAvecQuestions() : void {
			var nouvelleCarte : Carte;
			for (var i : int = 0; i < SVGWrapper.instance.getNbDetails(); i++) {
				var titreQuestion : String = ContenuXML.instance.getTexteSpecifique(nameSpaceComportement, "question_title") + (i + 1);
				var reponseQuestion : String = SVGWrapper.instance.getReponseQuestionDetail(i);
				nouvelleCarte = new Carte(nameSpaceComportement, titreQuestion, SVGWrapper.instance.getTexteQuestionDetail(i), (_disposition as IDispositionAccordeon).getLargeurCartes(), (_disposition as IDispositionAccordeon).getHauteurEnTetesCartes(), hauteurCorpsCartes, TypesCartes.QUESTION, (_disposition as IDispositionAccordeon).getLargeurGlissiere(), reponseQuestion, (_disposition as IDispositionAccordeon).getPaddingHBoutonreponse(), (_disposition as IDispositionAccordeon).getPaddingVBoutonreponse(), (_disposition as IDispositionAccordeon).getMargeSupBoutonreponse(), (_disposition as IDispositionAccordeon).getRayonAngleBoutonreponse(), (_disposition as IDispositionAccordeon).getDistanceBiseauBoutonreponse(), (_disposition as IDispositionAccordeon).getDistanceOmbreBoutonreponse());
				cartes.push(nouvelleCarte);
			}
		}

		override protected function gererMouseOver(event : MouseEvent) : void {
			// rien

		}

		override protected function gererMouseOut(event : MouseEvent) : void {
			// rien

		}

		override protected function gererMouseUp(event : MouseEvent) : void {
			// rien

		}

		override protected function gererMouseDown(e : MouseEvent) : void {
			var carteCliquee : Carte;
			var numeroCarteCliquee : int;
			if (e.target is EnTeteCarte) {
				carteCliquee = ((e.target as EnTeteCarte).parent as Carte);
				numeroCarteCliquee = cartes.indexOf(carteCliquee);
				avertirClicCarte(numeroCarteCliquee);
			} else if (e.target is BoutonReponse) {
				// on fait un traitement particulier pour retrouver le bouton

				// pas d'appel à super.gererMouseDown(event);

				carteCliquee = (((e.target as BoutonReponse).parent.parent as CorpsCarteBouton).parent as Carte);
				numeroCarteCliquee = cartes.indexOf(carteCliquee);
				avertirClicBoutonReponse(numeroCarteCliquee - 1);
			}
		}

		private function avertirClicCarte(numeroCarteCliquee : int) : void {
			if (numeroCarteCliquee == 0) dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_DOWN_BOUTON_DESCRIPTION));
			else dispatchEvent(new ActionUtilisateurEvent(ActionUtilisateurEvent.MOUSE_DOWN_LEGENDE, numeroCarteCliquee - 1));
		}

		override public function afficherLegendeOuQuestion(numero : int) : void {
			ouvrirCarte(numero + 1);
		}

		override public function afficherDescriptionOuConsigne() : void {
			ouvrirCarte(0);
		}

		override public function masquerTexte() : void {
			// ne rien faire

		}

		override public function afficherReponse(numero : int) : void {
			cartes[numero + 1].afficherReponse();
		}
	}
	// end class

} // end package
